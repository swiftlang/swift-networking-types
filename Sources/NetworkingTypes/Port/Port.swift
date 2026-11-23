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

/// A port number for networking operations.
///
/// Port numbers are 16-bit values, inclusively between 0 and 65535, as defined in [IETF RFC 6335].
///
/// [IETF RFC 6335]: https://datatracker.ietf.org/doc/html/rfc6335
public struct Port: Sendable, Hashable {
    /// The canonical value of the port.
    public var rawValue: UInt16

    /// Create a new port with the given value and byte order.
    ///
    /// - Parameters:
    ///   - rawValue: The integer to create the port from.
    ///   - byteOrder: The byte order of the integer.
    @inlinable
    @available(anyAppleOS 27.0, *)
    public init(numericValue: UInt16, byteOrder: ByteOrder = .native) {
        self.rawValue =
            switch byteOrder {
            case .bigEndian: numericValue.bigEndian
            case .littleEndian: numericValue.littleEndian
            }
    }

    /// Create a new port with the given value.
    ///
    /// Precondition: the value must be inclusively between 0 and 65535 (UInt16.max).
    ///
    /// - Parameters:
    ///   - value: The integer to create the port from.
    @inlinable
    public init(_ value: Int) {
        guard let rawValue = UInt16(exactly: value) else {
            fatalError("Port must be inclusively between 0 and 65535")
        }
        self.rawValue = rawValue
    }
}

extension Port: ExpressibleByIntegerLiteral {
    /// Create a new port with the given canonical value.
    ///
    /// - Parameters:
    ///   - integerLiteral: The integer to create the port from.
    @inlinable
    public init(integerLiteral value: UInt16) {
        self.rawValue = value
    }
}

extension Port: CustomStringConvertible {
    /// The textual representation of a port, in decimal notation and without leading zeros.
    /// For example `Port(8080)` is represented as `"8080"`.
    @inlinable
    public var description: String {
        self.rawValue.description
    }
}

extension Port: LosslessStringConvertible {
    /// Initialize a `Port` from its textual representation.
    /// That is, at most 5 decimal digits amounting to a value of at most 65535.
    /// For example `"8080"` will parse into `Port(8080)`.
    ///
    /// - Parameters:
    ///   - description: The textual representation of the port.
    @inlinable
    public init?(_ description: some StringProtocol) {
        guard let value = UInt16(description) else {
            return nil
        }
        self.rawValue = value
    }
}
