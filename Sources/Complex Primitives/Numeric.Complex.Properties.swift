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

// MARK: - Finiteness

extension Numeric.Complex {
    /// True if this value is finite.
    ///
    /// A complex value is finite if neither component is infinity or NaN.
    @inlinable
    public var isFinite: Bool {
        real.isFinite && imaginary.isFinite
    }
}

// MARK: - Zero

extension Numeric.Complex {
    /// True if this value is zero.
    ///
    /// A complex number is zero if both real and imaginary components are zero.
    @inlinable
    public var isZero: Bool {
        real == .zero && imaginary == .zero
    }
}

// MARK: - Normal

extension Numeric.Complex {
    /// True if this value is normal.
    ///
    /// A complex number is normal if it is finite and either the real or
    /// imaginary component is normal.
    @inlinable
    public var isNormal: Bool {
        isFinite && (real.isNormal || imaginary.isNormal)
    }
}

// MARK: - Subnormal

extension Numeric.Complex {
    /// True if this value is subnormal.
    ///
    /// A complex number is subnormal if it is finite, not normal, and not zero.
    @inlinable
    public var isSubnormal: Bool {
        isFinite && !isNormal && !isZero
    }
}

// MARK: - Infinity

extension Numeric.Complex {
    /// The point at infinity.
    @inlinable
    public static var infinity: Self {
        Self(.infinity, .zero)
    }
}

// MARK: - Normalized

extension Numeric.Complex {
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
        let length = magnitude()
        if length.isNormal {
            return self.scalar.divide(by: length)
        }
        if isZero || !isFinite {
            return nil
        }
        // Badly-scaled: rescale and retry
        let scale = max(real.magnitude, imaginary.magnitude)
        return self.scalar.divide(by: scale).normalized
    }
}
