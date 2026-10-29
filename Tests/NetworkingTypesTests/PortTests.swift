//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2026 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import NetworkingTypes
import Testing

@Suite
struct PortTests {
    @Test func port() {
        #expect(Port(0) == Port(rawValue: 0))
        #expect(Port(81) == Port(rawValue: 81))
        #expect(Port(443) == Port(rawValue: 443))
        #expect(Port(5353) == Port(rawValue: 5353))
        #expect(Port(18610) == Port(rawValue: 18610))
        #expect(Port(65535) == Port(rawValue: 65535))
    }

    @Test func `Port description and parsing work as expected`() {
        for number in UInt16.min...UInt16.max {
            let port = Port(rawValue: number)
            let description = port.description
            #expect(description == String(number))
            #expect(Port(description) == port)
            #expect(Port(Substring(description)) == port)
        }
    }

    @Test(
        arguments: [String]([
            "",
            " ",
            "-1",
            "65536",
            "99999",
            "123456",
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
    }

    @Test(
        arguments: [(description: String, port: Port)]([
            (description: "0", port: 0),
            (description: "00", port: 0),
            (description: "000", port: 0),
            (description: "0000", port: 0),
            (description: "00000", port: 0),
            (description: "01", port: 1),
            (description: "080", port: 80),
            (description: "00080", port: 80),
            (description: "00443", port: 443),
            (description: "065535", port: 65535),
            (description: "000000", port: 0),
            (description: "0065535", port: 65535),
        ])
    )
    func `Port tolerates leading zeros`(description: String, port: Port) {
        #expect(Port(description) == port)
        #expect(Port(Substring(description)) == port)
    }
}

#if os(macOS) || os(Linux)
extension PortTests {
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
