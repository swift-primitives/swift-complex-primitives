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
struct ComplexDivisionTests {

    let tolerance: Complex.Real<Double> = 1e-10

    // MARK: - Basic Division

    @Test
    func basicDivision() {
        let z = Complex.Number(3.0, 4.0)
        let w = Complex.Number(1.0, 2.0)
        let result = z / w

        // Verify z/w * w = z
        let product = result * w
        #expect(product.equals.approximate(z, tolerance: tolerance))
    }

    @Test
    func divisionByOne() {
        let z = Complex.Number(3.0, 4.0)
        let result = z / Complex.Number<Double>.one
        #expect(result.equals.approximate(z, tolerance: tolerance))
    }

    @Test
    func divisionByI() {
        // z/i = z * (-i) = z * (0 - i)
        let z = Complex.Number(3.0, 4.0)
        let result = z / Complex.Number<Double>.i
        // (3 + 4i)/i = (3 + 4i)(-i) = -3i - 4i² = 4 - 3i
        let expected = Complex.Number(4.0, -3.0)
        #expect(result.equals.approximate(expected, tolerance: tolerance))
    }

    // MARK: - Edge Cases

    @Test
    func divisionByZero() {
        let z = Complex.Number(1.0, 2.0)
        let result = z / Complex.Number<Double>.zero
        #expect(!result.isFinite)
    }

    @Test
    func zeroDividedByNonZero() {
        let result = Complex.Number<Double>.zero / Complex.Number(1.0, 2.0)
        #expect(result.equals.approximate(Complex.Number<Double>.zero, tolerance: tolerance))
    }

    // MARK: - Rescaled Division (Overflow/Underflow)

    @Test
    func divisionWithLargeDenominator() {
        // Test division where naive computation would overflow
        let large = Double.greatestFiniteMagnitude / 4
        let z = Complex.Number(large, large)
        let w = Complex.Number(large, large)
        let result = z / w

        // z/z = 1
        #expect(result.equals.approximate(Complex.Number<Double>.one, tolerance: 1e-5))
    }

    @Test
    func divisionWithSmallDenominator() {
        // Test division where naive computation would underflow
        let small = Double.leastNormalMagnitude * 4
        let z = Complex.Number(1.0, 1.0)
        let w = Complex.Number(small, small)
        let result = z / w

        // Result should be large but finite
        #expect(result.isFinite)
        #expect(result.magnitude() > 1.0)
    }

    @Test
    func divisionPreservesScale() {
        // z/w should give the same result as (tz)/(tw) for any nonzero t
        let z = Complex.Number(3.0, 4.0)
        let w = Complex.Number(1.0, 2.0)
        let t: Complex.Real<Double> = Complex.Real(1e100)

        let result1 = z / w
        let result2 = z.scalar.multiply(by: t) / w.scalar.multiply(by: t)

        #expect(result1.equals.approximate(result2, tolerance: 1e-5))
    }

    // MARK: - Division Identities

    @Test
    func multiplicationDivisionInverse() {
        let z = Complex.Number(3.0, 4.0)
        let w = Complex.Number(1.0, 2.0)

        // (z * w) / w = z
        let product = z * w
        let result = product / w
        #expect(result.equals.approximate(z, tolerance: tolerance))
    }

    @Test
    func reciprocalConsistency() {
        let w = Complex.Number(1.0, 2.0)

        // 1/w should equal w.reciprocal
        let recip1 = Complex.Number<Double>.one / w
        let recip2 = w.reciprocal
        #expect(recip1.equals.approximate(recip2, tolerance: tolerance))
    }
}
