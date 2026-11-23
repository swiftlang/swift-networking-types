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

/// Stops the compiler from optimizing the argument away.
@_optimize(none)
func blackHole(_: some Any) {}

/// Returns its argument as-is while ensuring the compiler does not optimize it away.
@_optimize(none)
func noOptimize<T>(_ value: T) -> T {
    value
}
