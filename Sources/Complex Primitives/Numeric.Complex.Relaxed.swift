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

// MARK: - Relaxed Arithmetic

extension Numeric.Relaxed {
    /// `a + b` for complex numbers, with relaxed semantics.
    ///
    /// Permits the optimizer to reassociate and form FMAs componentwise.
    ///
    /// - Parameters:
    ///   - a: First summand.
    ///   - b: Second summand.
    /// - Returns: The sum `a + b`.
    @inlinable
    public static func sum<T: Numeric.Real>(
        _ a: Numeric.Complex<T>,
        _ b: Numeric.Complex<T>
    ) -> Numeric.Complex<T> {
        Numeric.Complex(
            T._relaxedAdd(a.real, b.real),
            T._relaxedAdd(a.imaginary, b.imaginary)
        )
    }

    /// `a * b` for complex numbers, with relaxed semantics.
    ///
    /// Permits the optimizer to reassociate and form FMAs.
    ///
    /// - Parameters:
    ///   - a: First multiplicand.
    ///   - b: Second multiplicand.
    /// - Returns: The product `a * b`.
    @inlinable
    public static func product<T: Numeric.Real>(
        _ a: Numeric.Complex<T>,
        _ b: Numeric.Complex<T>
    ) -> Numeric.Complex<T> {
        // (a + bi)(c + di) = (ac - bd) + (ad + bc)i
        Numeric.Complex(
            T._relaxedAdd(
                T._relaxedMul(a.real, b.real),
                -T._relaxedMul(a.imaginary, b.imaginary)
            ),
            T._relaxedAdd(
                T._relaxedMul(a.real, b.imaginary),
                T._relaxedMul(a.imaginary, b.real)
            )
        )
    }

    /// `a * b + c` for complex numbers, with relaxed semantics.
    ///
    /// The optimizer may compute this as fused multiply-add operations.
    ///
    /// - Parameters:
    ///   - a: First multiplicand.
    ///   - b: Second multiplicand.
    ///   - c: Addend.
    /// - Returns: `a * b + c`.
    @inlinable
    public static func multiplyAdd<T: Numeric.Real>(
        _ a: Numeric.Complex<T>,
        _ b: Numeric.Complex<T>,
        _ c: Numeric.Complex<T>
    ) -> Numeric.Complex<T> {
        sum(product(a, b), c)
    }
}

// MARK: - Complex-Scalar Relaxed Operations

extension Numeric.Relaxed {
    /// `z * s` for complex times scalar, with relaxed semantics.
    ///
    /// - Parameters:
    ///   - z: Complex number.
    ///   - s: Scalar multiplier.
    /// - Returns: `z * s`.
    @inlinable
    public static func product<T: Numeric.Real>(
        _ z: Numeric.Complex<T>,
        _ s: T
    ) -> Numeric.Complex<T> {
        Numeric.Complex(
            T._relaxedMul(z.real, s),
            T._relaxedMul(z.imaginary, s)
        )
    }

    /// `s * z` for scalar times complex, with relaxed semantics.
    ///
    /// - Parameters:
    ///   - s: Scalar multiplier.
    ///   - z: Complex number.
    /// - Returns: `s * z`.
    @inlinable
    public static func product<T: Numeric.Real>(
        _ s: T,
        _ z: Numeric.Complex<T>
    ) -> Numeric.Complex<T> {
        product(z, s)
    }
}
