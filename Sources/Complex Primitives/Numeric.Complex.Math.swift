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
    /// Accessor for elementary mathematical operations on complex numbers.
    ///
    /// Provides exp, log, trigonometric, hyperbolic, and power functions
    /// with branch cuts following Kahan's conventions.
    ///
    /// ```swift
    /// let z = Numeric.Complex(1.0, 2.0)
    /// let w = z.math.exp()              // e^z
    /// let u = z.math.log()              // ln(z)
    /// let v = z.math.sin()              // sin(z)
    /// ```
    public struct Math {
        @usableFromInline
        let complex: Numeric.Complex<Scalar>

        @usableFromInline
        internal init(_ complex: Numeric.Complex<Scalar>) {
            self.complex = complex
        }
    }
}

extension Numeric.Complex.Math: Sendable where Scalar: Sendable {
}

// MARK: - Instance Accessor

extension Numeric.Complex {
    /// Access mathematical operations on this complex number.
    ///
    /// ```swift
    /// z.math.exp()    // e^z
    /// z.math.log()    // ln(z)
    /// z.math.sqrt()   // √z
    /// ```
    @inlinable
    public var math: Math {
        Math(self)
    }
}
