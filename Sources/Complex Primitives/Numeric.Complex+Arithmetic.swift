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

// MARK: - Addition

extension Numeric.Complex {
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(lhs.real + rhs.real, lhs.imaginary + rhs.imaginary)
    }

    @inlinable
    public static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }

    @inlinable
    public static func + (lhs: Self, rhs: Scalar) -> Self {
        Self(lhs.real + rhs, lhs.imaginary)
    }

    @inlinable
    public static func + (lhs: Scalar, rhs: Self) -> Self {
        Self(lhs + rhs.real, rhs.imaginary)
    }
}

// MARK: - Subtraction

extension Numeric.Complex {
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(lhs.real - rhs.real, lhs.imaginary - rhs.imaginary)
    }

    @inlinable
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }

    @inlinable
    public static func - (lhs: Self, rhs: Scalar) -> Self {
        Self(lhs.real - rhs, lhs.imaginary)
    }

    @inlinable
    public static func - (lhs: Scalar, rhs: Self) -> Self {
        Self(lhs - rhs.real, -rhs.imaginary)
    }
}

// MARK: - Negation

extension Numeric.Complex {
    @inlinable
    public static prefix func - (z: Self) -> Self {
        Self(-z.real, -z.imaginary)
    }
}

// MARK: - Multiplication

extension Numeric.Complex {
    /// (a + bi)(c + di) = (ac - bd) + (ad + bc)i
    @inlinable
    public static func * (lhs: Self, rhs: Self) -> Self {
        Self(
            lhs.real * rhs.real - lhs.imaginary * rhs.imaginary,
            lhs.real * rhs.imaginary + lhs.imaginary * rhs.real
        )
    }

    @inlinable
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }

    // Note: @_disfavoredOverload is used to avoid type inference ambiguity
    // with integer literals. See: Apple swift-numerics Scale.swift for rationale.
    // When Swift's type inference improves, this attribute can be removed.

    @_disfavoredOverload
    @inlinable
    public static func * (lhs: Self, rhs: Scalar) -> Self {
        Self(lhs.real * rhs, lhs.imaginary * rhs)
    }

    @_disfavoredOverload
    @inlinable
    public static func * (lhs: Scalar, rhs: Self) -> Self {
        Self(lhs * rhs.real, lhs * rhs.imaginary)
    }
}

// MARK: - Division

extension Numeric.Complex {
    /// Complex division with robust handling of overflow and underflow.
    ///
    /// Uses the naive formula when |w|² is normal, and Priest's rescaling
    /// algorithm otherwise to avoid spurious overflow/underflow.
    @inlinable
    public static func / (lhs: Self, rhs: Self) -> Self {
        let lengthSquared = rhs.magnitude.squared
        guard lengthSquared.isNormal else {
            return rescaledDivide(lhs, rhs)
        }
        return lhs * rhs.conjugate.scalar.divide(by: lengthSquared)
    }

    /// Rescaled division for when naive division would overflow or underflow.
    ///
    /// Algorithm adapted from Doug Priest's "Efficient Scaling for Complex Division".
    @usableFromInline
    @inline(never)
    internal static func rescaledDivide(_ z: Self, _ w: Self) -> Self {
        if w.isZero { return .infinity }
        if !w.isFinite { return .zero }

        // Infinity-norm of w
        let wMagnitude = max(w.real.magnitude, w.imaginary.magnitude)

        // If w is subnormal, scale up to avoid issues with types like Float16
        // where leastNormalMagnitude^(-3/4) isn't representable.
        if wMagnitude < .leastNormalMagnitude {
            let s = 1 / (Scalar(Scalar.radix) * .leastNormalMagnitude)
            let wPrime = w.scalar.multiply(by: s)
            let zPrime = z.scalar.multiply(by: s)
            return zPrime / wPrime
        }

        // Choose scale s ~ |w|^(-3/4), an exact power of the radix.
        // This ensures wPrime ~ |w|^(1/4), avoiding overflow/underflow.
        let s = Scalar(
            sign: .plus,
            exponent: -3 * wMagnitude.exponent / 4,
            significand: 1
        )
        let wPrime = w.scalar.multiply(by: s)
        let zPrime = z.scalar.multiply(by: s)
        return zPrime * wPrime.conjugate.scalar.divide(by: wPrime.magnitude.squared)
    }

    @inlinable
    public static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }

    @_disfavoredOverload
    @inlinable
    public static func / (lhs: Self, rhs: Scalar) -> Self {
        Self(lhs.real / rhs, lhs.imaginary / rhs)
    }

    @_disfavoredOverload
    @inlinable
    public static func / (lhs: Scalar, rhs: Self) -> Self {
        Self(lhs, .zero) / rhs
    }
}

// MARK: - Conjugate

extension Numeric.Complex {
    /// Returns the complex conjugate.
    ///
    /// The conjugate of `a + bi` is `a - bi`.
    @inlinable
    public static func conjugate(of z: Self) -> Self {
        Self(z.real, -z.imaginary)
    }

    /// The complex conjugate.
    @inlinable
    public var conjugate: Self {
        Self.conjugate(of: self)
    }
}

// MARK: - Reciprocal

extension Numeric.Complex {
    /// Returns the multiplicative inverse.
    ///
    /// The reciprocal of `z` is `1/z = conjugate(z) / |z|²`.
    @inlinable
    public static func reciprocal(of z: Self) -> Self {
        let denom = z.real * z.real + z.imaginary * z.imaginary
        return Self(z.real / denom, -z.imaginary / denom)
    }

    /// The multiplicative inverse.
    @inlinable
    public var reciprocal: Self {
        Self.reciprocal(of: self)
    }
}
