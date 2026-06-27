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

// MARK: - BinaryFloatingPoint & Numeric.Transcendental

extension Complex.Number.Math where Scalar: BinaryFloatingPoint & Numeric.Transcendental {
    /// The complex hyperbolic cosine.
    ///
    /// ```
    /// cosh(x + iy) = cosh(x) cos(y) + i sinh(x) sin(y)
    /// ```
    @inlinable
    public func cosh() -> Complex.Number<Scalar> {
        let z = complex
        guard z.isFinite else { return z }

        let x = z.real._value
        let y = z.imaginary._value

        // For large |x|, cosh(x) ≈ sinh(x) ≈ exp(|x|)/2
        let threshold = -Scalar._log(Scalar.ulpOfOne)
        guard abs(x) < threshold else {
            let phase = Complex.Number(Scalar._cos(y), Scalar._sin(y))
            let first = Scalar._exp(abs(x) / 2)
            let second = first / 2
            return phase.scalar.multiply(by: Complex.Real(first)).scalar.multiply(by: Complex.Real(second))
        }

        return Complex.Number(
            Scalar._cosh(x) * Scalar._cos(y),
            Scalar._sinh(x) * Scalar._sin(y)
        )
    }

    /// The complex hyperbolic sine.
    ///
    /// ```
    /// sinh(x + iy) = sinh(x) cos(y) + i cosh(x) sin(y)
    /// ```
    @inlinable
    public func sinh() -> Complex.Number<Scalar> {
        let z = complex
        guard z.isFinite else { return z }

        let x = z.real._value
        let y = z.imaginary._value

        // For large |x|, sinh(x) ≈ cosh(x) ≈ sign(x) exp(|x|)/2
        let threshold = -Scalar._log(Scalar.ulpOfOne)
        guard abs(x) < threshold else {
            let phase = Complex.Number(Scalar._cos(y), Scalar._sin(y))
            let first = Scalar._exp(abs(x) / 2)
            let second = Scalar(signOf: x, magnitudeOf: first / 2)
            return phase.scalar.multiply(by: Complex.Real(first)).scalar.multiply(by: Complex.Real(second))
        }

        return Complex.Number(
            Scalar._sinh(x) * Scalar._cos(y),
            Scalar._cosh(x) * Scalar._sin(y)
        )
    }

    /// The complex hyperbolic tangent.
    ///
    /// ```
    /// tanh(z) = sinh(z) / cosh(z)
    /// ```
    @inlinable
    public func tanh() -> Complex.Number<Scalar> {
        let z = complex
        guard z.isFinite else { return z }

        let x = z.real._value
        let y = z.imaginary._value

        // For large |x|, tanh(z) → ±1
        let threshold = -Scalar._log(Scalar.ulpOfOne)
        guard abs(x) < threshold else {
            return Complex.Number(
                Scalar(signOf: x, magnitudeOf: 1),
                Scalar(signOf: y, magnitudeOf: 0)
            )
        }

        // General case
        return z.math.sinh() / z.math.cosh()
    }
}
