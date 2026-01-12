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

// MARK: - Exp Accessor

extension Numeric.Complex.Math {
    /// Accessor for exponential function variants.
    public struct Exp {
        @usableFromInline
        let complex: Numeric.Complex<Scalar>

        @usableFromInline
        internal init(_ complex: Numeric.Complex<Scalar>) {
            self.complex = complex
        }
    }
}

extension Numeric.Complex.Math.Exp: Sendable where Scalar: Sendable {}

extension Numeric.Complex.Math {
    /// Access exponential function and variants.
    ///
    /// ```swift
    /// z.math.exp()              // e^z
    /// z.math.exp.minus.one()    // e^z - 1
    /// ```
    @inlinable
    public var exp: Exp {
        Exp(complex)
    }
}

// MARK: - Minus Accessor

extension Numeric.Complex.Math.Exp {
    /// Accessor for exp(z) - k variants.
    public struct Minus {
        @usableFromInline
        let complex: Numeric.Complex<Scalar>

        @usableFromInline
        internal init(_ complex: Numeric.Complex<Scalar>) {
            self.complex = complex
        }
    }
}

extension Numeric.Complex.Math.Exp.Minus: Sendable where Scalar: Sendable {}

extension Numeric.Complex.Math.Exp {
    /// Access shifted exponential variants.
    @inlinable
    public var minus: Minus {
        Minus(complex)
    }
}

// MARK: - Double

extension Numeric.Complex.Math.Exp where Scalar == Double {
    /// The complex exponential function e^z.
    ///
    /// Mathematically:
    /// ```
    /// exp(x + iy) = exp(x) cos(y) + i exp(x) sin(y)
    /// ```
    ///
    /// This implementation avoids premature overflow when `exp(x)` would
    /// overflow but `exp(x) cos(y)` would not.
    @inlinable
    public func callAsFunction() -> Numeric.Complex<Scalar> {
        let z = complex
        guard z.isFinite else { return z }

        let x = z.real._value
        let y = z.imaginary._value

        // If x < log(greatestFiniteMagnitude), exp(x) does not overflow.
        // Subtract 1 for safety margin against library inaccuracies.
        guard x < Double.math.log(Double.greatestFiniteMagnitude) - 1 else {
            // Use half-scale trick to avoid overflow
            let half = Double.math.exp(x / 2)
            let phase = Numeric.Complex(Double.math.cos(y), Double.math.sin(y))
            return phase.scalar.multiply(by: Numeric.Real(half)).scalar.multiply(by: Numeric.Real(half))
        }

        return Numeric.Complex(
            Double.math.cos(y),
            Double.math.sin(y)
        ).scalar.multiply(by: Numeric.Real(Double.math.exp(x)))
    }
}

extension Numeric.Complex.Math.Exp.Minus where Scalar == Double {
    /// e^z - 1, computed accurately for small z.
    ///
    /// For small values of z, computing `exp(z) - 1` directly loses
    /// precision due to catastrophic cancellation.
    @inlinable
    public func one() -> Numeric.Complex<Scalar> {
        let z = complex
        guard z.isFinite else { return z }

        let x = z.real._value
        let y = z.imaginary._value

        // Near overflow, the -1 is negligible
        guard x < Double.math.log(Double.greatestFiniteMagnitude) - 1 else {
            let half = Double.math.exp(x / 2)
            let phase = Numeric.Complex(Double.math.cos(y), Double.math.sin(y))
            return phase.scalar.multiply(by: Numeric.Real(half)).scalar.multiply(by: Numeric.Real(half))
        }

        // cos(y) - 1 = -2 sin²(y/2)
        let sinHalfY = Double.math.sin(y / 2)
        let cosm1 = -2 * sinHalfY * sinHalfY

        // Re = expm1(x) * cos(y) + cosm1(y)
        let realPart = Double.math.expm1(x) * Double.math.cos(y) + cosm1

        // Im = exp(x) * sin(y)
        let imagPart = Double.math.exp(x) * Double.math.sin(y)

        return Numeric.Complex(realPart, imagPart)
    }
}

// MARK: - Float

extension Numeric.Complex.Math.Exp where Scalar == Float {
    /// The complex exponential function e^z.
    @inlinable
    public func callAsFunction() -> Numeric.Complex<Scalar> {
        let z = complex
        guard z.isFinite else { return z }

        let x = z.real._value
        let y = z.imaginary._value

        guard x < Float.math.log(Float.greatestFiniteMagnitude) - 1 else {
            let half = Float.math.exp(x / 2)
            let phase = Numeric.Complex(Float.math.cos(y), Float.math.sin(y))
            return phase.scalar.multiply(by: Numeric.Real(half)).scalar.multiply(by: Numeric.Real(half))
        }

        return Numeric.Complex(
            Float.math.cos(y),
            Float.math.sin(y)
        ).scalar.multiply(by: Numeric.Real(Float.math.exp(x)))
    }
}

extension Numeric.Complex.Math.Exp.Minus where Scalar == Float {
    /// e^z - 1, computed accurately for small z.
    @inlinable
    public func one() -> Numeric.Complex<Scalar> {
        let z = complex
        guard z.isFinite else { return z }

        let x = z.real._value
        let y = z.imaginary._value

        guard x < Float.math.log(Float.greatestFiniteMagnitude) - 1 else {
            let half = Float.math.exp(x / 2)
            let phase = Numeric.Complex(Float.math.cos(y), Float.math.sin(y))
            return phase.scalar.multiply(by: Numeric.Real(half)).scalar.multiply(by: Numeric.Real(half))
        }

        let sinHalfY = Float.math.sin(y / 2)
        let cosm1 = -2 * sinHalfY * sinHalfY
        let realPart = Float.math.expm1(x) * Float.math.cos(y) + cosm1
        let imagPart = Float.math.exp(x) * Float.math.sin(y)

        return Numeric.Complex(realPart, imagPart)
    }
}
