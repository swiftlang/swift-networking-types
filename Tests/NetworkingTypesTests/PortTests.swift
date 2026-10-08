//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift open source project
//
// Copyright (c) 2026 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of Swift project authors
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import NetworkingTypes
import Testing

@Suite
struct PortTests {
    @Test func port() {
        /// Use non-literal `Int`s so the `init(_ value: Int)` overload is exercised
        /// instead of `init(integerLiteral:)`.
        let low = 0
        let high = 65535
        #expect(Port(low) == Port(rawValue: 0))
        #expect(Port(high) == Port(rawValue: 65535))
        #expect(Port(low).value == 0)
        #expect(Port(high).value == 65535)
        #expect(Port(rawValue: 443).value == 443)
    }

    @available(SwiftStdlib 6.2, *)
    @Test func `Port description and parsing work as expected`() {
        for number in UInt16.min...UInt16.max {
            let port = Port(rawValue: number)
            let description = port.description
            #expect(port.description == description)
            #expect(Port(description) == port)
            #expect(Port(Substring(description)) == port)
            #expect(Port(textualRepresentation: description.utf8Span) == port)
            #expect(Port(textualRepresentation: description.utf8Span.span) == port)
            description.withCString { #expect(unsafe Port(cString: $0) == port) }

            let produced = port.withCString { span in
                #expect(span.count == description.utf8.count + 1)
                return span.withUnsafeBufferPointer {
                    unsafe String(cString: $0.baseAddress!)
                }
            }
            #expect(produced == description)
        }
    }

    @available(SwiftStdlib 6.2, *)
    @Test(
        arguments: [String]([
            "",
            " ",
            "-1",
            "+1",
            "65536",
            "99999",
            "123456",
            "000000",
            "0x10",
            "80 ",
            " 80",
            "8_0",
            "8.0",
            "/",
            ":",
            ";",
            "/80",
            "80:",
            "8:0",
            "1/2",
            ":6553",
            "6553:",
            "٨٠",
        ])
    )
    func `Port rejects invalid textual representations`(description: String) {
        #expect(Port(description) == nil)
        #expect(Port(Substring(description)) == nil)
        #expect(Port(textualRepresentation: description.utf8Span) == nil)
        #expect(Port(textualRepresentation: description.utf8Span.span) == nil)
        description.withCString { #expect(unsafe Port(cString: $0) == nil) }
    }

    @available(SwiftStdlib 6.2, *)
    @Test(
        arguments: [(description: String, port: Port?)]([
            (description: "0", port: 0),
            (description: "00", port: 0),
            (description: "000", port: 0),
            (description: "0000", port: 0),
            (description: "00000", port: 0),
            (description: "01", port: 1),
            (description: "080", port: 80),
            (description: "00080", port: 80),
            (description: "00443", port: 443),
            (description: "065535", port: nil),
            (description: "000000", port: nil),
            (description: "0065535", port: nil),
        ])
    )
    func `Port tolerates leading zeros up to 5 digits`(description: String, port: Port?) {
        #expect(Port(description) == port)
        #expect(Port(Substring(description)) == port)
        #expect(Port(textualRepresentation: description.utf8Span) == port)
        #expect(Port(textualRepresentation: description.utf8Span.span) == port)
        description.withCString { #expect(unsafe Port(cString: $0) == port) }
    }

    @Test(arguments: [0] + Array(6...16))
    func `Port rejects spans whose length is outside 1...5`(count: Int) {
        let bytes = ContiguousArray<UInt8>(repeating: 0x30, count: count)
        #expect(Port(textualRepresentation: bytes.span) == nil)
    }

    @Test(arguments: UInt8.min...UInt8.max)
    func `Port parsing exhaustive byte-substitution test`(byte: UInt8) {

        func slowParsePort(_ bytes: ContiguousArray<UInt8>) -> Port? {
            guard bytes.count >= 1, bytes.count <= 5 else {
                return nil
            }

            var value = 0
            for byte in bytes {
                guard byte >= 0x30, byte <= 0x39 else {
                    return nil
                }
                value = value * 10 + Int(byte - 0x30)
            }

            guard value <= 65535 else {
                return nil
            }

            return Port(value)
        }

        for count in 1...5 {
            let digits = ContiguousArray("65535".utf8.prefix(count))
            for position in 0..<count {
                var bytes = digits
                bytes[position] = byte
                #expect(Port(textualRepresentation: bytes.span) == slowParsePort(bytes))
            }

            let repeated = ContiguousArray(repeating: byte, count: count)
            #expect(Port(textualRepresentation: repeated.span) == slowParsePort(repeated))
        }
    }

    @available(SwiftStdlib 5.1, *)
    @Test func `Port parses StaticString exactly like String`() {
        #expect(("0" as Port) == Port("0" as String))
        #expect(("5" as Port) == Port("5" as String))
        #expect(("80" as Port) == Port("80" as String))
        #expect(("443" as Port) == Port("443" as String))
        #expect(("8080" as Port) == Port("8080" as String))
        #expect(("00080" as Port) == Port("00080" as String))
        #expect(("65535" as Port) == Port("65535" as String))

        #expect(("8080" as Port) == 8080)
        #expect(("65535" as Port) == 65535)
    }

    /// A bare string literal must reach the `ExpressibleByStringLiteral` init, not the `String` one.
    @available(SwiftStdlib 5.1, *)
    @Test func `Port parses string literals`() {
        let zero: Port = "0"
        #expect(zero == 0)

        let https: Port = "443"
        #expect(https == 443)

        let max: Port = "65535"
        #expect(max == 65535)
    }

}

#if os(macOS) || os(Linux)
extension PortTests {
    @Test func `Port initializer crashes on an invalid StaticString`() async {
        await #expect(processExitsWith: .failure) {
            blackHole("" as Port)
        }
        await #expect(processExitsWith: .failure) {
            blackHole("65536" as Port)
        }
        await #expect(processExitsWith: .failure) {
            blackHole("80a0" as Port)
        }
    }

    @Test func `Port initializer crashes when the value is out of bounds`() async {
        await #expect(processExitsWith: .failure) {
            blackHole(Port(noOptimize(-1)))
        }
        await #expect(processExitsWith: .failure) {
            blackHole(Port(noOptimize(65536)))
        }
        await #expect(processExitsWith: .failure) {
            blackHole(Port(noOptimize(Int.min)))
        }
        await #expect(processExitsWith: .failure) {
            blackHole(Port(noOptimize(Int.max)))
        }
    }
}
#endif
