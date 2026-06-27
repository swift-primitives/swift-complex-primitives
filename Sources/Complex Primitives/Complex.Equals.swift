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

extension Complex.Number {
    /// Accessor for equality comparisons on complex numbers.
    ///
    /// ```swift
    /// let z = Complex.Number(1.0, 2.0)
    /// let w = Complex.Number(1.0 + 1e-10, 2.0)
    /// z.equals.approximate(w, tolerance: 1e-9.real)  // true
    /// ```
    public struct Equals {
        @usableFromInline
        let complex: Complex.Number<Scalar>

        @usableFromInline
        internal init(_ complex: Complex.Number<Scalar>) {
            self.complex = complex
        }
    }
}

extension Complex.Number.Equals: Sendable where Scalar: Sendable {}

// MARK: - Accessor

extension Complex.Number {
    /// Access equality comparisons.
    ///
    /// ```swift
    /// z.equals.approximate(w, tolerance: 1e-10.real)
    /// z.equals.approximate(w, absolute: 1e-10.real, relative: 1e-5.real)
    /// ```
    @inlinable
    public var equals: Equals {
        Equals(self)
    }
}

// MARK: - BinaryFloatingPoint & Numeric.Transcendental

extension Complex.Number.Equals where Scalar: BinaryFloatingPoint & Numeric.Transcendental {
    /// Tests if two complex numbers are approximately equal within tolerance.
    ///
    /// Uses the complex norm: returns `true` if `|z - w| <= tolerance`.
    ///
    /// - Parameters:
    ///   - other: The complex number to compare against.
    ///   - tolerance: Maximum allowed absolute difference in the norm.
    /// - Returns: `true` if the distance between values is within tolerance.
    @inlinable
    public func approximate(_ other: Complex.Number<Scalar>, tolerance: Complex.Real<Scalar>) -> Bool {
        (complex - other).magnitude() <= tolerance
    }

    /// Tests if two complex numbers are approximately equal using combined tolerance.
    ///
    /// Uses the complex norm: returns `true` if
    /// `|z - w| <= absolute + relative * max(|z|, |w|)`.
    ///
    /// - Parameters:
    ///   - other: The complex number to compare against.
    ///   - absolute: Absolute tolerance component.
    ///   - relative: Relative tolerance component (default 0).
    /// - Returns: `true` if values are within combined tolerance.
    @inlinable
    public func approximate(
        _ other: Complex.Number<Scalar>,
        absolute: Complex.Real<Scalar>,
        relative: Complex.Real<Scalar> = .zero
    ) -> Bool {
        let diff = (complex - other).magnitude()
        let scale = max(complex.magnitude(), other.magnitude())
        return diff <= absolute + relative * scale
    }
}

// MARK: - Componentwise Approximate Equality

extension Complex.Number.Equals {
    /// Accessor for componentwise comparison operations.
    public struct Componentwise {
        @usableFromInline
        let complex: Complex.Number<Scalar>

        @usableFromInline
        internal init(_ complex: Complex.Number<Scalar>) {
            self.complex = complex
        }
    }
}

extension Complex.Number.Equals.Componentwise: Sendable where Scalar: Sendable {}

extension Complex.Number.Equals {
    /// Access componentwise equality comparisons.
    ///
    /// ```swift
    /// z.equals.componentwise.approximate(w, tolerance: 1e-10.real)
    /// ```
    @inlinable
    public var componentwise: Componentwise {
        Componentwise(complex)
    }
}

// MARK: - Componentwise BinaryFloatingPoint

extension Complex.Number.Equals.Componentwise where Scalar: BinaryFloatingPoint {
    /// Tests if two complex numbers are approximately equal componentwise.
    ///
    /// Returns `true` if both `|Re(z) - Re(w)| <= tolerance` and
    /// `|Im(z) - Im(w)| <= tolerance`.
    ///
    /// - Parameters:
    ///   - other: The complex number to compare against.
    ///   - tolerance: Maximum allowed difference for each component.
    /// - Returns: `true` if both components are within tolerance.
    @inlinable
    public func approximate(_ other: Complex.Number<Scalar>, tolerance: Complex.Real<Scalar>) -> Bool {
        abs(complex.real._value - other.real._value) <= tolerance._value && abs(complex.imaginary._value - other.imaginary._value) <= tolerance._value
    }
}
