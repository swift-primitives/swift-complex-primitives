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
struct ComplexArithmeticTests {

    // MARK: - Construction

    @Test
    func construction() {
        let z = Numeric.Complex(3.0, 4.0)
        #expect(z.real == 3.0)
        #expect(z.imaginary == 4.0)
    }

    @Test
    func realConstruction() {
        let z = Numeric.Complex<Double>(5.0)
        #expect(z.real == 5.0)
        #expect(z.imaginary == 0.0)
    }

    @Test
    func staticProperties() {
        let zero = Numeric.Complex<Double>.zero
        #expect(zero.real == 0.0)
        #expect(zero.imaginary == 0.0)

        let one = Numeric.Complex<Double>.one
        #expect(one.real == 1.0)
        #expect(one.imaginary == 0.0)

        let i = Numeric.Complex<Double>.i
        #expect(i.real == 0.0)
        #expect(i.imaginary == 1.0)
    }

    // MARK: - Addition

    @Test
    func addition() {
        let z = Numeric.Complex(1.0, 2.0)
        let w = Numeric.Complex(3.0, 4.0)
        let sum = z + w
        #expect(sum.real == 4.0)
        #expect(sum.imaginary == 6.0)
    }

    @Test
    func additionWithScalar() {
        let z = Numeric.Complex(1.0, 2.0)
        let sum1 = z + 5.0
        #expect(sum1.real == 6.0)
        #expect(sum1.imaginary == 2.0)

        let sum2 = 5.0 + z
        #expect(sum2.real == 6.0)
        #expect(sum2.imaginary == 2.0)
    }

    // MARK: - Subtraction

    @Test
    func subtraction() {
        let z = Numeric.Complex(5.0, 7.0)
        let w = Numeric.Complex(2.0, 3.0)
        let diff = z - w
        #expect(diff.real == 3.0)
        #expect(diff.imaginary == 4.0)
    }

    @Test
    func negation() {
        let z = Numeric.Complex(3.0, -4.0)
        let neg = -z
        #expect(neg.real == -3.0)
        #expect(neg.imaginary == 4.0)
    }

    // MARK: - Multiplication

    @Test
    func multiplication() {
        // (1 + 2i)(3 + 4i) = 3 + 4i + 6i + 8i² = 3 + 10i - 8 = -5 + 10i
        let z = Numeric.Complex(1.0, 2.0)
        let w = Numeric.Complex(3.0, 4.0)
        let product = z * w
        #expect(product.real.equals.approximate(-5.0, tolerance: 1e-10))
        #expect(product.imaginary.equals.approximate(10.0, tolerance: 1e-10))
    }

    @Test
    func multiplicationWithScalar() {
        let z = Numeric.Complex(2.0, 3.0)
        let product = z * 2.0
        #expect(product.real == 4.0)
        #expect(product.imaginary == 6.0)
    }

    @Test
    func iSquaredIsMinusOne() {
        let i = Numeric.Complex<Double>.i
        let iSquared = i * i
        #expect(iSquared.real.equals.approximate(-1.0, tolerance: 1e-15))
        #expect(iSquared.imaginary.equals.approximate(0.0, tolerance: 1e-15))
    }

    // MARK: - Division

    @Test
    func division() {
        // (3 + 4i)/(1 + 2i) = (3 + 4i)(1 - 2i)/5 = (3 + 8 + 4i - 6i)/5 = (11 - 2i)/5
        let z = Numeric.Complex(3.0, 4.0)
        let w = Numeric.Complex(1.0, 2.0)
        let quotient = z / w
        #expect(quotient.real.equals.approximate(11.0 / 5.0, tolerance: 1e-10))
        #expect(quotient.imaginary.equals.approximate(-2.0 / 5.0, tolerance: 1e-10))
    }

    @Test
    func divisionByScalar() {
        let z = Numeric.Complex(4.0, 6.0)
        let quotient = z / 2.0
        #expect(quotient.real == 2.0)
        #expect(quotient.imaginary == 3.0)
    }

    // MARK: - Conjugate

    @Test
    func conjugate() {
        let z = Numeric.Complex(3.0, 4.0)

        // Static method
        let conj1 = Numeric.Complex.conjugate(of: z)
        #expect(conj1.real == 3.0)
        #expect(conj1.imaginary == -4.0)

        // Instance property
        let conj2 = z.conjugate
        #expect(conj2 == conj1)

        // Conjugate of conjugate is original
        #expect(conj1.conjugate == z)
    }

    @Test
    func conjugateProduct() {
        // z * conjugate(z) = |z|²
        let z = Numeric.Complex(3.0, 4.0)
        let product = z * z.conjugate
        #expect(product.real.equals.approximate(25.0, tolerance: 1e-10))
        #expect(product.imaginary.equals.approximate(0.0, tolerance: 1e-15))
    }

    // MARK: - Reciprocal

    @Test
    func reciprocal() {
        let z = Numeric.Complex(3.0, 4.0)

        // Static method
        let recip1 = Numeric.Complex.reciprocal(of: z)

        // z * 1/z = 1
        let product = z * recip1
        #expect(product.real.equals.approximate(1.0, tolerance: 1e-10))
        #expect(product.imaginary.equals.approximate(0.0, tolerance: 1e-10))

        // Instance property
        let recip2 = z.reciprocal
        #expect(recip1 == recip2)
    }
}
