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

// MARK: - Cosh

extension Numeric.Complex.Math {
    /// The complex hyperbolic cosine.
    ///
    /// ```
    /// cosh(x + iy) = cosh(x) cos(y) + i sinh(x) sin(y)
    /// ```
    @inlinable
    public func cosh() -> Numeric.Complex<Scalar> {
        let z = complex
        guard z.isFinite else { return z }

        let x = z.real
        let y = z.imaginary

        // For large |x|, cosh(x) ≈ sinh(x) ≈ exp(|x|)/2
        let threshold = -Scalar.math.log(Scalar.ulpOfOne)
        guard x.magnitude < threshold else {
            let phase = Numeric.Complex(Scalar.math.cos(y), Scalar.math.sin(y))
            let first = Scalar.math.exp(x.magnitude / 2)
            let second = first / 2
            return phase.scalar.multiply(by: first).scalar.multiply(by: second)
        }

        return Numeric.Complex(
            Scalar.math.cosh(x) * Scalar.math.cos(y),
            Scalar.math.sinh(x) * Scalar.math.sin(y)
        )
    }
}

// MARK: - Sinh

extension Numeric.Complex.Math {
    /// The complex hyperbolic sine.
    ///
    /// ```
    /// sinh(x + iy) = sinh(x) cos(y) + i cosh(x) sin(y)
    /// ```
    @inlinable
    public func sinh() -> Numeric.Complex<Scalar> {
        let z = complex
        guard z.isFinite else { return z }

        let x = z.real
        let y = z.imaginary

        // For large |x|, sinh(x) ≈ cosh(x) ≈ sign(x) exp(|x|)/2
        let threshold = -Scalar.math.log(Scalar.ulpOfOne)
        guard x.magnitude < threshold else {
            let phase = Numeric.Complex(Scalar.math.cos(y), Scalar.math.sin(y))
            let first = Scalar.math.exp(x.magnitude / 2)
            let second = Scalar(signOf: x, magnitudeOf: first / 2)
            return phase.scalar.multiply(by: first).scalar.multiply(by: second)
        }

        return Numeric.Complex(
            Scalar.math.sinh(x) * Scalar.math.cos(y),
            Scalar.math.cosh(x) * Scalar.math.sin(y)
        )
    }
}

// MARK: - Tanh

extension Numeric.Complex.Math {
    /// The complex hyperbolic tangent.
    ///
    /// ```
    /// tanh(z) = sinh(z) / cosh(z)
    /// ```
    @inlinable
    public func tanh() -> Numeric.Complex<Scalar> {
        let z = complex
        guard z.isFinite else { return z }

        let x = z.real
        let y = z.imaginary

        // For large |x|, tanh(z) → ±1
        let threshold = -Scalar.math.log(Scalar.ulpOfOne)
        guard x.magnitude < threshold else {
            return Numeric.Complex(
                Scalar(signOf: x, magnitudeOf: 1),
                Scalar(signOf: y, magnitudeOf: 0)
            )
        }

        // General case
        return z.math.sinh() / z.math.cosh()
    }
}
