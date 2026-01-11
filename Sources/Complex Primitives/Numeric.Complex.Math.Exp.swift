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

// MARK: - Primary Operation

extension Numeric.Complex.Math.Exp {
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

        let x = z.real
        let y = z.imaginary

        // If x < log(greatestFiniteMagnitude), exp(x) does not overflow.
        // Subtract 1 for safety margin against library inaccuracies.
        guard x < Scalar.math.log(Scalar.greatestFiniteMagnitude) - 1 else {
            // Use half-scale trick to avoid overflow
            let half = Scalar.math.exp(x / 2)
            let phase = Numeric.Complex(Scalar.math.cos(y), Scalar.math.sin(y))
            return phase.scalar.multiply(by: half).scalar.multiply(by: half)
        }

        return Numeric.Complex(
            Scalar.math.cos(y),
            Scalar.math.sin(y)
        ).scalar.multiply(by: Scalar.math.exp(x))
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

// MARK: - Exp Minus One

extension Numeric.Complex.Math.Exp.Minus {
    /// e^z - 1, computed accurately for small z.
    ///
    /// For small values of z, computing `exp(z) - 1` directly loses
    /// precision due to catastrophic cancellation. This function
    /// computes the result accurately using:
    /// ```
    /// Re(exp(z) - 1) = expm1(x) cos(y) + cosm1(y)
    /// Im(exp(z) - 1) = exp(x) sin(y)
    /// ```
    @inlinable
    public func one() -> Numeric.Complex<Scalar> {
        let z = complex
        guard z.isFinite else { return z }

        let x = z.real
        let y = z.imaginary

        // Near overflow, the -1 is negligible
        guard x < Scalar.math.log(Scalar.greatestFiniteMagnitude) - 1 else {
            let half = Scalar.math.exp(x / 2)
            let phase = Numeric.Complex(Scalar.math.cos(y), Scalar.math.sin(y))
            return phase.scalar.multiply(by: half).scalar.multiply(by: half)
        }

        // cos(y) - 1 = -2 sin²(y/2)
        let sinHalfY = Scalar.math.sin(y / 2)
        let cosm1 = -2 * sinHalfY * sinHalfY

        // Re = expm1(x) * cos(y) + cosm1(y)
        let realPart = Scalar.math.exp.minus.one(x) * Scalar.math.cos(y) + cosm1

        // Im = exp(x) * sin(y)
        let imagPart = Scalar.math.exp(x) * Scalar.math.sin(y)

        return Numeric.Complex(realPart, imagPart)
    }
}
