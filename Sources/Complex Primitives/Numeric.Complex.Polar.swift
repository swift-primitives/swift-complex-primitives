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

extension Numeric.Complex {
    /// Accessor struct for polar form operations on complex numbers.
    ///
    /// Access via the `.polar` property:
    ///
    /// ```swift
    /// let z = Numeric.Complex(3.0, 4.0)
    /// z.polar.length  // Modulus.Value(5.0)
    /// z.polar.phase   // Radian(atan2(4, 3))
    /// ```
    public struct Polar {
        @usableFromInline
        let complex: Numeric.Complex<Scalar>

        @usableFromInline
        internal init(_ complex: Numeric.Complex<Scalar>) {
            self.complex = complex
        }
    }
}

extension Numeric.Complex.Polar: Sendable where Scalar: Sendable {}
