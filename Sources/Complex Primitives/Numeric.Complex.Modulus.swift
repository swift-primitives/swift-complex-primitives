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

extension Numeric.Complex {
    /// Phantom type tag for complex modulus (absolute value) quantities.
    ///
    /// Use `Numeric.Complex.Modulus.Value<Scalar>` for type-safe representation of complex
    /// magnitudes. This prevents accidentally mixing modulus values with
    /// raw scalars or other quantities.
    public enum Modulus {}
}

extension Numeric.Complex.Modulus {
    /// A complex modulus (absolute value) as a type-safe tagged value.
    ///
    /// ```swift
    /// let z = Numeric.Complex(3.0, 4.0)
    /// let length: Numeric.Complex.Modulus.Value<Double> = z.polar.length  // 5.0
    /// ```
    public typealias Value = Tagged<Numeric.Complex<Scalar>.Modulus, Scalar>
}

// MARK: - Arithmetic

extension Tagged where Tag == Numeric.Complex<RawValue>.Modulus, RawValue: AdditiveArithmetic {
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(lhs.rawValue + rhs.rawValue)
    }

    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(lhs.rawValue - rhs.rawValue)
    }
}

extension Tagged where Tag == Numeric.Complex<RawValue>.Modulus, RawValue: Swift.Numeric {
    @inlinable
    public static func * (lhs: Self, rhs: Self) -> Self {
        Self(lhs.rawValue * rhs.rawValue)
    }
}

extension Tagged where Tag == Numeric.Complex<RawValue>.Modulus, RawValue: FloatingPoint {
    @inlinable
    public static func / (lhs: Self, rhs: Self) -> Self {
        Self(lhs.rawValue / rhs.rawValue)
    }
}
