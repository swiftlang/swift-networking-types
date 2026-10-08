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

/// A port number for networking operations.
///
/// Port numbers are 16-bit values, inclusively between 0 and 65535, as defined in [IETF RFC 6335].
///
/// [IETF RFC 6335]: https://datatracker.ietf.org/doc/html/rfc6335
public struct Port: Sendable, Hashable, RawRepresentable {
    /// The canonical value of the port.
    public let rawValue: UInt16

    /// Convenience accessor for the canonical rawValue.
    @inlinable
    public var value: Int {
        Int(self.rawValue)
    }

    /// Create a new port with the given canonical rawValue.
    @inlinable
    public init(rawValue: UInt16) {
        self.rawValue = rawValue
    }

    /// Create a new port with the given value.
    /// Precondition: the value must be inclusively between 0 and 65535 (UInt16.max).
    @inlinable
    public init(_ value: Int) {
        guard let rawValue = UInt16(exactly: value) else {
            preconditionFailure("Port must be inclusively between 0 and 65535")
        }
        self.rawValue = rawValue
    }
}

extension Port: ExpressibleByIntegerLiteral {
    /// Create a new port with the given canonical value.
    @inlinable
    public init(integerLiteral value: UInt16) {
        self.init(rawValue: value)
    }
}
