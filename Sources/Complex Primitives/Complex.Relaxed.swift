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
        _ a: Complex.Number<Double>,
        _ b: Complex.Number<Double>
    ) -> Complex.Number<Double> {
        Complex.Number(
            Self.sum(a.real._value, b.real._value),
            Self.sum(a.imaginary._value, b.imaginary._value)
        )
    }

    /// `a * b` for complex numbers, with relaxed semantics.
    ///
    /// Permits the optimizer to reassociate and form FMAs.
    @inlinable
    public static func product(
        _ a: Complex.Number<Double>,
        _ b: Complex.Number<Double>
    ) -> Complex.Number<Double> {
        // (a + bi)(c + di) = (ac - bd) + (ad + bc)i
        Complex.Number(
            Self.sum(
                Self.product(a.real._value, b.real._value),
                -Self.product(a.imaginary._value, b.imaginary._value)
            ),
            Self.sum(
                Self.product(a.real._value, b.imaginary._value),
                Self.product(a.imaginary._value, b.real._value)
            )
        )
    }

    /// `a * b + c` for complex numbers, with relaxed semantics.
    @inlinable
    public static func multiplyAdd(
        _ a: Complex.Number<Double>,
        _ b: Complex.Number<Double>,
        _ c: Complex.Number<Double>
    ) -> Complex.Number<Double> {
        sum(product(a, b), c)
    }

    /// `z * s` for complex times scalar, with relaxed semantics.
    @inlinable
    public static func product(
        _ z: Complex.Number<Double>,
        _ s: Double
    ) -> Complex.Number<Double> {
        Complex.Number(
            Self.product(z.real._value, s),
            Self.product(z.imaginary._value, s)
        )
    }

    /// `s * z` for scalar times complex, with relaxed semantics.
    @inlinable
    public static func product(
        _ s: Double,
        _ z: Complex.Number<Double>
    ) -> Complex.Number<Double> {
        product(z, s)
    }
}

// MARK: - Float

extension Numeric.Relaxed {
    /// `a + b` for complex numbers, with relaxed semantics.
    @inlinable
    public static func sum(
        _ a: Complex.Number<Float>,
        _ b: Complex.Number<Float>
    ) -> Complex.Number<Float> {
        Complex.Number(
            Self.sum(a.real._value, b.real._value),
            Self.sum(a.imaginary._value, b.imaginary._value)
        )
    }

    /// `a * b` for complex numbers, with relaxed semantics.
    @inlinable
    public static func product(
        _ a: Complex.Number<Float>,
        _ b: Complex.Number<Float>
    ) -> Complex.Number<Float> {
        Complex.Number(
            Self.sum(
                Self.product(a.real._value, b.real._value),
                -Self.product(a.imaginary._value, b.imaginary._value)
            ),
            Self.sum(
                Self.product(a.real._value, b.imaginary._value),
                Self.product(a.imaginary._value, b.real._value)
            )
        )
    }

    /// `a * b + c` for complex numbers, with relaxed semantics.
    @inlinable
    public static func multiplyAdd(
        _ a: Complex.Number<Float>,
        _ b: Complex.Number<Float>,
        _ c: Complex.Number<Float>
    ) -> Complex.Number<Float> {
        sum(product(a, b), c)
    }

    /// `z * s` for complex times scalar, with relaxed semantics.
    @inlinable
    public static func product(
        _ z: Complex.Number<Float>,
        _ s: Float
    ) -> Complex.Number<Float> {
        Complex.Number(
            Self.product(z.real._value, s),
            Self.product(z.imaginary._value, s)
        )
    }

    /// `s * z` for scalar times complex, with relaxed semantics.
    @inlinable
    public static func product(
        _ s: Float,
        _ z: Complex.Number<Float>
    ) -> Complex.Number<Float> {
        product(z, s)
    }
}
