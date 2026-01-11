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

extension Numeric.Complex.Math {
    /// Accessor for cosine function variants.
    public struct Cos {
        @usableFromInline
        let complex: Numeric.Complex<Scalar>

        @usableFromInline
        internal init(_ complex: Numeric.Complex<Scalar>) {
            self.complex = complex
        }
    }
}

extension Numeric.Complex.Math.Cos: Sendable where Scalar: Sendable {}

extension Numeric.Complex.Math {
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

extension Numeric.Complex.Math.Cos {
    /// Accessor for cos(z) - k variants.
    public struct Minus {
        @usableFromInline
        let complex: Numeric.Complex<Scalar>

        @usableFromInline
        internal init(_ complex: Numeric.Complex<Scalar>) {
            self.complex = complex
        }
    }
}

extension Numeric.Complex.Math.Cos.Minus: Sendable where Scalar: Sendable {}

extension Numeric.Complex.Math.Cos {
    /// Access shifted cosine variants.
    @inlinable
    public var minus: Minus {
        Minus(complex)
    }
}

// MARK: - Double

extension Numeric.Complex.Math.Cos where Scalar == Double {
    /// The complex cosine.
    ///
    /// Computed as `cos(z) = cosh(iz)`.
    @inlinable
    public func callAsFunction() -> Numeric.Complex<Scalar> {
        // cos(z) = cosh(iz)
        // iz = i(x + iy) = -y + ix
        let iz = Numeric.Complex(-complex.imaginary._value, complex.real._value)
        return iz.math.cosh()
    }
}

extension Numeric.Complex.Math.Cos.Minus where Scalar == Double {
    /// cos(z) - 1, computed accurately for small z.
    ///
    /// Uses the identity: cos(z) - 1 = -2 sin²(z/2)
    @inlinable
    public func one() -> Numeric.Complex<Scalar> {
        let halfZ = complex.scalar.divide(by: Numeric.Real(2))
        let sinHalf = halfZ.math.sin()
        return (sinHalf * sinHalf).scalar.multiply(by: Numeric.Real(-2))
    }
}

extension Numeric.Complex.Math where Scalar == Double {
    /// The complex sine.
    ///
    /// Computed as `sin(z) = -i sinh(iz)`.
    @inlinable
    public func sin() -> Numeric.Complex<Scalar> {
        // sin(z) = -i sinh(iz)
        // iz = -y + ix
        let iz = Numeric.Complex(-complex.imaginary._value, complex.real._value)
        let w = iz.math.sinh()
        // -i(a + bi) = -ia + b = b - ai
        return Numeric.Complex(w.imaginary._value, -w.real._value)
    }

    /// The complex tangent.
    ///
    /// Computed as `tan(z) = -i tanh(iz)`.
    @inlinable
    public func tan() -> Numeric.Complex<Scalar> {
        // tan(z) = -i tanh(iz)
        let iz = Numeric.Complex(-complex.imaginary._value, complex.real._value)
        let w = iz.math.tanh()
        // -i(a + bi) = b - ai
        return Numeric.Complex(w.imaginary._value, -w.real._value)
    }
}

// MARK: - Float

extension Numeric.Complex.Math.Cos where Scalar == Float {
    /// The complex cosine.
    @inlinable
    public func callAsFunction() -> Numeric.Complex<Scalar> {
        let iz = Numeric.Complex(-complex.imaginary._value, complex.real._value)
        return iz.math.cosh()
    }
}

extension Numeric.Complex.Math.Cos.Minus where Scalar == Float {
    /// cos(z) - 1, computed accurately for small z.
    @inlinable
    public func one() -> Numeric.Complex<Scalar> {
        let halfZ = complex.scalar.divide(by: Numeric.Real(2))
        let sinHalf = halfZ.math.sin()
        return (sinHalf * sinHalf).scalar.multiply(by: Numeric.Real(-2))
    }
}

extension Numeric.Complex.Math where Scalar == Float {
    /// The complex sine.
    @inlinable
    public func sin() -> Numeric.Complex<Scalar> {
        let iz = Numeric.Complex(-complex.imaginary._value, complex.real._value)
        let w = iz.math.sinh()
        return Numeric.Complex(w.imaginary._value, -w.real._value)
    }

    /// The complex tangent.
    @inlinable
    public func tan() -> Numeric.Complex<Scalar> {
        let iz = Numeric.Complex(-complex.imaginary._value, complex.real._value)
        let w = iz.math.tanh()
        return Numeric.Complex(w.imaginary._value, -w.real._value)
    }
}
