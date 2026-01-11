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

extension Numeric.Imaginary {
    /// Accessor for equality comparisons on imaginary numbers.
    ///
    /// ```swift
    /// let i = 1.0.i
    /// let j = (1.0 + 1e-10).i
    /// i.equals.approximate(j, tolerance: 1e-9.real)  // true
    /// ```
    public struct Equals {
        @usableFromInline
        let imaginary: Numeric.Imaginary<Scalar>

        @usableFromInline
        internal init(_ imaginary: Numeric.Imaginary<Scalar>) {
            self.imaginary = imaginary
        }
    }
}

extension Numeric.Imaginary.Equals: Sendable where Scalar: Sendable {}

// MARK: - Accessor

extension Numeric.Imaginary {
    /// Access equality comparisons.
    ///
    /// ```swift
    /// i.equals.approximate(j, tolerance: 1e-10.real)
    /// ```
    @inlinable
    public var equals: Equals {
        Equals(self)
    }
}

// MARK: - Double

extension Numeric.Imaginary.Equals where Scalar == Double {
    /// Tests if two imaginary numbers are approximately equal within tolerance.
    ///
    /// Returns `true` if `|i - j| <= tolerance`.
    ///
    /// - Parameters:
    ///   - other: The imaginary number to compare against.
    ///   - tolerance: Maximum allowed absolute difference (a real value).
    /// - Returns: `true` if the difference is within tolerance.
    @inlinable
    public func approximate(_ other: Numeric.Imaginary<Scalar>, tolerance: Numeric.Real<Scalar>) -> Bool {
        abs(imaginary._value - other._value) <= tolerance._value
    }

    /// Tests if two imaginary numbers are approximately equal using combined tolerance.
    ///
    /// Returns `true` if `|i - j| <= absolute + relative * max(|i|, |j|)`.
    ///
    /// - Parameters:
    ///   - other: The imaginary number to compare against.
    ///   - absolute: Absolute tolerance component (a real value).
    ///   - relative: Relative tolerance component (default 0).
    /// - Returns: `true` if values are within combined tolerance.
    @inlinable
    public func approximate(
        _ other: Numeric.Imaginary<Scalar>,
        absolute: Numeric.Real<Scalar>,
        relative: Numeric.Real<Scalar> = .zero
    ) -> Bool {
        let diff = abs(imaginary._value - other._value)
        let scale = max(abs(imaginary._value), abs(other._value))
        return diff <= absolute._value + relative._value * scale
    }
}

// MARK: - Float

extension Numeric.Imaginary.Equals where Scalar == Float {
    /// Tests if two imaginary numbers are approximately equal within tolerance.
    @inlinable
    public func approximate(_ other: Numeric.Imaginary<Scalar>, tolerance: Numeric.Real<Scalar>) -> Bool {
        abs(imaginary._value - other._value) <= tolerance._value
    }

    /// Tests if two imaginary numbers are approximately equal using combined tolerance.
    @inlinable
    public func approximate(
        _ other: Numeric.Imaginary<Scalar>,
        absolute: Numeric.Real<Scalar>,
        relative: Numeric.Real<Scalar> = .zero
    ) -> Bool {
        let diff = abs(imaginary._value - other._value)
        let scale = max(abs(imaginary._value), abs(other._value))
        return diff <= absolute._value + relative._value * scale
    }
}
