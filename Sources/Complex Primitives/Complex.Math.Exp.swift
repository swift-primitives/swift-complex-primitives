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

extension Complex.Number.Math {
    /// Accessor for exponential function variants.
    public struct Exp {
        @usableFromInline
        let complex: Complex.Number<Scalar>

        @usableFromInline
        internal init(_ complex: Complex.Number<Scalar>) {
            self.complex = complex
        }
    }
}

extension Complex.Number.Math.Exp: Sendable where Scalar: Sendable {}

extension Complex.Number.Math {
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

extension Complex.Number.Math.Exp {
    /// Accessor for exp(z) - k variants.
    public struct Minus {
        @usableFromInline
        let complex: Complex.Number<Scalar>

        @usableFromInline
        internal init(_ complex: Complex.Number<Scalar>) {
            self.complex = complex
        }
    }
}

extension Complex.Number.Math.Exp.Minus: Sendable where Scalar: Sendable {}

extension Complex.Number.Math.Exp {
    /// Access shifted exponential variants.
    @inlinable
    public var minus: Minus {
        Minus(complex)
    }
}

// MARK: - BinaryFloatingPoint & Numeric.Transcendental

extension Complex.Number.Math.Exp where Scalar: BinaryFloatingPoint & Numeric.Transcendental {
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
    public func callAsFunction() -> Complex.Number<Scalar> {
        let z = complex
        guard z.isFinite else { return z }

        let x = z.real._value
        let y = z.imaginary._value

        // If x < log(greatestFiniteMagnitude), exp(x) does not overflow.
        // Subtract 1 for safety margin against library inaccuracies.
        guard x < Scalar._log(Scalar.greatestFiniteMagnitude) - 1 else {
            // Use half-scale trick to avoid overflow
            let half = Scalar._exp(x / 2)
            let phase = Complex.Number(Scalar._cos(y), Scalar._sin(y))
            return phase.scalar.multiply(by: Complex.Real(half)).scalar.multiply(by: Complex.Real(half))
        }

        return Complex.Number(
            Scalar._cos(y),
            Scalar._sin(y)
        ).scalar.multiply(by: Complex.Real(Scalar._exp(x)))
    }
}

extension Complex.Number.Math.Exp.Minus where Scalar: BinaryFloatingPoint & Numeric.Transcendental {
    /// e^z - 1, computed accurately for small z.
    ///
    /// For small values of z, computing `exp(z) - 1` directly loses
    /// precision due to catastrophic cancellation.
    @inlinable
    public func one() -> Complex.Number<Scalar> {
        let z = complex
        guard z.isFinite else { return z }

        let x = z.real._value
        let y = z.imaginary._value

        // Near overflow, the -1 is negligible
        guard x < Scalar._log(Scalar.greatestFiniteMagnitude) - 1 else {
            let half = Scalar._exp(x / 2)
            let phase = Complex.Number(Scalar._cos(y), Scalar._sin(y))
            return phase.scalar.multiply(by: Complex.Real(half)).scalar.multiply(by: Complex.Real(half))
        }

        // cos(y) - 1 = -2 sin²(y/2)
        let sinHalfY = Scalar._sin(y / 2)
        let cosm1 = -2 * sinHalfY * sinHalfY

        // Re = expm1(x) * cos(y) + cosm1(y)
        let realPart = Scalar._expm1(x) * Scalar._cos(y) + cosm1

        // Im = exp(x) * sin(y)
        let imagPart = Scalar._exp(x) * Scalar._sin(y)

        return Complex.Number(realPart, imagPart)
    }
}
