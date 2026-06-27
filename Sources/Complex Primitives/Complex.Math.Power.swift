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

// MARK: - Power Accessor

extension Complex.Number.Math {
    /// Accessor for power operations.
    public struct Pow {
        @usableFromInline
        let complex: Complex.Number<Scalar>

        @usableFromInline
        internal init(_ complex: Complex.Number<Scalar>) {
            self.complex = complex
        }
    }
}

extension Complex.Number.Math.Pow: Sendable where Scalar: Sendable {}

extension Complex.Number.Math {
    /// Access power operations.
    ///
    /// ```swift
    /// z.math.pow(w)     // z^w (complex exponent)
    /// z.math.pow(n)     // z^n (integer exponent)
    /// ```
    @inlinable
    public var pow: Pow {
        Pow(complex)
    }
}

// MARK: - BinaryFloatingPoint & Numeric.Transcendental

extension Complex.Number.Math where Scalar: BinaryFloatingPoint & Numeric.Transcendental {
    /// The principal square root of this complex number.
    ///
    /// The branch cut is along the negative real axis. The result has
    /// non-negative real part.
    @inlinable
    public func sqrt() -> Complex.Number<Scalar> {
        let z = complex
        let lenSquared = z.magnitude.squared

        if lenSquared.isNormal {
            // Standard case: |z|² doesn't overflow
            // u = √((|z| + |x|) / 2)
            // v = y / (2u)
            let norm = Scalar._sqrt(lenSquared._value)
            let u = Scalar._sqrt((norm + z.real.abs._value) / 2)
            let v = z.imaginary._value / (2 * u)

            guard z.real.sign == .plus else {
                return Complex.Number(abs(v), Scalar(signOf: z.imaginary._value, magnitudeOf: u))
            }
            return Complex.Number(u, v)
        }

        // Edge cases
        if z.isZero { return Complex.Number(0, z.imaginary._value) }
        if !z.isFinite { return z }

        // Badly-scaled: rescale and retry
        let scale = max(abs(z.real._value), abs(z.imaginary._value))
        let scaled = z.scalar.divide(by: Complex.Real(scale))
        return scaled.math.sqrt().scalar.multiply(by: Complex.Real(Scalar._sqrt(scale)))
    }

    /// The principal nth root of this complex number.
    ///
    /// Computed as `exp(log(z) / n)`.
    @inlinable
    public func root(_ n: Int) -> Complex.Number<Scalar> {
        let z = complex
        if z.isZero { return .zero }
        return z.math.log().scalar.divide(by: Complex.Real(Scalar(n))).math.exp()
    }
}

extension Complex.Number.Math.Pow where Scalar: BinaryFloatingPoint & Numeric.Transcendental {
    /// z raised to the power w, where w is complex.
    ///
    /// Computed as `exp(w * log(z))`.
    ///
    /// Edge cases follow IEEE 754's `powr` semantics:
    /// - `pow(0, w)` returns 0 if `w.real > 0`, otherwise infinity.
    @inlinable
    public func callAsFunction(_ w: Complex.Number<Scalar>) -> Complex.Number<Scalar> {
        let z = complex
        if z.isZero {
            return w.real._value > 0 ? .zero : .infinity
        }
        return (w * z.math.log()).math.exp()
    }

    /// z raised to the integer power n.
    ///
    /// Edge cases are defined in terms of repeated multiplication:
    /// - `pow(0, 0)` returns 1.
    /// - `pow(0, n)` returns 0 for n > 0, infinity for n < 0.
    @inlinable
    public func callAsFunction(_ n: Int) -> Complex.Number<Scalar> {
        let z = complex
        if z.isZero {
            if n < 0 { return .infinity }
            if n == 0 { return .one }
            return .zero
        }
        // z^n = exp(n * log(z))
        return z.math.log().scalar.multiply(by: Complex.Real(Scalar(n))).math.exp()
    }
}
