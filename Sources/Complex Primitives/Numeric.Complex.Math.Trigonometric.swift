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

// MARK: - Cos Primary Operation

extension Numeric.Complex.Math.Cos {
    /// The complex cosine.
    ///
    /// Computed as `cos(z) = cosh(iz)`.
    @inlinable
    public func callAsFunction() -> Numeric.Complex<Scalar> {
        // cos(z) = cosh(iz)
        // iz = i(x + iy) = -y + ix
        let iz = Numeric.Complex(-complex.imaginary, complex.real)
        return iz.math.cosh()
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

extension Numeric.Complex.Math.Cos.Minus {
    /// cos(z) - 1, computed accurately for small z.
    ///
    /// Uses the identity: cos(z) - 1 = -2 sin²(z/2)
    @inlinable
    public func one() -> Numeric.Complex<Scalar> {
        let halfZ = complex.scalar.divide(by: 2)
        let sinHalf = halfZ.math.sin()
        return (sinHalf * sinHalf).scalar.multiply(by: -2)
    }
}

// MARK: - Sin

extension Numeric.Complex.Math {
    /// The complex sine.
    ///
    /// Computed as `sin(z) = -i sinh(iz)`.
    @inlinable
    public func sin() -> Numeric.Complex<Scalar> {
        // sin(z) = -i sinh(iz)
        // iz = -y + ix
        let iz = Numeric.Complex(-complex.imaginary, complex.real)
        let w = iz.math.sinh()
        // -i(a + bi) = -ia + b = b - ai
        return Numeric.Complex(w.imaginary, -w.real)
    }
}

// MARK: - Tan

extension Numeric.Complex.Math {
    /// The complex tangent.
    ///
    /// Computed as `tan(z) = -i tanh(iz)`.
    @inlinable
    public func tan() -> Numeric.Complex<Scalar> {
        // tan(z) = -i tanh(iz)
        let iz = Numeric.Complex(-complex.imaginary, complex.real)
        let w = iz.math.tanh()
        // -i(a + bi) = b - ai
        return Numeric.Complex(w.imaginary, -w.real)
    }
}
