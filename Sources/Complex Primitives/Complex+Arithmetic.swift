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

// MARK: - BinaryFloatingPoint

extension Complex.Number where Scalar: BinaryFloatingPoint {
    // MARK: Addition

    /// Returns the sum of two complex numbers.
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(real: lhs.real + rhs.real, imaginary: lhs.imaginary + rhs.imaginary)
    }

    /// Adds a complex number into this value in place.
    @inlinable
    public static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }

    /// Returns the sum of a complex number and a real number.
    @inlinable
    public static func + (lhs: Self, rhs: Complex.Real<Scalar>) -> Self {
        Self(real: lhs.real + rhs, imaginary: lhs.imaginary)
    }

    /// Returns the sum of a real number and a complex number.
    @inlinable
    public static func + (lhs: Complex.Real<Scalar>, rhs: Self) -> Self {
        Self(real: lhs + rhs.real, imaginary: rhs.imaginary)
    }

    /// Returns the sum of a complex number and an imaginary number.
    @inlinable
    public static func + (lhs: Self, rhs: Complex.Imaginary<Scalar>) -> Self {
        Self(real: lhs.real, imaginary: lhs.imaginary + rhs)
    }

    /// Returns the sum of an imaginary number and a complex number.
    @inlinable
    public static func + (lhs: Complex.Imaginary<Scalar>, rhs: Self) -> Self {
        Self(real: rhs.real, imaginary: lhs + rhs.imaginary)
    }

    // MARK: Subtraction

    /// Returns the difference of two complex numbers.
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(real: lhs.real - rhs.real, imaginary: lhs.imaginary - rhs.imaginary)
    }

    /// Subtracts a complex number from this value in place.
    @inlinable
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }

    /// Returns the difference of a complex number and a real number.
    @inlinable
    public static func - (lhs: Self, rhs: Complex.Real<Scalar>) -> Self {
        Self(real: lhs.real - rhs, imaginary: lhs.imaginary)
    }

    /// Returns the difference of a real number and a complex number.
    @inlinable
    public static func - (lhs: Complex.Real<Scalar>, rhs: Self) -> Self {
        Self(real: lhs - rhs.real, imaginary: -rhs.imaginary)
    }

    /// Returns the difference of a complex number and an imaginary number.
    @inlinable
    public static func - (lhs: Self, rhs: Complex.Imaginary<Scalar>) -> Self {
        Self(real: lhs.real, imaginary: lhs.imaginary - rhs)
    }

    /// Returns the difference of an imaginary number and a complex number.
    @inlinable
    public static func - (lhs: Complex.Imaginary<Scalar>, rhs: Self) -> Self {
        Self(real: -rhs.real, imaginary: lhs - rhs.imaginary)
    }

    // MARK: Negation

    /// Returns the additive inverse of a complex number.
    @inlinable
    public static prefix func - (z: Self) -> Self {
        Self(real: -z.real, imaginary: -z.imaginary)
    }

    // MARK: Multiplication

    /// Returns the product of two complex numbers.
    ///
    /// Computed as `(a + bi)(c + di) = (ac - bd) + (ad + bc)i`. Component
    /// arithmetic happens at the computation boundary on raw scalar values.
    @inlinable
    public static func * (lhs: Self, rhs: Self) -> Self {
        let a = lhs.real._value
        let b = lhs.imaginary._value
        let c = rhs.real._value
        let d = rhs.imaginary._value
        return Self(a * c - b * d, a * d + b * c)
    }

    /// Multiplies this value by a complex number in place.
    @inlinable
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }

    /// Returns the product of a complex number and a real number.
    ///
    /// Scales both components by the real factor.
    @inlinable
    public static func * (lhs: Self, rhs: Complex.Real<Scalar>) -> Self {
        Self(real: lhs.real * rhs, imaginary: Complex.Imaginary(lhs.imaginary._value * rhs._value))
    }

    /// Returns the product of a real number and a complex number.
    @inlinable
    public static func * (lhs: Complex.Real<Scalar>, rhs: Self) -> Self {
        rhs * lhs
    }

    /// Returns the product of a complex number and an imaginary number.
    ///
    /// Computed as `(a + bi)(di) = -bd + adi`.
    @inlinable
    public static func * (lhs: Self, rhs: Complex.Imaginary<Scalar>) -> Self {
        let a = lhs.real._value
        let b = lhs.imaginary._value
        let d = rhs._value
        return Self(-b * d, a * d)
    }

    /// Returns the product of an imaginary number and a complex number.
    @inlinable
    public static func * (lhs: Complex.Imaginary<Scalar>, rhs: Self) -> Self {
        rhs * lhs
    }

    // MARK: Division

    /// Returns the quotient of two complex numbers, robustly handling overflow and underflow.
    ///
    /// Uses the naive formula when |w|² is normal, and Priest's rescaling
    /// algorithm otherwise to avoid spurious overflow/underflow.
    @inlinable
    public static func / (lhs: Self, rhs: Self) -> Self {
        let lengthSquared = rhs.real._value * rhs.real._value + rhs.imaginary._value * rhs.imaginary._value
        guard lengthSquared.isNormal else {
            return rescaledDivide(lhs, rhs)
        }
        // z / w = z * conjugate(w) / |w|²
        let a = lhs.real._value
        let b = lhs.imaginary._value
        let c = rhs.real._value
        let d = rhs.imaginary._value
        return Self(
            (a * c + b * d) / lengthSquared,
            (b * c - a * d) / lengthSquared
        )
    }

    /// Rescaled division for when naive division would overflow or underflow.
    ///
    /// Algorithm adapted from Doug Priest's "Efficient Scaling for Complex Division".
    @usableFromInline
    @inline(never)
    internal static func rescaledDivide(_ z: Self, _ w: Self) -> Self {
        if w.isZero { return .infinity }
        if !z.isFinite || !w.isFinite {
            return .zero
        }

        // Infinity-norm of w
        let wMagnitude = max(w.real.abs._value, w.imaginary.abs._value)

        // If w is subnormal, scale up
        if wMagnitude < Scalar.leastNormalMagnitude {
            let s: Scalar = 1 / (Scalar(Scalar.radix) * Scalar.leastNormalMagnitude)
            let wPrime = Self(w.real._value * s, w.imaginary._value * s)
            let zPrime = Self(z.real._value * s, z.imaginary._value * s)
            return Self.rescaledDivide(zPrime, wPrime)
        }

        // Choose scale s ~ |w|^(-3/4)
        let s = Scalar(
            sign: .plus,
            exponent: -3 * wMagnitude.exponent / 4,
            significand: 1
        )
        let wPrime = Self(w.real._value * s, w.imaginary._value * s)
        let zPrime = Self(z.real._value * s, z.imaginary._value * s)
        let wPrimeLengthSq = wPrime.real._value * wPrime.real._value + wPrime.imaginary._value * wPrime.imaginary._value
        let a = zPrime.real._value
        let b = zPrime.imaginary._value
        let c = wPrime.real._value
        let d = wPrime.imaginary._value
        return Self(
            (a * c + b * d) / wPrimeLengthSq,
            (b * c - a * d) / wPrimeLengthSq
        )
    }

    /// Divides this value by a complex number in place.
    @inlinable
    public static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }

    /// Returns the quotient of a complex number and a real number.
    @inlinable
    public static func / (lhs: Self, rhs: Complex.Real<Scalar>) -> Self {
        Self(real: lhs.real / rhs, imaginary: Complex.Imaginary(lhs.imaginary._value / rhs._value))
    }

    /// Returns the quotient of a real number and a complex number.
    @inlinable
    public static func / (lhs: Complex.Real<Scalar>, rhs: Self) -> Self {
        Self(lhs._value, 0) / rhs
    }

    /// Returns the quotient of a complex number and an imaginary number.
    ///
    /// Computed as `(a + bi) / (di) = b/d - (a/d)i`.
    @inlinable
    public static func / (lhs: Self, rhs: Complex.Imaginary<Scalar>) -> Self {
        let a = lhs.real._value
        let b = lhs.imaginary._value
        let d = rhs._value
        return Self(b / d, -a / d)
    }

    /// Returns the quotient of an imaginary number and a complex number.
    @inlinable
    public static func / (lhs: Complex.Imaginary<Scalar>, rhs: Self) -> Self {
        Self(0, lhs._value) / rhs
    }

    // MARK: Conjugate

    /// Returns the complex conjugate.
    ///
    /// The conjugate of `a + bi` is `a - bi`.
    @inlinable
    public static func conjugate(of z: Self) -> Self {
        Self(real: z.real, imaginary: -z.imaginary)
    }

    /// The complex conjugate.
    @inlinable
    public var conjugate: Self {
        Self.conjugate(of: self)
    }

    // MARK: Reciprocal

    /// Returns the multiplicative inverse.
    ///
    /// The reciprocal of `z` is `1/z = conjugate(z) / |z|²`.
    @inlinable
    public static func reciprocal(of z: Self) -> Self {
        let a = z.real._value
        let b = z.imaginary._value
        let denom = a * a + b * b
        return Self(a / denom, -b / denom)
    }

    /// The multiplicative inverse.
    @inlinable
    public var reciprocal: Self {
        Self.reciprocal(of: self)
    }
}
