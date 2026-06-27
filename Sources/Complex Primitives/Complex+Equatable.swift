// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-primitives open source project
//
// Copyright (c) 2024-2025 Coen ten Thije Boonkkamp and the swift-primitives
// project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

extension Complex.Number: Equatable where Scalar: Equatable {
    /// Returns whether two complex numbers are componentwise equal.
    @inlinable
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.real == rhs.real && lhs.imaginary == rhs.imaginary
    }
}
