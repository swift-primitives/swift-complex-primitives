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

// MARK: - Length (Modulus)

extension Numeric.Complex.Polar {
    /// Returns the modulus (absolute value) of a complex number.
    ///
    /// The modulus is `√(real² + imaginary²)`, computed using `hypot`
    /// to avoid overflow.
    @inlinable
    public static func length(of z: Numeric.Complex<Scalar>) -> Numeric.Complex<Scalar>.Modulus.Value {
        Numeric.Complex.Modulus.Value(Scalar.math.hypot(z.real, z.imaginary))
    }

    /// The modulus (absolute value) of this complex number.
    @inlinable
    public var length: Numeric.Complex<Scalar>.Modulus.Value {
        Self.length(of: complex)
    }
}

// MARK: - Phase (Argument)

extension Numeric.Complex.Polar {
    /// Returns the phase (argument) of a complex number in radians.
    ///
    /// The phase is `atan2(imaginary, real)`, in the range `(-π, π]`.
    @inlinable
    public static func phase(of z: Numeric.Complex<Scalar>) -> Radian<Scalar> {
        Radian(Scalar.math.atan2(z.imaginary, z.real))
    }

    /// The phase (argument) in radians.
    @inlinable
    public var phase: Radian<Scalar> {
        Self.phase(of: complex)
    }
}

// MARK: - Polar Construction

extension Numeric.Complex {
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
            r * Scalar.math.cos(θ),
            r * Scalar.math.sin(θ)
        )
    }
}

// MARK: - Squared Length

extension Numeric.Complex.Polar {
    /// Returns the squared modulus (faster than computing length).
    ///
    /// Useful when comparing magnitudes or when the square is needed.
    @inlinable
    public static func squared(of z: Numeric.Complex<Scalar>) -> Scalar {
        z.real * z.real + z.imaginary * z.imaginary
    }

    /// The squared modulus (faster than computing length).
    @inlinable
    public var squared: Scalar {
        Self.squared(of: complex)
    }
}
