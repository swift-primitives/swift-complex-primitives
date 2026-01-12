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
    /// Accessor for magnitude operations on complex numbers.
    ///
    /// ```swift
    /// let z = Numeric.Complex(3.0, 4.0)
    /// let r = z.magnitude()        // Real(5.0) (Euclidean norm)
    /// let r2 = z.magnitude.squared // Real(25.0) (faster, no sqrt)
    /// ```
    public struct Magnitude {
        @usableFromInline
        let complex: Numeric.Complex<Scalar>

        @usableFromInline
        internal init(_ complex: Numeric.Complex<Scalar>) {
            self.complex = complex
        }
    }
}

extension Numeric.Complex.Magnitude: Sendable where Scalar: Sendable {}

// MARK: - Accessor

extension Numeric.Complex {
    /// Access magnitude operations.
    ///
    /// ```swift
    /// z.magnitude()        // Euclidean norm √(x² + y²)
    /// z.magnitude.squared  // x² + y² (faster)
    /// ```
    @inlinable
    public var magnitude: Magnitude {
        Magnitude(self)
    }
}

// MARK: - Double

extension Numeric.Complex.Magnitude where Scalar == Double {
    /// The Euclidean norm (absolute value) of this complex number.
    ///
    /// Computed as `√(real² + imaginary²)` using `hypot` to avoid overflow.
    /// Returns a typed `Real` since magnitude is always real.
    @inlinable
    public func callAsFunction() -> Numeric.Real<Scalar> {
        Numeric.Real(Double.math.hypot(complex.real._value, complex.imaginary._value))
    }

    /// The squared magnitude.
    ///
    /// More efficient than `magnitude()` when only relative comparisons
    /// are needed or when the square is required.
    @inlinable
    public var squared: Numeric.Real<Scalar> {
        Numeric.Real(complex.real._value * complex.real._value + complex.imaginary._value * complex.imaginary._value)
    }
}

// MARK: - Float

extension Numeric.Complex.Magnitude where Scalar == Float {
    /// The Euclidean norm (absolute value) of this complex number.
    @inlinable
    public func callAsFunction() -> Numeric.Real<Scalar> {
        Numeric.Real(Float.math.hypot(complex.real._value, complex.imaginary._value))
    }

    /// The squared magnitude.
    @inlinable
    public var squared: Numeric.Real<Scalar> {
        Numeric.Real(complex.real._value * complex.real._value + complex.imaginary._value * complex.imaginary._value)
    }
}
