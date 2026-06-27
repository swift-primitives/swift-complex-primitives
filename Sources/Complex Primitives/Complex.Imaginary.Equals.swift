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

extension Complex.Imaginary {
    /// Accessor for equality comparisons on imaginary numbers.
    ///
    /// ```swift
    /// let i = 1.0.i
    /// let j = (1.0 + 1e-10).i
    /// i.equals.approximate(j, tolerance: 1e-9.real)  // true
    /// ```
    public struct Equals {
        @usableFromInline
        let imaginary: Complex.Imaginary<Scalar>

        @usableFromInline
        internal init(_ imaginary: Complex.Imaginary<Scalar>) {
            self.imaginary = imaginary
        }
    }
}

extension Complex.Imaginary.Equals: Sendable where Scalar: Sendable {}

// MARK: - Accessor

extension Complex.Imaginary {
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

// MARK: - BinaryFloatingPoint

extension Complex.Imaginary.Equals where Scalar: BinaryFloatingPoint {
    /// Tests if two imaginary numbers are approximately equal within tolerance.
    ///
    /// Returns `true` if `|i - j| <= tolerance`.
    ///
    /// - Parameters:
    ///   - other: The imaginary number to compare against.
    ///   - tolerance: Maximum allowed absolute difference (a real value).
    /// - Returns: `true` if the difference is within tolerance.
    @inlinable
    public func approximate(_ other: Complex.Imaginary<Scalar>, tolerance: Complex.Real<Scalar>) -> Bool {
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
        _ other: Complex.Imaginary<Scalar>,
        absolute: Complex.Real<Scalar>,
        relative: Complex.Real<Scalar> = .zero
    ) -> Bool {
        let diff = abs(imaginary._value - other._value)
        let scale = max(abs(imaginary._value), abs(other._value))
        return diff <= absolute._value + relative._value * scale
    }
}
