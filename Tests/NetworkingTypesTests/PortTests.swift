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
    @available(anyAppleOS 27.0, *)
    @Test(arguments: PortTestCase.allCases)
    func `Port byte-order initializers work correctly`(testCase: PortTestCase) {
        guard let testCaseValue = testCase.value else { return }

        let littleEndian = Port(numericValue: testCaseValue.littleEndian)
        let littleEndian2 = Port(integerLiteral: testCaseValue.littleEndian)
        let littleEndian3 = Port(numericValue: testCaseValue.littleEndian, byteOrder: .littleEndian)
        let bigEndian = Port(numericValue: testCaseValue.bigEndian, byteOrder: .bigEndian)
        let plainInt = Port(Int(testCaseValue.littleEndian))

        #expect(littleEndian == littleEndian2)
        #expect(littleEndian == littleEndian3)
        #expect(littleEndian == bigEndian)
        #expect(littleEndian == plainInt)
    }

    @Test(arguments: PortTestCase.allCases)
    func `Port description and parsing work as expected`(testCase: PortTestCase) {
        let port1 = Port(testCase.description)
        let port2 = Port(Substring(testCase.description))
        #expect(port1?.description == testCase.expectedDescription)
        #expect(port2?.description == testCase.expectedDescription)
    }

    @available(anyAppleOS 27.0, *)
    @Test func `Exhaustive Port description and parsing`() {
        for number in UInt16.min...UInt16.max {
            let port = Port(numericValue: number)
            let description = port.description
            #expect(description == String(number))
            #expect(Port(description) == port)
            #expect(Port(Substring(description)) == port)
        }
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

struct PortTestCase {
    struct Value {
        let littleEndian: UInt16
        let bigEndian: UInt16

        init(nativeEndian: UInt16) {
            self.littleEndian = nativeEndian.littleEndian
            self.bigEndian = nativeEndian.bigEndian
        }
    }

    let description: String
    let expectedDescription: String?
    let value: Value?

    init(_ description: String, expectedDescription: String? = nil, _ value: Value?) {
        self.description = description
        self.value = value
        if let expectedDescription {
            self.expectedDescription = expectedDescription
        } else if value == nil {
            self.expectedDescription = nil
        } else {
            self.expectedDescription = description
        }
    }

    static let invalidCases: [PortTestCase] = [
        "", " ", "-1", "65536", "111111", "99999", "123456", "0x10", "80 ", " 80", "8_0",
        "8.0", "/", ":", ";", "/80", "80:", "8:0", "1/2", ":6553", "6553:", "٨٠",
    ].map { PortTestCase($0, nil) }

    static let validCases: [PortTestCase] = [
        PortTestCase("0", Value(nativeEndian: 0)),
        PortTestCase("00", expectedDescription: "0", Value(nativeEndian: 0)),
        PortTestCase("000", expectedDescription: "0", Value(nativeEndian: 0)),
        PortTestCase("0000", expectedDescription: "0", Value(nativeEndian: 0)),
        PortTestCase("00000", expectedDescription: "0", Value(nativeEndian: 0)),
        PortTestCase("000000", expectedDescription: "0", Value(nativeEndian: 0)),
        PortTestCase("7", Value(nativeEndian: 7)),
        PortTestCase("80", Value(nativeEndian: 80)),
        PortTestCase("443", Value(nativeEndian: 443)),
        PortTestCase("5353", Value(nativeEndian: 5353)),
        PortTestCase("65535", Value(nativeEndian: 65535)),
        PortTestCase("065535", expectedDescription: "65535", Value(nativeEndian: 65535)),
    ]

    static var allCases: [PortTestCase] {
        invalidCases + validCases
    }
}
