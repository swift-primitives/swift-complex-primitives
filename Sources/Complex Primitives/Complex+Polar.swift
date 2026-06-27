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

public import Dimension_Primitives

// MARK: - Polar Accessor

extension Complex.Number {
    /// Access polar form operations.
    ///
    /// ```swift
    /// let z = Complex.Number(3.0, 4.0)
    /// let r = z.polar.length  // 5.0
    /// let θ = z.polar.phase   // atan2(4, 3)
    /// ```
    @inlinable
    public var polar: Polar { Polar(self) }
}

// MARK: - BinaryFloatingPoint & Numeric.Transcendental

extension Complex.Number.Polar where Scalar: BinaryFloatingPoint & Numeric.Transcendental {
    /// Returns the modulus (absolute value) of a complex number.
    ///
    /// The modulus is `√(real² + imaginary²)`, computed using `hypot`
    /// to avoid overflow.
    @inlinable
    public static func length(of z: Complex.Number<Scalar>) -> Complex.Number<Scalar>.Modulus.Value {
        Complex.Number.Modulus.Value(_unchecked: Scalar._hypot(z.real._value, z.imaginary._value))
    }

    /// The modulus (absolute value) of this complex number.
    @inlinable
    public var length: Complex.Number<Scalar>.Modulus.Value {
        Self.length(of: complex)
    }

    /// Returns the phase (argument) of a complex number in radians.
    ///
    /// The phase is `atan2(imaginary, real)`, in the range `(-π, π]`.
    @inlinable
    public static func phase(of z: Complex.Number<Scalar>) -> Radian<Scalar> {
        Radian(_unchecked: Scalar._atan2(z.imaginary._value, z.real._value))
    }

    /// The phase (argument) in radians.
    @inlinable
    public var phase: Radian<Scalar> {
        Self.phase(of: complex)
    }

    /// Returns the squared modulus (faster than computing length).
    ///
    /// Useful when comparing magnitudes or when the square is needed.
    @inlinable
    public static func squared(of z: Complex.Number<Scalar>) -> Scalar {
        z.real._value * z.real._value + z.imaginary._value * z.imaginary._value
    }

    /// The squared modulus (faster than computing length).
    @inlinable
    public var squared: Scalar {
        Self.squared(of: complex)
    }
}

extension Complex.Number where Scalar: BinaryFloatingPoint & Numeric.Transcendental {
    /// Creates a complex number from polar form.
    ///
    /// Given length `r` and phase `θ`, creates `r·(cos(θ) + i·sin(θ))`.
    ///
    /// ```swift
    /// let z = Complex.Number(
    ///     length: Complex.Number.Modulus.Value(5.0),
    ///     phase: Radian(.pi / 4)
    /// )
    /// // z ≈ 3.54 + 3.54i
    /// ```
    @inlinable
    public init(length: Complex.Number<Scalar>.Modulus.Value, phase: Radian<Scalar>) {
        let r = length.underlying
        let theta = phase.underlying
        self.init(
            r * Scalar._cos(theta),
            r * Scalar._sin(theta)
        )
    }
}
