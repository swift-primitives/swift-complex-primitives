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

extension Numeric.Complex.Math {
    /// Accessor for power operations.
    public struct Pow {
        @usableFromInline
        let complex: Numeric.Complex<Scalar>

        @usableFromInline
        internal init(_ complex: Numeric.Complex<Scalar>) {
            self.complex = complex
        }
    }
}

extension Numeric.Complex.Math.Pow: Sendable where Scalar: Sendable {}

extension Numeric.Complex.Math {
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

// MARK: - Double

extension Numeric.Complex.Math where Scalar == Double {
    /// The principal square root of this complex number.
    ///
    /// The branch cut is along the negative real axis. The result has
    /// non-negative real part.
    @inlinable
    public func sqrt() -> Numeric.Complex<Scalar> {
        let z = complex
        let lenSquared = z.magnitude.squared

        if lenSquared.isNormal {
            // Standard case: |z|² doesn't overflow
            // u = √((|z| + |x|) / 2)
            // v = y / (2u)
            let norm = Double.math.sqrt(lenSquared._value)
            let u = Double.math.sqrt((norm + z.real.abs._value) / 2)
            let v = z.imaginary._value / (2 * u)

            if z.real.sign == .plus {
                return Numeric.Complex(u, v)
            } else {
                return Numeric.Complex(abs(v), Double(signOf: z.imaginary._value, magnitudeOf: u))
            }
        }

        // Edge cases
        if z.isZero { return Numeric.Complex(0, z.imaginary._value) }
        if !z.isFinite { return z }

        // Badly-scaled: rescale and retry
        let scale = max(abs(z.real._value), abs(z.imaginary._value))
        let scaled = z.scalar.divide(by: Numeric.Real(scale))
        return scaled.math.sqrt().scalar.multiply(by: Numeric.Real(Double.math.sqrt(scale)))
    }

    /// The principal nth root of this complex number.
    ///
    /// Computed as `exp(log(z) / n)`.
    @inlinable
    public func root(_ n: Int) -> Numeric.Complex<Scalar> {
        let z = complex
        if z.isZero { return .zero }
        return z.math.log().scalar.divide(by: Numeric.Real(Double(n))).math.exp()
    }
}

extension Numeric.Complex.Math.Pow where Scalar == Double {
    /// z raised to the power w, where w is complex.
    ///
    /// Computed as `exp(w * log(z))`.
    ///
    /// Edge cases follow IEEE 754's `powr` semantics:
    /// - `pow(0, w)` returns 0 if `w.real > 0`, otherwise infinity.
    @inlinable
    public func callAsFunction(_ w: Numeric.Complex<Scalar>) -> Numeric.Complex<Scalar> {
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
    public func callAsFunction(_ n: Int) -> Numeric.Complex<Scalar> {
        let z = complex
        if z.isZero {
            if n < 0 { return .infinity }
            if n == 0 { return .one }
            return .zero
        }
        // z^n = exp(n * log(z))
        return z.math.log().scalar.multiply(by: Numeric.Real(Double(n))).math.exp()
    }
}

// MARK: - Float

extension Numeric.Complex.Math where Scalar == Float {
    /// The principal square root of this complex number.
    @inlinable
    public func sqrt() -> Numeric.Complex<Scalar> {
        let z = complex
        let lenSquared = z.magnitude.squared

        if lenSquared.isNormal {
            let norm = Float.math.sqrt(lenSquared._value)
            let u = Float.math.sqrt((norm + z.real.abs._value) / 2)
            let v = z.imaginary._value / (2 * u)

            if z.real.sign == .plus {
                return Numeric.Complex(u, v)
            } else {
                return Numeric.Complex(abs(v), Float(signOf: z.imaginary._value, magnitudeOf: u))
            }
        }

        if z.isZero { return Numeric.Complex(0, z.imaginary._value) }
        if !z.isFinite { return z }

        let scale = max(abs(z.real._value), abs(z.imaginary._value))
        let scaled = z.scalar.divide(by: Numeric.Real(scale))
        return scaled.math.sqrt().scalar.multiply(by: Numeric.Real(Float.math.sqrt(scale)))
    }

    /// The principal nth root of this complex number.
    @inlinable
    public func root(_ n: Int) -> Numeric.Complex<Scalar> {
        let z = complex
        if z.isZero { return .zero }
        return z.math.log().scalar.divide(by: Numeric.Real(Float(n))).math.exp()
    }
}

extension Numeric.Complex.Math.Pow where Scalar == Float {
    /// z raised to the power w, where w is complex.
    @inlinable
    public func callAsFunction(_ w: Numeric.Complex<Scalar>) -> Numeric.Complex<Scalar> {
        let z = complex
        if z.isZero {
            return w.real._value > 0 ? .zero : .infinity
        }
        return (w * z.math.log()).math.exp()
    }

    /// z raised to the integer power n.
    @inlinable
    public func callAsFunction(_ n: Int) -> Numeric.Complex<Scalar> {
        let z = complex
        if z.isZero {
            if n < 0 { return .infinity }
            if n == 0 { return .one }
            return .zero
        }
        return z.math.log().scalar.multiply(by: Numeric.Real(Float(n))).math.exp()
    }
}
