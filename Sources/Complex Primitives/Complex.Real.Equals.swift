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

// MARK: - Equals Accessor

extension Complex.Real {
    /// Accessor for equality comparisons on real numbers.
    ///
    /// ```swift
    /// let r = 1.0.real
    /// let s = (1.0 + 1e-10).real
    /// r.equals.approximate(s, tolerance: 1e-9.real)  // true
    /// ```
    public struct Equals {
        @usableFromInline
        let real: Complex.Real<Scalar>

        @usableFromInline
        internal init(_ real: Complex.Real<Scalar>) {
            self.real = real
        }
    }
}

extension Complex.Real.Equals: Sendable where Scalar: Sendable {}

// MARK: - Accessor

extension Complex.Real {
    /// Access equality comparisons.
    ///
    /// ```swift
    /// r.equals.approximate(s, tolerance: 1e-10.real)
    /// ```
    @inlinable
    public var equals: Equals {
        Equals(self)
    }
}

// MARK: - BinaryFloatingPoint

extension Complex.Real.Equals where Scalar: BinaryFloatingPoint {
    /// Tests if two real numbers are approximately equal within tolerance.
    ///
    /// Returns `true` if `|r - s| <= tolerance`.
    ///
    /// - Parameters:
    ///   - other: The real number to compare against.
    ///   - tolerance: Maximum allowed absolute difference.
    /// - Returns: `true` if the difference is within tolerance.
    @inlinable
    public func approximate(_ other: Complex.Real<Scalar>, tolerance: Complex.Real<Scalar>) -> Bool {
        abs(real._value - other._value) <= tolerance._value
    }

    /// Tests if two real numbers are approximately equal using combined tolerance.
    ///
    /// Returns `true` if `|r - s| <= absolute + relative * max(|r|, |s|)`.
    ///
    /// - Parameters:
    ///   - other: The real number to compare against.
    ///   - absolute: Absolute tolerance component.
    ///   - relative: Relative tolerance component (default 0).
    /// - Returns: `true` if values are within combined tolerance.
    @inlinable
    public func approximate(
        _ other: Complex.Real<Scalar>,
        absolute: Complex.Real<Scalar>,
        relative: Complex.Real<Scalar> = .zero
    ) -> Bool {
        let diff = abs(real._value - other._value)
        let scale = max(abs(real._value), abs(other._value))
        return diff <= absolute._value + relative._value * scale
    }
}
