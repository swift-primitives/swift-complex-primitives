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
struct ComplexPropertiesTests {

    // MARK: - Finiteness

    @Test
    func isFinite() {
        let finite = Complex.Number(1.0, 2.0)
        #expect(finite.isFinite)

        let infReal = Complex.Number(Double.infinity, 0.0)
        #expect(!infReal.isFinite)

        let infImag = Complex.Number(0.0, Double.infinity)
        #expect(!infImag.isFinite)

        let nan = Complex.Number(Double.nan, 0.0)
        #expect(!nan.isFinite)
    }

    // MARK: - Zero

    @Test
    func isZero() {
        let zero = Complex.Number<Double>.zero
        #expect(zero.isZero)

        let notZero = Complex.Number(0.0, 1e-100)
        #expect(!notZero.isZero)
    }

    // MARK: - Normal

    @Test
    func isNormal() {
        let normal = Complex.Number(1.0, 2.0)
        #expect(normal.isNormal)

        let subnormal = Complex.Number(Double.leastNonzeroMagnitude, 0.0)
        #expect(!subnormal.isNormal)

        let zero = Complex.Number<Double>.zero
        #expect(!zero.isNormal)
    }

    // MARK: - Subnormal

    @Test
    func isSubnormal() {
        let subnormal = Complex.Number(Double.leastNonzeroMagnitude, 0.0)
        #expect(subnormal.isSubnormal)

        let normal = Complex.Number(1.0, 2.0)
        #expect(!normal.isSubnormal)

        let zero = Complex.Number<Double>.zero
        #expect(!zero.isSubnormal)
    }

    // MARK: - Normalized

    @Test
    func normalized() {
        let z = Complex.Number(3.0, 4.0)
        let n = z.normalized!

        // Normalized should have unit length
        #expect(n.magnitude().equals.approximate(1.0, tolerance: 1e-10))

        // Should have same phase
        #expect(
            n.polar.phase.underlying.equals.approximate(
                z.polar.phase.underlying,
                tolerance: 1e-10
            )
        )
    }

    @Test
    func normalizedZero() {
        let zero = Complex.Number<Double>.zero
        #expect(zero.normalized == nil)
    }

    @Test
    func normalizedInfinity() {
        let inf = Complex.Number<Double>.infinity
        #expect(inf.normalized == nil)
    }

    // MARK: - Magnitude

    @Test
    func magnitude() {
        let z = Complex.Number(3.0, 4.0)
        #expect(z.magnitude().equals.approximate(5.0, tolerance: 1e-10))
    }

    @Test
    func magnitudeSquared() {
        let z = Complex.Number(3.0, 4.0)
        #expect(z.magnitude.squared.equals.approximate(25.0, tolerance: 1e-10))
    }

    // MARK: - String Representation

    @Test
    func description() {
        let z = Complex.Number(3.0, 4.0)
        #expect(z.description == "(3.0, 4.0)")

        let inf = Complex.Number<Double>.infinity
        #expect(inf.description == "inf")
    }

    // MARK: - Approximate Equality

    @Test
    func approximateEquality() {
        let z = Complex.Number(1.0, 2.0)
        let w = Complex.Number(1.0 + 1e-12, 2.0 + 1e-12)

        #expect(z.equals.approximate(w, tolerance: 1e-10))
        #expect(!z.equals.approximate(w, tolerance: 1e-15))
    }

    @Test
    func approximateEqualityRelative() {
        let z = Complex.Number(1000.0, 2000.0)
        let w = Complex.Number(1000.1, 2000.1)

        #expect(z.equals.approximate(w, absolute: 0.0, relative: 1e-3))
        #expect(!z.equals.approximate(w, absolute: 0.0, relative: 1e-5))
    }

    @Test
    func componentwiseApproximateEquality() {
        let z = Complex.Number(1.0, 2.0)
        let w = Complex.Number(1.0 + 1e-12, 2.0 + 1e-12)

        #expect(z.equals.componentwise.approximate(w, tolerance: 1e-10))
        #expect(!z.equals.componentwise.approximate(w, tolerance: 1e-15))
    }
}
