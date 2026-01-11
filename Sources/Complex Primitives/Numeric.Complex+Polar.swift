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

extension Numeric.Complex {
    /// Access polar form operations.
    ///
    /// ```swift
    /// let z = Numeric.Complex(3.0, 4.0)
    /// let r = z.polar.length  // 5.0
    /// let θ = z.polar.phase   // atan2(4, 3)
    /// ```
    @inlinable
    public var polar: Polar { Polar(self) }
}

// MARK: - Double

extension Numeric.Complex.Polar where Scalar == Double {
    /// Returns the modulus (absolute value) of a complex number.
    ///
    /// The modulus is `√(real² + imaginary²)`, computed using `hypot`
    /// to avoid overflow.
    @inlinable
    public static func length(of z: Numeric.Complex<Scalar>) -> Numeric.Complex<Scalar>.Modulus.Value {
        Numeric.Complex.Modulus.Value(Double.math.hypot(z.real._value, z.imaginary._value))
    }

    /// The modulus (absolute value) of this complex number.
    @inlinable
    public var length: Numeric.Complex<Scalar>.Modulus.Value {
        Self.length(of: complex)
    }

    /// Returns the phase (argument) of a complex number in radians.
    ///
    /// The phase is `atan2(imaginary, real)`, in the range `(-π, π]`.
    @inlinable
    public static func phase(of z: Numeric.Complex<Scalar>) -> Radian<Scalar> {
        Radian(Double.math.atan2(z.imaginary._value, z.real._value))
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
    public static func squared(of z: Numeric.Complex<Scalar>) -> Scalar {
        z.real._value * z.real._value + z.imaginary._value * z.imaginary._value
    }

    /// The squared modulus (faster than computing length).
    @inlinable
    public var squared: Scalar {
        Self.squared(of: complex)
    }
}

extension Numeric.Complex where Scalar == Double {
    /// Creates a complex number from polar form.
    ///
    /// Given length `r` and phase `θ`, creates `r·(cos(θ) + i·sin(θ))`.
    ///
    /// ```swift
    /// let z = Numeric.Complex(
    ///     length: Numeric.Complex.Modulus.Value(5.0),
    ///     phase: Radian(.pi / 4)
    /// )
    /// // z ≈ 3.54 + 3.54i
    /// ```
    @inlinable
    public init(length: Numeric.Complex<Scalar>.Modulus.Value, phase: Radian<Scalar>) {
        let r = length.rawValue
        let θ = phase.rawValue
        self.init(
            r * Double.math.cos(θ),
            r * Double.math.sin(θ)
        )
    }
}

// MARK: - Float

extension Numeric.Complex.Polar where Scalar == Float {
    /// Returns the modulus (absolute value) of a complex number.
    @inlinable
    public static func length(of z: Numeric.Complex<Scalar>) -> Numeric.Complex<Scalar>.Modulus.Value {
        Numeric.Complex.Modulus.Value(Float.math.hypot(z.real._value, z.imaginary._value))
    }

    /// The modulus (absolute value) of this complex number.
    @inlinable
    public var length: Numeric.Complex<Scalar>.Modulus.Value {
        Self.length(of: complex)
    }

    /// Returns the phase (argument) of a complex number in radians.
    @inlinable
    public static func phase(of z: Numeric.Complex<Scalar>) -> Radian<Scalar> {
        Radian(Float.math.atan2(z.imaginary._value, z.real._value))
    }

    /// The phase (argument) in radians.
    @inlinable
    public var phase: Radian<Scalar> {
        Self.phase(of: complex)
    }

    /// Returns the squared modulus (faster than computing length).
    @inlinable
    public static func squared(of z: Numeric.Complex<Scalar>) -> Scalar {
        z.real._value * z.real._value + z.imaginary._value * z.imaginary._value
    }

    /// The squared modulus (faster than computing length).
    @inlinable
    public var squared: Scalar {
        Self.squared(of: complex)
    }
}

extension Numeric.Complex where Scalar == Float {
    /// Creates a complex number from polar form.
    @inlinable
    public init(length: Numeric.Complex<Scalar>.Modulus.Value, phase: Radian<Scalar>) {
        let r = length.rawValue
        let θ = phase.rawValue
        self.init(
            r * Float.math.cos(θ),
            r * Float.math.sin(θ)
        )
    }
}
