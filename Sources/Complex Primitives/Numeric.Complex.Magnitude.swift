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
    /// let r = z.magnitude()        // 5.0 (Euclidean norm)
    /// let r2 = z.magnitude.squared // 25.0 (faster, no sqrt)
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

extension Numeric.Complex.Magnitude: Sendable where Scalar: Sendable {
}

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

// MARK: - Primary Operation

extension Numeric.Complex.Magnitude {
    /// The Euclidean norm (absolute value) of this complex number.
    ///
    /// Computed as `√(real² + imaginary²)` using `hypot` to avoid overflow.
    @inlinable
    public func callAsFunction() -> Scalar {
        Scalar.math.hypot(complex.real, complex.imaginary)
    }
}

// MARK: - Squared

extension Numeric.Complex.Magnitude {
    /// The squared magnitude.
    ///
    /// More efficient than `magnitude()` when only relative comparisons
    /// are needed or when the square is required.
    @inlinable
    public var squared: Scalar {
        complex.real * complex.real + complex.imaginary * complex.imaginary
    }
}
