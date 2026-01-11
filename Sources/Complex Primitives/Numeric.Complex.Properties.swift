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

extension Numeric.Complex where Scalar == Double {
    /// True if this value is finite.
    ///
    /// A complex value is finite if neither component is infinity or NaN.
    @inlinable
    public var isFinite: Bool {
        real.isFinite && imaginary.isFinite
    }

    /// True if this value is zero.
    ///
    /// A complex number is zero if both real and imaginary components are zero.
    @inlinable
    public var isZero: Bool {
        real.isZero && imaginary.isZero
    }

    /// True if this value is normal.
    ///
    /// A complex number is normal if it is finite and either the real or
    /// imaginary component is normal.
    @inlinable
    public var isNormal: Bool {
        isFinite && (real.isNormal || imaginary.isNormal)
    }

    /// True if this value is subnormal.
    ///
    /// A complex number is subnormal if it is finite, not normal, and not zero.
    @inlinable
    public var isSubnormal: Bool {
        isFinite && !isNormal && !isZero
    }

    /// The point at infinity.
    @inlinable
    public static var infinity: Self {
        Self(.infinity, 0)
    }

    /// A unit complex number with the same phase as this value.
    ///
    /// Returns `nil` if the phase is undefined (zero or non-finite values).
    ///
    /// ```swift
    /// let z = Numeric.Complex(3.0, 4.0)
    /// z.normalized  // Optional(0.6 + 0.8i)
    /// ```
    @inlinable
    public var normalized: Self? {
        let length = magnitude()._value
        if length.isNormal {
            return Self(real._value / length, imaginary._value / length)
        }
        if isZero || !isFinite {
            return nil
        }
        // Badly-scaled: rescale and retry
        let scale = max(abs(real._value), abs(imaginary._value))
        return Self(real._value / scale, imaginary._value / scale).normalized
    }
}

// MARK: - Float

extension Numeric.Complex where Scalar == Float {
    /// True if this value is finite.
    @inlinable
    public var isFinite: Bool {
        real.isFinite && imaginary.isFinite
    }

    /// True if this value is zero.
    @inlinable
    public var isZero: Bool {
        real.isZero && imaginary.isZero
    }

    /// True if this value is normal.
    @inlinable
    public var isNormal: Bool {
        isFinite && (real.isNormal || imaginary.isNormal)
    }

    /// True if this value is subnormal.
    @inlinable
    public var isSubnormal: Bool {
        isFinite && !isNormal && !isZero
    }

    /// The point at infinity.
    @inlinable
    public static var infinity: Self {
        Self(.infinity, 0)
    }

    /// A unit complex number with the same phase as this value.
    @inlinable
    public var normalized: Self? {
        let length = magnitude()._value
        if length.isNormal {
            return Self(real._value / length, imaginary._value / length)
        }
        if isZero || !isFinite {
            return nil
        }
        let scale = max(abs(real._value), abs(imaginary._value))
        return Self(real._value / scale, imaginary._value / scale).normalized
    }
}
