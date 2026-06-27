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

extension Complex.Number {
    /// Phantom type tag for complex modulus (absolute value) quantities.
    ///
    /// Use `Complex.Number.Modulus.Value<Scalar>` for type-safe representation of complex
    /// magnitudes. This prevents accidentally mixing modulus values with
    /// raw scalars or other quantities.
    public enum Modulus {}
}

extension Complex.Number.Modulus {
    /// A complex modulus (absolute value) as a type-safe tagged value.
    ///
    /// ```swift
    /// let z = Complex.Number(3.0, 4.0)
    /// let length: Complex.Number.Modulus.Value<Double> = z.polar.length  // 5.0
    /// ```
    public typealias Value = Tagged<Complex.Number<Scalar>.Modulus, Scalar>
}

// MARK: - Arithmetic

extension Tagged where Tag == Complex.Number<Underlying>.Modulus, Underlying: AdditiveArithmetic {
    /// Returns the sum of two modulus values.
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(_unchecked: lhs.underlying + rhs.underlying)
    }

    /// Returns the difference of two modulus values.
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(_unchecked: lhs.underlying - rhs.underlying)
    }
}

extension Tagged where Tag == Complex.Number<Underlying>.Modulus, Underlying: Swift.Numeric {
    /// Returns the product of two modulus values.
    @inlinable
    public static func * (lhs: Self, rhs: Self) -> Self {
        Self(_unchecked: lhs.underlying * rhs.underlying)
    }
}

extension Tagged where Tag == Complex.Number<Underlying>.Modulus, Underlying: FloatingPoint {
    /// Returns the quotient of two modulus values.
    @inlinable
    public static func / (lhs: Self, rhs: Self) -> Self {
        Self(_unchecked: lhs.underlying / rhs.underlying)
    }
}
