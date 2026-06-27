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
    /// The complex arccosine (inverse cosine).
    ///
    /// Uses Kahan's formula for accurate branch cuts.
    @inlinable
    public func acos() -> Complex.Number<Scalar> {
        let z = complex
        let one = Complex.Number<Scalar>.one

        // acos(z) = 2 atan2(Re(√(1-z)), Re(√(1+z))) + i asinh(Im(conj(√(1+z)) * √(1-z)))
        let sqrt1mz = (one - z).math.sqrt()
        let sqrt1pz = (one + z).math.sqrt()

        let realPart = 2 * Scalar._atan2(sqrt1mz.real._value, sqrt1pz.real._value)
        let imagPart = Scalar._asinh((sqrt1pz.conjugate * sqrt1mz).imaginary._value)

        return Complex.Number(realPart, imagPart)
    }

    /// The complex arcsine (inverse sine).
    ///
    /// Uses Kahan's formula for accurate branch cuts.
    @inlinable
    public func asin() -> Complex.Number<Scalar> {
        let z = complex
        let one = Complex.Number<Scalar>.one

        // asin(z) = atan2(x, Re(√(1-z) * √(1+z))) + i asinh(Im(conj(√(1-z)) * √(1+z)))
        let sqrt1mz = (one - z).math.sqrt()
        let sqrt1pz = (one + z).math.sqrt()

        let realPart = Scalar._atan2(z.real._value, (sqrt1mz * sqrt1pz).real._value)
        let imagPart = Scalar._asinh((sqrt1mz.conjugate * sqrt1pz).imaginary._value)

        return Complex.Number(realPart, imagPart)
    }

    /// The complex arctangent (inverse tangent).
    ///
    /// Computed as `atan(z) = -i atanh(iz)`.
    @inlinable
    public func atan() -> Complex.Number<Scalar> {
        // atan(z) = -i atanh(iz)
        let iz = Complex.Number(-complex.imaginary._value, complex.real._value)
        let w = iz.math.atanh()
        // -i(a + bi) = b - ai
        return Complex.Number(w.imaginary._value, -w.real._value)
    }

    /// The complex inverse hyperbolic cosine.
    ///
    /// Uses Kahan's formula for accurate branch cuts.
    @inlinable
    public func acosh() -> Complex.Number<Scalar> {
        let z = complex
        let one = Complex.Number<Scalar>.one

        // acosh(z) = asinh(Re(conj(√(z-1)) * √(z+1))) + 2i atan2(Im(√(z-1)), Re(√(z+1)))
        let sqrtZm1 = (z - one).math.sqrt()
        let sqrtZp1 = (z + one).math.sqrt()

        let realPart = Scalar._asinh((sqrtZm1.conjugate * sqrtZp1).real._value)
        let imagPart = 2 * Scalar._atan2(sqrtZm1.imaginary._value, sqrtZp1.real._value)

        return Complex.Number(realPart, imagPart)
    }

    /// The complex inverse hyperbolic sine.
    ///
    /// Computed as `asinh(z) = -i asin(iz)`.
    @inlinable
    public func asinh() -> Complex.Number<Scalar> {
        // asinh(z) = -i asin(iz)
        let iz = Complex.Number(-complex.imaginary._value, complex.real._value)
        let w = iz.math.asin()
        // -i(a + bi) = b - ai
        return Complex.Number(w.imaginary._value, -w.real._value)
    }

    /// The complex inverse hyperbolic tangent.
    ///
    /// ```
    /// atanh(z) = (log(1+z) - log(1-z)) / 2
    /// ```
    @inlinable
    public func atanh() -> Complex.Number<Scalar> {
        let z = complex
        let logOnePlusZ = z.math.log.one.plus()
        let logOneMinusZ = (-z).math.log.one.plus()
        return (logOnePlusZ - logOneMinusZ).scalar.divide(by: Complex.Real(Scalar(2)))
    }
}
