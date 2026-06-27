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

import Testing

@testable import Complex_Primitives

@Suite
struct ComplexMathTests {

    let tolerance: Complex.Real<Double> = 1e-10

    // MARK: - Exponential

    @Test
    func exp() {
        // exp(0) = 1
        let z0 = Complex.Number<Double>.zero
        let exp0 = z0.math.exp()
        #expect(exp0.equals.approximate(.one, tolerance: tolerance))

        // exp(1) = e
        let z1 = Complex.Number<Double>(1.0)
        let exp1 = z1.math.exp()
        #expect(exp1.real.equals.approximate(Double.math.exp(1).real, tolerance: tolerance))
        #expect(exp1.imaginary.equals.approximate(0.0, tolerance: tolerance))

        // exp(iπ) = -1 (Euler's identity)
        let zPi = Complex.Number(0.0, Double.pi)
        let expPi = zPi.math.exp()
        #expect(expPi.real.equals.approximate(-1.0, tolerance: tolerance))
        #expect(expPi.imaginary.equals.approximate(0.0, tolerance: tolerance))

        // exp(iπ/2) = i
        let zHalfPi = Complex.Number(0.0, Double.pi / 2)
        let expHalfPi = zHalfPi.math.exp()
        #expect(expHalfPi.real.equals.approximate(0.0, tolerance: tolerance))
        #expect(expHalfPi.imaginary.equals.approximate(1.0, tolerance: tolerance))
    }

    @Test
    func expMinusOne() {
        // expm1(0) = 0
        let z0 = Complex.Number<Double>.zero
        let expm1_0 = z0.math.exp.minus.one()
        #expect(expm1_0.equals.approximate(.zero, tolerance: tolerance))

        // For small z, expm1(z) ≈ z
        let small = Complex.Number(1e-10, 1e-10)
        let expm1Small = small.math.exp.minus.one()
        #expect(expm1Small.equals.approximate(small, tolerance: 1e-8))
    }

    // MARK: - Logarithm

    @Test
    func log() {
        // log(1) = 0
        let z1 = Complex.Number<Double>.one
        let log1 = z1.math.log()
        #expect(log1.equals.approximate(.zero, tolerance: tolerance))

        // log(e) = 1
        let zE = Complex.Number(Double.math.exp(1), 0.0)
        let logE = zE.math.log()
        #expect(logE.real.equals.approximate(1.0, tolerance: tolerance))
        #expect(logE.imaginary.equals.approximate(0.0, tolerance: tolerance))

        // log(-1) = iπ
        let zNeg1 = Complex.Number(-1.0, 0.0)
        let logNeg1 = zNeg1.math.log()
        #expect(logNeg1.real.equals.approximate(0.0, tolerance: tolerance))
        #expect(logNeg1.imaginary.equals.approximate(Double.pi.i, tolerance: tolerance))

        // log(i) = iπ/2
        let zI = Complex.Number<Double>.i
        let logI = zI.math.log()
        #expect(logI.real.equals.approximate(0.0, tolerance: tolerance))
        #expect(logI.imaginary.equals.approximate((Double.pi / 2).i, tolerance: tolerance))
    }

    @Test
    func logOnePlus() {
        // log1p(0) = 0
        let z0 = Complex.Number<Double>.zero
        let log1p_0 = z0.math.log.one.plus()
        #expect(log1p_0.equals.approximate(.zero, tolerance: tolerance))

        // For small z, log1p(z) ≈ z
        let small = Complex.Number(1e-10, 1e-10)
        let log1pSmall = small.math.log.one.plus()
        #expect(log1pSmall.equals.approximate(small, tolerance: 1e-8))
    }

    @Test
    func logExpInverse() {
        // log(exp(z)) = z (for reasonable z)
        let z = Complex.Number(0.5, 0.3)
        let result = z.math.exp().math.log()
        #expect(result.equals.approximate(z, tolerance: tolerance))
    }

    // MARK: - Trigonometric

    @Test
    func cos() {
        // cos(0) = 1
        let z0 = Complex.Number<Double>.zero
        let cos0 = z0.math.cos()
        #expect(cos0.equals.approximate(.one, tolerance: tolerance))

        // cos(π) = -1
        let zPi = Complex.Number(Double.pi, 0.0)
        let cosPi = zPi.math.cos()
        #expect(cosPi.real.equals.approximate(-1.0, tolerance: tolerance))
        #expect(cosPi.imaginary.equals.approximate(0.0, tolerance: tolerance))

        // cos(π/2) = 0
        let zHalfPi = Complex.Number(Double.pi / 2, 0.0)
        let cosHalfPi = zHalfPi.math.cos()
        #expect(cosHalfPi.real.equals.approximate(0.0, tolerance: tolerance))
    }

    @Test
    func sin() {
        // sin(0) = 0
        let z0 = Complex.Number<Double>.zero
        let sin0 = z0.math.sin()
        #expect(sin0.equals.approximate(.zero, tolerance: tolerance))

        // sin(π/2) = 1
        let zHalfPi = Complex.Number(Double.pi / 2, 0.0)
        let sinHalfPi = zHalfPi.math.sin()
        #expect(sinHalfPi.real.equals.approximate(1.0, tolerance: tolerance))
        #expect(sinHalfPi.imaginary.equals.approximate(0.0, tolerance: tolerance))

        // sin(π) = 0
        let zPi = Complex.Number(Double.pi, 0.0)
        let sinPi = zPi.math.sin()
        #expect(sinPi.real.equals.approximate(0.0, tolerance: tolerance))
    }

    @Test
    func tan() {
        // tan(0) = 0
        let z0 = Complex.Number<Double>.zero
        let tan0 = z0.math.tan()
        #expect(tan0.equals.approximate(.zero, tolerance: tolerance))

        // tan(π/4) = 1
        let zQuarterPi = Complex.Number(Double.pi / 4, 0.0)
        let tanQuarterPi = zQuarterPi.math.tan()
        #expect(tanQuarterPi.real.equals.approximate(1.0, tolerance: tolerance))
        #expect(tanQuarterPi.imaginary.equals.approximate(0.0, tolerance: tolerance))
    }

    @Test
    func pythagoreanIdentity() {
        // sin²(z) + cos²(z) = 1
        let z = Complex.Number(0.7, 0.3)
        let sinZ = z.math.sin()
        let cosZ = z.math.cos()
        let sum = sinZ * sinZ + cosZ * cosZ
        #expect(sum.equals.approximate(.one, tolerance: tolerance))
    }

    // MARK: - Hyperbolic

    @Test
    func cosh() {
        // cosh(0) = 1
        let z0 = Complex.Number<Double>.zero
        let cosh0 = z0.math.cosh()
        #expect(cosh0.equals.approximate(.one, tolerance: tolerance))

        // cosh(x) = (exp(x) + exp(-x))/2 for real x
        let x = 1.5
        let zX = Complex.Number(x, 0.0)
        let coshX = zX.math.cosh()
        let expected = (Double.math.exp(x) + Double.math.exp(-x)) / 2
        #expect(coshX.real.equals.approximate(expected.real, tolerance: tolerance))
    }

    @Test
    func sinh() {
        // sinh(0) = 0
        let z0 = Complex.Number<Double>.zero
        let sinh0 = z0.math.sinh()
        #expect(sinh0.equals.approximate(.zero, tolerance: tolerance))

        // sinh(x) = (exp(x) - exp(-x))/2 for real x
        let x = 1.5
        let zX = Complex.Number(x, 0.0)
        let sinhX = zX.math.sinh()
        let expected = (Double.math.exp(x) - Double.math.exp(-x)) / 2
        #expect(sinhX.real.equals.approximate(expected.real, tolerance: tolerance))
    }

    @Test
    func tanh() {
        // tanh(0) = 0
        let z0 = Complex.Number<Double>.zero
        let tanh0 = z0.math.tanh()
        #expect(tanh0.equals.approximate(.zero, tolerance: tolerance))
    }

    @Test
    func hyperbolicIdentity() {
        // cosh²(z) - sinh²(z) = 1
        let z = Complex.Number(0.7, 0.3)
        let coshZ = z.math.cosh()
        let sinhZ = z.math.sinh()
        let diff = coshZ * coshZ - sinhZ * sinhZ
        #expect(diff.equals.approximate(.one, tolerance: tolerance))
    }

    // MARK: - Inverse Trigonometric

    @Test
    func acos() {
        // acos(1) = 0
        let z1 = Complex.Number<Double>.one
        let acos1 = z1.math.acos()
        #expect(acos1.equals.approximate(.zero, tolerance: tolerance))

        // acos(0) = π/2
        let z0 = Complex.Number<Double>.zero
        let acos0 = z0.math.acos()
        #expect(acos0.real.equals.approximate((Double.pi / 2).real, tolerance: tolerance))
    }

    @Test
    func asin() {
        // asin(0) = 0
        let z0 = Complex.Number<Double>.zero
        let asin0 = z0.math.asin()
        #expect(asin0.equals.approximate(.zero, tolerance: tolerance))

        // asin(1) = π/2
        let z1 = Complex.Number<Double>.one
        let asin1 = z1.math.asin()
        #expect(asin1.real.equals.approximate((Double.pi / 2).real, tolerance: tolerance))
    }

    @Test
    func atan() {
        // atan(0) = 0
        let z0 = Complex.Number<Double>.zero
        let atan0 = z0.math.atan()
        #expect(atan0.equals.approximate(.zero, tolerance: tolerance))
    }

    @Test
    func inverseIdentity() {
        // sin(asin(z)) = z
        let z = Complex.Number(0.3, 0.2)
        let result = z.math.asin().math.sin()
        #expect(result.equals.approximate(z, tolerance: tolerance))
    }

    // MARK: - Inverse Hyperbolic

    @Test
    func acosh() {
        // acosh(1) = 0
        let z1 = Complex.Number<Double>.one
        let acosh1 = z1.math.acosh()
        #expect(acosh1.equals.approximate(.zero, tolerance: tolerance))
    }

    @Test
    func asinh() {
        // asinh(0) = 0
        let z0 = Complex.Number<Double>.zero
        let asinh0 = z0.math.asinh()
        #expect(asinh0.equals.approximate(.zero, tolerance: tolerance))
    }

    @Test
    func atanh() {
        // atanh(0) = 0
        let z0 = Complex.Number<Double>.zero
        let atanh0 = z0.math.atanh()
        #expect(atanh0.equals.approximate(.zero, tolerance: tolerance))
    }

    // MARK: - Power Functions

    @Test
    func sqrt() {
        // sqrt(1) = 1
        let z1 = Complex.Number<Double>.one
        let sqrt1 = z1.math.sqrt()
        #expect(sqrt1.equals.approximate(.one, tolerance: tolerance))

        // sqrt(4) = 2
        let z4 = Complex.Number(4.0, 0.0)
        let sqrt4 = z4.math.sqrt()
        #expect(sqrt4.real.equals.approximate(2.0, tolerance: tolerance))
        #expect(sqrt4.imaginary.equals.approximate(0.0, tolerance: tolerance))

        // sqrt(-1) = i
        let zNeg1 = Complex.Number(-1.0, 0.0)
        let sqrtNeg1 = zNeg1.math.sqrt()
        #expect(sqrtNeg1.real.equals.approximate(0.0, tolerance: tolerance))
        #expect(sqrtNeg1.imaginary.equals.approximate(1.0, tolerance: tolerance))

        // sqrt(i) = (1 + i)/√2
        let zI = Complex.Number<Double>.i
        let sqrtI = zI.math.sqrt()
        let expected: Complex.Real<Double> = (1.0 / Double.math.sqrt(2)).real
        #expect(sqrtI.real.equals.approximate(expected, tolerance: tolerance))
        #expect(sqrtI.imaginary.equals.approximate(expected.value.i, tolerance: tolerance))
    }

    @Test
    func sqrtSquareIdentity() {
        // sqrt(z)² = z
        let z = Complex.Number(3.0, 4.0)
        let sqrtZ = z.math.sqrt()
        let result = sqrtZ * sqrtZ
        #expect(result.equals.approximate(z, tolerance: tolerance))
    }

    @Test
    func pow() {
        // z^0 = 1
        let z = Complex.Number(2.0, 3.0)
        let z0 = z.math.pow(0)
        #expect(z0.equals.approximate(.one, tolerance: tolerance))

        // z^1 = z
        let z1 = z.math.pow(1)
        #expect(z1.equals.approximate(z, tolerance: tolerance))

        // z^2 = z * z
        let z2 = z.math.pow(2)
        let expected = z * z
        #expect(z2.equals.approximate(expected, tolerance: tolerance))

        // i^2 = -1
        let i = Complex.Number<Double>.i
        let i2 = i.math.pow(2)
        #expect(i2.real.equals.approximate(-1.0, tolerance: tolerance))
        #expect(i2.imaginary.equals.approximate(0.0, tolerance: tolerance))
    }

    @Test
    func root() {
        // 8^(1/3) = 2
        let z8 = Complex.Number(8.0, 0.0)
        let cubeRoot = z8.math.root(3)
        #expect(cubeRoot.real.equals.approximate(2.0, tolerance: tolerance))
        #expect(cubeRoot.imaginary.equals.approximate(0.0, tolerance: tolerance))

        // z^(1/2) = sqrt(z)
        let z = Complex.Number(3.0, 4.0)
        let sqrtZ = z.math.sqrt()
        let root2 = z.math.root(2)
        #expect(root2.equals.approximate(sqrtZ, tolerance: tolerance))
    }
}
