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

extension Numeric.Complex.Math where Scalar == Double {
    /// The complex hyperbolic cosine.
    ///
    /// ```
    /// cosh(x + iy) = cosh(x) cos(y) + i sinh(x) sin(y)
    /// ```
    @inlinable
    public func cosh() -> Numeric.Complex<Scalar> {
        let z = complex
        guard z.isFinite else { return z }

        let x = z.real._value
        let y = z.imaginary._value

        // For large |x|, cosh(x) ≈ sinh(x) ≈ exp(|x|)/2
        let threshold = -Double.math.log(Double.ulpOfOne)
        guard abs(x) < threshold else {
            let phase = Numeric.Complex(Double.math.cos(y), Double.math.sin(y))
            let first = Double.math.exp(abs(x) / 2)
            let second = first / 2
            return phase.scalar.multiply(by: Numeric.Real(first)).scalar.multiply(by: Numeric.Real(second))
        }

        return Numeric.Complex(
            Double.math.cosh(x) * Double.math.cos(y),
            Double.math.sinh(x) * Double.math.sin(y)
        )
    }

    /// The complex hyperbolic sine.
    ///
    /// ```
    /// sinh(x + iy) = sinh(x) cos(y) + i cosh(x) sin(y)
    /// ```
    @inlinable
    public func sinh() -> Numeric.Complex<Scalar> {
        let z = complex
        guard z.isFinite else { return z }

        let x = z.real._value
        let y = z.imaginary._value

        // For large |x|, sinh(x) ≈ cosh(x) ≈ sign(x) exp(|x|)/2
        let threshold = -Double.math.log(Double.ulpOfOne)
        guard abs(x) < threshold else {
            let phase = Numeric.Complex(Double.math.cos(y), Double.math.sin(y))
            let first = Double.math.exp(abs(x) / 2)
            let second = Double(signOf: x, magnitudeOf: first / 2)
            return phase.scalar.multiply(by: Numeric.Real(first)).scalar.multiply(by: Numeric.Real(second))
        }

        return Numeric.Complex(
            Double.math.sinh(x) * Double.math.cos(y),
            Double.math.cosh(x) * Double.math.sin(y)
        )
    }

    /// The complex hyperbolic tangent.
    ///
    /// ```
    /// tanh(z) = sinh(z) / cosh(z)
    /// ```
    @inlinable
    public func tanh() -> Numeric.Complex<Scalar> {
        let z = complex
        guard z.isFinite else { return z }

        let x = z.real._value
        let y = z.imaginary._value

        // For large |x|, tanh(z) → ±1
        let threshold = -Double.math.log(Double.ulpOfOne)
        guard abs(x) < threshold else {
            return Numeric.Complex(
                Double(signOf: x, magnitudeOf: 1),
                Double(signOf: y, magnitudeOf: 0)
            )
        }

        // General case
        return z.math.sinh() / z.math.cosh()
    }
}

// MARK: - Float

extension Numeric.Complex.Math where Scalar == Float {
    /// The complex hyperbolic cosine.
    @inlinable
    public func cosh() -> Numeric.Complex<Scalar> {
        let z = complex
        guard z.isFinite else { return z }

        let x = z.real._value
        let y = z.imaginary._value

        let threshold = -Float.math.log(Float.ulpOfOne)
        guard abs(x) < threshold else {
            let phase = Numeric.Complex(Float.math.cos(y), Float.math.sin(y))
            let first = Float.math.exp(abs(x) / 2)
            let second = first / 2
            return phase.scalar.multiply(by: Numeric.Real(first)).scalar.multiply(by: Numeric.Real(second))
        }

        return Numeric.Complex(
            Float.math.cosh(x) * Float.math.cos(y),
            Float.math.sinh(x) * Float.math.sin(y)
        )
    }

    /// The complex hyperbolic sine.
    @inlinable
    public func sinh() -> Numeric.Complex<Scalar> {
        let z = complex
        guard z.isFinite else { return z }

        let x = z.real._value
        let y = z.imaginary._value

        let threshold = -Float.math.log(Float.ulpOfOne)
        guard abs(x) < threshold else {
            let phase = Numeric.Complex(Float.math.cos(y), Float.math.sin(y))
            let first = Float.math.exp(abs(x) / 2)
            let second = Float(signOf: x, magnitudeOf: first / 2)
            return phase.scalar.multiply(by: Numeric.Real(first)).scalar.multiply(by: Numeric.Real(second))
        }

        return Numeric.Complex(
            Float.math.sinh(x) * Float.math.cos(y),
            Float.math.cosh(x) * Float.math.sin(y)
        )
    }

    /// The complex hyperbolic tangent.
    @inlinable
    public func tanh() -> Numeric.Complex<Scalar> {
        let z = complex
        guard z.isFinite else { return z }

        let x = z.real._value
        let y = z.imaginary._value

        let threshold = -Float.math.log(Float.ulpOfOne)
        guard abs(x) < threshold else {
            return Numeric.Complex(
                Float(signOf: x, magnitudeOf: 1),
                Float(signOf: y, magnitudeOf: 0)
            )
        }

        return z.math.sinh() / z.math.cosh()
    }
}
