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

extension Complex.Number {
    /// Accessor for real scalar operations on complex numbers.
    ///
    /// ```swift
    /// let z = Complex.Number(3.0, 4.0)
    /// let scaled = z.scalar.multiply(by: 2.0.real)  // 6 + 8i
    /// let halved = z.scalar.divide(by: 2.0.real)    // 1.5 + 2i
    /// ```
    public struct Operation {
        @usableFromInline
        let complex: Complex.Number<Scalar>

        @usableFromInline
        internal init(_ complex: Complex.Number<Scalar>) {
            self.complex = complex
        }
    }
}

extension Complex.Number.Operation: Sendable where Scalar: Sendable {}

// MARK: - Accessor

extension Complex.Number {
    /// Access real scalar operations.
    ///
    /// Operations with real scalars are more efficient than full complex operations.
    @inlinable
    public var scalar: Operation {
        Operation(self)
    }
}

// MARK: - BinaryFloatingPoint

extension Complex.Number.Operation where Scalar: BinaryFloatingPoint {
    /// Returns this complex number multiplied by a real scalar.
    ///
    /// More efficient than complex multiplication when the multiplier is real.
    @inlinable
    public func multiply(by value: Complex.Real<Scalar>) -> Complex.Number<Scalar> {
        Complex.Number(
            real: complex.real * value,
            imaginary: Complex.Imaginary(complex.imaginary._value * value._value)
        )
    }

    /// Returns this complex number divided by a real scalar.
    ///
    /// More efficient than complex division when the divisor is real.
    @inlinable
    public func divide(by value: Complex.Real<Scalar>) -> Complex.Number<Scalar> {
        Complex.Number(
            real: complex.real / value,
            imaginary: Complex.Imaginary(complex.imaginary._value / value._value)
        )
    }
}
