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

extension Numeric.Relaxed {
    /// `a + b` for complex numbers, with relaxed semantics.
    ///
    /// Permits the optimizer to reassociate and form FMAs componentwise.
    @inlinable
    public static func sum(
        _ a: Numeric.Complex<Double>,
        _ b: Numeric.Complex<Double>
    ) -> Numeric.Complex<Double> {
        Numeric.Complex(
            Numeric.Relaxed.sum(a.real._value, b.real._value),
            Numeric.Relaxed.sum(a.imaginary._value, b.imaginary._value)
        )
    }

    /// `a * b` for complex numbers, with relaxed semantics.
    ///
    /// Permits the optimizer to reassociate and form FMAs.
    @inlinable
    public static func product(
        _ a: Numeric.Complex<Double>,
        _ b: Numeric.Complex<Double>
    ) -> Numeric.Complex<Double> {
        // (a + bi)(c + di) = (ac - bd) + (ad + bc)i
        Numeric.Complex(
            Numeric.Relaxed.sum(
                Numeric.Relaxed.product(a.real._value, b.real._value),
                -Numeric.Relaxed.product(a.imaginary._value, b.imaginary._value)
            ),
            Numeric.Relaxed.sum(
                Numeric.Relaxed.product(a.real._value, b.imaginary._value),
                Numeric.Relaxed.product(a.imaginary._value, b.real._value)
            )
        )
    }

    /// `a * b + c` for complex numbers, with relaxed semantics.
    @inlinable
    public static func multiplyAdd(
        _ a: Numeric.Complex<Double>,
        _ b: Numeric.Complex<Double>,
        _ c: Numeric.Complex<Double>
    ) -> Numeric.Complex<Double> {
        sum(product(a, b), c)
    }

    /// `z * s` for complex times scalar, with relaxed semantics.
    @inlinable
    public static func product(
        _ z: Numeric.Complex<Double>,
        _ s: Double
    ) -> Numeric.Complex<Double> {
        Numeric.Complex(
            Numeric.Relaxed.product(z.real._value, s),
            Numeric.Relaxed.product(z.imaginary._value, s)
        )
    }

    /// `s * z` for scalar times complex, with relaxed semantics.
    @inlinable
    public static func product(
        _ s: Double,
        _ z: Numeric.Complex<Double>
    ) -> Numeric.Complex<Double> {
        product(z, s)
    }
}

// MARK: - Float

extension Numeric.Relaxed {
    /// `a + b` for complex numbers, with relaxed semantics.
    @inlinable
    public static func sum(
        _ a: Numeric.Complex<Float>,
        _ b: Numeric.Complex<Float>
    ) -> Numeric.Complex<Float> {
        Numeric.Complex(
            Numeric.Relaxed.sum(a.real._value, b.real._value),
            Numeric.Relaxed.sum(a.imaginary._value, b.imaginary._value)
        )
    }

    /// `a * b` for complex numbers, with relaxed semantics.
    @inlinable
    public static func product(
        _ a: Numeric.Complex<Float>,
        _ b: Numeric.Complex<Float>
    ) -> Numeric.Complex<Float> {
        Numeric.Complex(
            Numeric.Relaxed.sum(
                Numeric.Relaxed.product(a.real._value, b.real._value),
                -Numeric.Relaxed.product(a.imaginary._value, b.imaginary._value)
            ),
            Numeric.Relaxed.sum(
                Numeric.Relaxed.product(a.real._value, b.imaginary._value),
                Numeric.Relaxed.product(a.imaginary._value, b.real._value)
            )
        )
    }

    /// `a * b + c` for complex numbers, with relaxed semantics.
    @inlinable
    public static func multiplyAdd(
        _ a: Numeric.Complex<Float>,
        _ b: Numeric.Complex<Float>,
        _ c: Numeric.Complex<Float>
    ) -> Numeric.Complex<Float> {
        sum(product(a, b), c)
    }

    /// `z * s` for complex times scalar, with relaxed semantics.
    @inlinable
    public static func product(
        _ z: Numeric.Complex<Float>,
        _ s: Float
    ) -> Numeric.Complex<Float> {
        Numeric.Complex(
            Numeric.Relaxed.product(z.real._value, s),
            Numeric.Relaxed.product(z.imaginary._value, s)
        )
    }

    /// `s * z` for scalar times complex, with relaxed semantics.
    @inlinable
    public static func product(
        _ s: Float,
        _ z: Numeric.Complex<Float>
    ) -> Numeric.Complex<Float> {
        product(z, s)
    }
}
