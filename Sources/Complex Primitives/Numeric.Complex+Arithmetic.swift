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

// MARK: - Double

extension Numeric.Complex where Scalar == Double {
    // MARK: Addition

    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(real: lhs.real + rhs.real, imaginary: lhs.imaginary + rhs.imaginary)
    }

    @inlinable
    public static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }

    /// Complex + Real → Complex
    @inlinable
    public static func + (lhs: Self, rhs: Numeric.Real<Scalar>) -> Self {
        Self(real: lhs.real + rhs, imaginary: lhs.imaginary)
    }

    /// Real + Complex → Complex
    @inlinable
    public static func + (lhs: Numeric.Real<Scalar>, rhs: Self) -> Self {
        Self(real: lhs + rhs.real, imaginary: rhs.imaginary)
    }

    /// Complex + Imaginary → Complex
    @inlinable
    public static func + (lhs: Self, rhs: Numeric.Imaginary<Scalar>) -> Self {
        Self(real: lhs.real, imaginary: lhs.imaginary + rhs)
    }

    /// Imaginary + Complex → Complex
    @inlinable
    public static func + (lhs: Numeric.Imaginary<Scalar>, rhs: Self) -> Self {
        Self(real: rhs.real, imaginary: lhs + rhs.imaginary)
    }

    // MARK: Subtraction

    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(real: lhs.real - rhs.real, imaginary: lhs.imaginary - rhs.imaginary)
    }

    @inlinable
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }

    /// Complex - Real → Complex
    @inlinable
    public static func - (lhs: Self, rhs: Numeric.Real<Scalar>) -> Self {
        Self(real: lhs.real - rhs, imaginary: lhs.imaginary)
    }

    /// Real - Complex → Complex
    @inlinable
    public static func - (lhs: Numeric.Real<Scalar>, rhs: Self) -> Self {
        Self(real: lhs - rhs.real, imaginary: -rhs.imaginary)
    }

    /// Complex - Imaginary → Complex
    @inlinable
    public static func - (lhs: Self, rhs: Numeric.Imaginary<Scalar>) -> Self {
        Self(real: lhs.real, imaginary: lhs.imaginary - rhs)
    }

    /// Imaginary - Complex → Complex
    @inlinable
    public static func - (lhs: Numeric.Imaginary<Scalar>, rhs: Self) -> Self {
        Self(real: -rhs.real, imaginary: lhs - rhs.imaginary)
    }

    // MARK: Negation

    @inlinable
    public static prefix func - (z: Self) -> Self {
        Self(real: -z.real, imaginary: -z.imaginary)
    }

    // MARK: Multiplication

    /// (a + bi)(c + di) = (ac - bd) + (ad + bc)i
    ///
    /// Coefficient arithmetic at the Complex level - we access raw values
    /// because this is the computation boundary.
    @inlinable
    public static func * (lhs: Self, rhs: Self) -> Self {
        let a = lhs.real._value, b = lhs.imaginary._value
        let c = rhs.real._value, d = rhs.imaginary._value
        return Self(a * c - b * d, a * d + b * c)
    }

    @inlinable
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }

    /// Complex × Real → Complex
    ///
    /// Scales both components by the real factor.
    @inlinable
    public static func * (lhs: Self, rhs: Numeric.Real<Scalar>) -> Self {
        Self(real: lhs.real * rhs, imaginary: Numeric.Imaginary(lhs.imaginary._value * rhs._value))
    }

    /// Real × Complex → Complex
    @inlinable
    public static func * (lhs: Numeric.Real<Scalar>, rhs: Self) -> Self {
        rhs * lhs
    }

    /// Complex × Imaginary → Complex
    ///
    /// (a + bi) × (di) = adi + bdi² = -bd + adi
    @inlinable
    public static func * (lhs: Self, rhs: Numeric.Imaginary<Scalar>) -> Self {
        let a = lhs.real._value, b = lhs.imaginary._value
        let d = rhs._value
        return Self(-b * d, a * d)
    }

    /// Imaginary × Complex → Complex
    @inlinable
    public static func * (lhs: Numeric.Imaginary<Scalar>, rhs: Self) -> Self {
        rhs * lhs
    }

    // MARK: Division

    /// Complex division with robust handling of overflow and underflow.
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
        let a = lhs.real._value, b = lhs.imaginary._value
        let c = rhs.real._value, d = rhs.imaginary._value
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
            let s = 1 / (Scalar(Scalar.radix) * .leastNormalMagnitude)
            let wPrime = Self(w.real._value * s, w.imaginary._value * s)
            let zPrime = Self(z.real._value * s, z.imaginary._value * s)
            return zPrime / wPrime
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
        let a = zPrime.real._value, b = zPrime.imaginary._value
        let c = wPrime.real._value, d = wPrime.imaginary._value
        return Self(
            (a * c + b * d) / wPrimeLengthSq,
            (b * c - a * d) / wPrimeLengthSq
        )
    }

    @inlinable
    public static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }

    /// Complex ÷ Real → Complex
    @inlinable
    public static func / (lhs: Self, rhs: Numeric.Real<Scalar>) -> Self {
        Self(real: lhs.real / rhs, imaginary: Numeric.Imaginary(lhs.imaginary._value / rhs._value))
    }

    /// Real ÷ Complex → Complex
    @inlinable
    public static func / (lhs: Numeric.Real<Scalar>, rhs: Self) -> Self {
        Self(lhs._value, 0) / rhs
    }

    /// Complex ÷ Imaginary → Complex
    ///
    /// (a + bi) / (di) = (a + bi) × (-i/d) / (di × -i/d) = (a + bi) × (-i) / d
    ///                 = (-ai + b) / d = b/d - (a/d)i
    @inlinable
    public static func / (lhs: Self, rhs: Numeric.Imaginary<Scalar>) -> Self {
        let a = lhs.real._value, b = lhs.imaginary._value
        let d = rhs._value
        return Self(b / d, -a / d)
    }

    /// Imaginary ÷ Complex → Complex
    @inlinable
    public static func / (lhs: Numeric.Imaginary<Scalar>, rhs: Self) -> Self {
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
        let a = z.real._value, b = z.imaginary._value
        let denom = a * a + b * b
        return Self(a / denom, -b / denom)
    }

    /// The multiplicative inverse.
    @inlinable
    public var reciprocal: Self {
        Self.reciprocal(of: self)
    }
}

// MARK: - Float

extension Numeric.Complex where Scalar == Float {
    // MARK: Addition

    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(real: lhs.real + rhs.real, imaginary: lhs.imaginary + rhs.imaginary)
    }

    @inlinable
    public static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }

    @inlinable
    public static func + (lhs: Self, rhs: Numeric.Real<Scalar>) -> Self {
        Self(real: lhs.real + rhs, imaginary: lhs.imaginary)
    }

    @inlinable
    public static func + (lhs: Numeric.Real<Scalar>, rhs: Self) -> Self {
        Self(real: lhs + rhs.real, imaginary: rhs.imaginary)
    }

    @inlinable
    public static func + (lhs: Self, rhs: Numeric.Imaginary<Scalar>) -> Self {
        Self(real: lhs.real, imaginary: lhs.imaginary + rhs)
    }

    @inlinable
    public static func + (lhs: Numeric.Imaginary<Scalar>, rhs: Self) -> Self {
        Self(real: rhs.real, imaginary: lhs + rhs.imaginary)
    }

    // MARK: Subtraction

    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(real: lhs.real - rhs.real, imaginary: lhs.imaginary - rhs.imaginary)
    }

    @inlinable
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs = lhs - rhs
    }

    @inlinable
    public static func - (lhs: Self, rhs: Numeric.Real<Scalar>) -> Self {
        Self(real: lhs.real - rhs, imaginary: lhs.imaginary)
    }

    @inlinable
    public static func - (lhs: Numeric.Real<Scalar>, rhs: Self) -> Self {
        Self(real: lhs - rhs.real, imaginary: -rhs.imaginary)
    }

    @inlinable
    public static func - (lhs: Self, rhs: Numeric.Imaginary<Scalar>) -> Self {
        Self(real: lhs.real, imaginary: lhs.imaginary - rhs)
    }

    @inlinable
    public static func - (lhs: Numeric.Imaginary<Scalar>, rhs: Self) -> Self {
        Self(real: -rhs.real, imaginary: lhs - rhs.imaginary)
    }

    // MARK: Negation

    @inlinable
    public static prefix func - (z: Self) -> Self {
        Self(real: -z.real, imaginary: -z.imaginary)
    }

    // MARK: Multiplication

    @inlinable
    public static func * (lhs: Self, rhs: Self) -> Self {
        let a = lhs.real._value, b = lhs.imaginary._value
        let c = rhs.real._value, d = rhs.imaginary._value
        return Self(a * c - b * d, a * d + b * c)
    }

    @inlinable
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs = lhs * rhs
    }

    @inlinable
    public static func * (lhs: Self, rhs: Numeric.Real<Scalar>) -> Self {
        Self(real: lhs.real * rhs, imaginary: Numeric.Imaginary(lhs.imaginary._value * rhs._value))
    }

    @inlinable
    public static func * (lhs: Numeric.Real<Scalar>, rhs: Self) -> Self {
        rhs * lhs
    }

    @inlinable
    public static func * (lhs: Self, rhs: Numeric.Imaginary<Scalar>) -> Self {
        let a = lhs.real._value, b = lhs.imaginary._value
        let d = rhs._value
        return Self(-b * d, a * d)
    }

    @inlinable
    public static func * (lhs: Numeric.Imaginary<Scalar>, rhs: Self) -> Self {
        rhs * lhs
    }

    // MARK: Division

    @inlinable
    public static func / (lhs: Self, rhs: Self) -> Self {
        let lengthSquared = rhs.real._value * rhs.real._value + rhs.imaginary._value * rhs.imaginary._value
        guard lengthSquared.isNormal else {
            return rescaledDivide(lhs, rhs)
        }
        let a = lhs.real._value, b = lhs.imaginary._value
        let c = rhs.real._value, d = rhs.imaginary._value
        return Self(
            (a * c + b * d) / lengthSquared,
            (b * c - a * d) / lengthSquared
        )
    }

    @usableFromInline
    @inline(never)
    internal static func rescaledDivide(_ z: Self, _ w: Self) -> Self {
        if w.isZero { return .infinity }
        if !z.isFinite || !w.isFinite {
            return .zero
        }

        let wMagnitude = max(w.real.abs._value, w.imaginary.abs._value)

        if wMagnitude < Scalar.leastNormalMagnitude {
            let s = 1 / (Scalar(Scalar.radix) * .leastNormalMagnitude)
            let wPrime = Self(w.real._value * s, w.imaginary._value * s)
            let zPrime = Self(z.real._value * s, z.imaginary._value * s)
            return zPrime / wPrime
        }

        let s = Scalar(
            sign: .plus,
            exponent: -3 * wMagnitude.exponent / 4,
            significand: 1
        )
        let wPrime = Self(w.real._value * s, w.imaginary._value * s)
        let zPrime = Self(z.real._value * s, z.imaginary._value * s)
        let wPrimeLengthSq = wPrime.real._value * wPrime.real._value + wPrime.imaginary._value * wPrime.imaginary._value
        let a = zPrime.real._value, b = zPrime.imaginary._value
        let c = wPrime.real._value, d = wPrime.imaginary._value
        return Self(
            (a * c + b * d) / wPrimeLengthSq,
            (b * c - a * d) / wPrimeLengthSq
        )
    }

    @inlinable
    public static func /= (lhs: inout Self, rhs: Self) {
        lhs = lhs / rhs
    }

    @inlinable
    public static func / (lhs: Self, rhs: Numeric.Real<Scalar>) -> Self {
        Self(real: lhs.real / rhs, imaginary: Numeric.Imaginary(lhs.imaginary._value / rhs._value))
    }

    @inlinable
    public static func / (lhs: Numeric.Real<Scalar>, rhs: Self) -> Self {
        Self(lhs._value, 0) / rhs
    }

    @inlinable
    public static func / (lhs: Self, rhs: Numeric.Imaginary<Scalar>) -> Self {
        let a = lhs.real._value, b = lhs.imaginary._value
        let d = rhs._value
        return Self(b / d, -a / d)
    }

    @inlinable
    public static func / (lhs: Numeric.Imaginary<Scalar>, rhs: Self) -> Self {
        Self(0, lhs._value) / rhs
    }

    // MARK: Conjugate

    @inlinable
    public static func conjugate(of z: Self) -> Self {
        Self(real: z.real, imaginary: -z.imaginary)
    }

    @inlinable
    public var conjugate: Self {
        Self.conjugate(of: self)
    }

    // MARK: Reciprocal

    @inlinable
    public static func reciprocal(of z: Self) -> Self {
        let a = z.real._value, b = z.imaginary._value
        let denom = a * a + b * b
        return Self(a / denom, -b / denom)
    }

    @inlinable
    public var reciprocal: Self {
        Self.reciprocal(of: self)
    }
}

