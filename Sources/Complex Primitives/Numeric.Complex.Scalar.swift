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

extension Numeric.Complex {
    /// Accessor for real scalar operations on complex numbers.
    ///
    /// ```swift
    /// let z = Numeric.Complex(3.0, 4.0)
    /// let scaled = z.scalar.multiply(by: 2.0.real)  // 6 + 8i
    /// let halved = z.scalar.divide(by: 2.0.real)    // 1.5 + 2i
    /// ```
    public struct Operation {
        @usableFromInline
        let complex: Numeric.Complex<Scalar>

        @usableFromInline
        internal init(_ complex: Numeric.Complex<Scalar>) {
            self.complex = complex
        }
    }
}

extension Numeric.Complex.Operation: Sendable where Scalar: Sendable {}

// MARK: - Accessor

extension Numeric.Complex {
    /// Access real scalar operations.
    ///
    /// Operations with real scalars are more efficient than full complex operations.
    @inlinable
    public var scalar: Operation {
        Operation(self)
    }
}

// MARK: - Double

extension Numeric.Complex.Operation where Scalar == Double {
    /// Returns this complex number multiplied by a real scalar.
    ///
    /// More efficient than complex multiplication when the multiplier is real.
    @inlinable
    public func multiply(by value: Numeric.Real<Scalar>) -> Numeric.Complex<Scalar> {
        Numeric.Complex(
            real: complex.real * value,
            imaginary: Numeric.Imaginary(complex.imaginary._value * value._value)
        )
    }

    /// Returns this complex number divided by a real scalar.
    ///
    /// More efficient than complex division when the divisor is real.
    @inlinable
    public func divide(by value: Numeric.Real<Scalar>) -> Numeric.Complex<Scalar> {
        Numeric.Complex(
            real: complex.real / value,
            imaginary: Numeric.Imaginary(complex.imaginary._value / value._value)
        )
    }
}

// MARK: - Float

extension Numeric.Complex.Operation where Scalar == Float {
    /// Returns this complex number multiplied by a real scalar.
    @inlinable
    public func multiply(by value: Numeric.Real<Scalar>) -> Numeric.Complex<Scalar> {
        Numeric.Complex(
            real: complex.real * value,
            imaginary: Numeric.Imaginary(complex.imaginary._value * value._value)
        )
    }

    /// Returns this complex number divided by a real scalar.
    @inlinable
    public func divide(by value: Numeric.Real<Scalar>) -> Numeric.Complex<Scalar> {
        Numeric.Complex(
            real: complex.real / value,
            imaginary: Numeric.Imaginary(complex.imaginary._value / value._value)
        )
    }
}
