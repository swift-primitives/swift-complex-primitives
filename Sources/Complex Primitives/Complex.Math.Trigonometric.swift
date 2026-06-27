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

// MARK: - Cos Accessor

extension Complex.Number.Math {
    /// Accessor for cosine function variants.
    public struct Cos {
        @usableFromInline
        let complex: Complex.Number<Scalar>

        @usableFromInline
        internal init(_ complex: Complex.Number<Scalar>) {
            self.complex = complex
        }
    }
}

extension Complex.Number.Math.Cos: Sendable where Scalar: Sendable {}

extension Complex.Number.Math {
    /// Access cosine function and variants.
    ///
    /// ```swift
    /// z.math.cos()              // cos(z)
    /// z.math.cos.minus.one()    // cos(z) - 1
    /// ```
    @inlinable
    public var cos: Cos {
        Cos(complex)
    }
}

// MARK: - Cos Minus Accessor

extension Complex.Number.Math.Cos {
    /// Accessor for cos(z) - k variants.
    public struct Minus {
        @usableFromInline
        let complex: Complex.Number<Scalar>

        @usableFromInline
        internal init(_ complex: Complex.Number<Scalar>) {
            self.complex = complex
        }
    }
}

extension Complex.Number.Math.Cos.Minus: Sendable where Scalar: Sendable {}

extension Complex.Number.Math.Cos {
    /// Access shifted cosine variants.
    @inlinable
    public var minus: Minus {
        Minus(complex)
    }
}

// MARK: - BinaryFloatingPoint & Numeric.Transcendental

extension Complex.Number.Math.Cos where Scalar: BinaryFloatingPoint & Numeric.Transcendental {
    /// The complex cosine.
    ///
    /// Computed as `cos(z) = cosh(iz)`.
    @inlinable
    public func callAsFunction() -> Complex.Number<Scalar> {
        // cos(z) = cosh(iz)
        // iz = i(x + iy) = -y + ix
        let iz = Complex.Number(-complex.imaginary._value, complex.real._value)
        return iz.math.cosh()
    }
}

extension Complex.Number.Math.Cos.Minus where Scalar: BinaryFloatingPoint & Numeric.Transcendental {
    /// cos(z) - 1, computed accurately for small z.
    ///
    /// Uses the identity: cos(z) - 1 = -2 sin²(z/2)
    @inlinable
    public func one() -> Complex.Number<Scalar> {
        let halfZ = complex.scalar.divide(by: Complex.Real(Scalar(2)))
        let sinHalf = halfZ.math.sin()
        return (sinHalf * sinHalf).scalar.multiply(by: Complex.Real(Scalar(-2)))
    }
}

extension Complex.Number.Math where Scalar: BinaryFloatingPoint & Numeric.Transcendental {
    /// The complex sine.
    ///
    /// Computed as `sin(z) = -i sinh(iz)`.
    @inlinable
    public func sin() -> Complex.Number<Scalar> {
        // sin(z) = -i sinh(iz)
        // iz = -y + ix
        let iz = Complex.Number(-complex.imaginary._value, complex.real._value)
        let w = iz.math.sinh()
        // -i(a + bi) = -ia + b = b - ai
        return Complex.Number(w.imaginary._value, -w.real._value)
    }

    /// The complex tangent.
    ///
    /// Computed as `tan(z) = -i tanh(iz)`.
    @inlinable
    public func tan() -> Complex.Number<Scalar> {
        // tan(z) = -i tanh(iz)
        let iz = Complex.Number(-complex.imaginary._value, complex.real._value)
        let w = iz.math.tanh()
        // -i(a + bi) = b - ai
        return Complex.Number(w.imaginary._value, -w.real._value)
    }
}
