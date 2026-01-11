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

// MARK: - Inverse Trigonometric Functions

extension Numeric.Complex.Math {
    /// The complex arccosine (inverse cosine).
    ///
    /// Uses Kahan's formula for accurate branch cuts.
    @inlinable
    public func acos() -> Numeric.Complex<Scalar> {
        let z = complex
        let one = Numeric.Complex<Scalar>.one

        // acos(z) = 2 atan2(Re(√(1-z)), Re(√(1+z))) + i asinh(Im(conj(√(1+z)) * √(1-z)))
        let sqrt1mz = (one - z).math.sqrt()
        let sqrt1pz = (one + z).math.sqrt()

        let realPart = 2 * Scalar.math.atan2(sqrt1mz.real, sqrt1pz.real)
        let imagPart = Scalar.math.asinh((sqrt1pz.conjugate * sqrt1mz).imaginary)

        return Numeric.Complex(realPart, imagPart)
    }
}

extension Numeric.Complex.Math {
    /// The complex arcsine (inverse sine).
    ///
    /// Uses Kahan's formula for accurate branch cuts.
    @inlinable
    public func asin() -> Numeric.Complex<Scalar> {
        let z = complex
        let one = Numeric.Complex<Scalar>.one

        // asin(z) = atan2(x, Re(√(1-z) * √(1+z))) + i asinh(Im(conj(√(1-z)) * √(1+z)))
        let sqrt1mz = (one - z).math.sqrt()
        let sqrt1pz = (one + z).math.sqrt()

        let realPart = Scalar.math.atan2(z.real, (sqrt1mz * sqrt1pz).real)
        let imagPart = Scalar.math.asinh((sqrt1mz.conjugate * sqrt1pz).imaginary)

        return Numeric.Complex(realPart, imagPart)
    }
}

extension Numeric.Complex.Math {
    /// The complex arctangent (inverse tangent).
    ///
    /// Computed as `atan(z) = -i atanh(iz)`.
    @inlinable
    public func atan() -> Numeric.Complex<Scalar> {
        // atan(z) = -i atanh(iz)
        let iz = Numeric.Complex(-complex.imaginary, complex.real)
        let w = iz.math.atanh()
        // -i(a + bi) = b - ai
        return Numeric.Complex(w.imaginary, -w.real)
    }
}

// MARK: - Inverse Hyperbolic Functions

extension Numeric.Complex.Math {
    /// The complex inverse hyperbolic cosine.
    ///
    /// Uses Kahan's formula for accurate branch cuts.
    @inlinable
    public func acosh() -> Numeric.Complex<Scalar> {
        let z = complex
        let one = Numeric.Complex<Scalar>.one

        // acosh(z) = asinh(Re(conj(√(z-1)) * √(z+1))) + 2i atan2(Im(√(z-1)), Re(√(z+1)))
        let sqrtZm1 = (z - one).math.sqrt()
        let sqrtZp1 = (z + one).math.sqrt()

        let realPart = Scalar.math.asinh((sqrtZm1.conjugate * sqrtZp1).real)
        let imagPart = 2 * Scalar.math.atan2(sqrtZm1.imaginary, sqrtZp1.real)

        return Numeric.Complex(realPart, imagPart)
    }
}

extension Numeric.Complex.Math {
    /// The complex inverse hyperbolic sine.
    ///
    /// Computed as `asinh(z) = -i asin(iz)`.
    @inlinable
    public func asinh() -> Numeric.Complex<Scalar> {
        // asinh(z) = -i asin(iz)
        let iz = Numeric.Complex(-complex.imaginary, complex.real)
        let w = iz.math.asin()
        // -i(a + bi) = b - ai
        return Numeric.Complex(w.imaginary, -w.real)
    }
}

extension Numeric.Complex.Math {
    /// The complex inverse hyperbolic tangent.
    ///
    /// ```
    /// atanh(z) = (log(1+z) - log(1-z)) / 2
    /// ```
    @inlinable
    public func atanh() -> Numeric.Complex<Scalar> {
        let z = complex
        let logOnePlusZ = z.math.log.one.plus()
        let logOneMinusZ = (-z).math.log.one.plus()
        return (logOnePlusZ - logOneMinusZ).scalar.divide(by: 2)
    }
}
