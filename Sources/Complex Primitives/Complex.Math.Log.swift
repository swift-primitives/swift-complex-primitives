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

// MARK: - Log Accessor

extension Complex.Number.Math {
    /// Accessor for logarithm function variants.
    public struct Log {
        @usableFromInline
        let complex: Complex.Number<Scalar>

        @usableFromInline
        internal init(_ complex: Complex.Number<Scalar>) {
            self.complex = complex
        }
    }
}

extension Complex.Number.Math.Log: Sendable where Scalar: Sendable {}

extension Complex.Number.Math {
    /// Access logarithm function and variants.
    ///
    /// ```swift
    /// z.math.log()              // ln(z)
    /// z.math.log.one.plus()     // ln(1 + z)
    /// ```
    @inlinable
    public var log: Log {
        Log(complex)
    }
}

// MARK: - One Accessor

extension Complex.Number.Math.Log {
    /// Accessor for log(1 + z) variants.
    public struct One {
        @usableFromInline
        let complex: Complex.Number<Scalar>

        @usableFromInline
        internal init(_ complex: Complex.Number<Scalar>) {
            self.complex = complex
        }
    }
}

extension Complex.Number.Math.Log.One: Sendable where Scalar: Sendable {}

extension Complex.Number.Math.Log {
    /// Access log(1 + x) variants.
    @inlinable
    public var one: One {
        One(complex)
    }
}

// MARK: - BinaryFloatingPoint & Numeric.Transcendental

extension Complex.Number.Math.Log where Scalar: BinaryFloatingPoint & Numeric.Transcendental {
    /// The complex natural logarithm.
    ///
    /// The principal value is returned with imaginary part in (-π, π].
    /// Uses augmented arithmetic for accuracy near |z| = 1.
    @inlinable
    public func callAsFunction() -> Complex.Number<Scalar> {
        let z = complex

        // Non-finite or zero: return infinity (phase undefined)
        guard z.isFinite && !z.isZero else { return .infinity }

        let x = z.real._value
        let y = z.imaginary._value

        // Phase is always accurate via atan2
        let phase = Scalar._atan2(y, x)

        // For the real part (log|z|), we need care near |z| = 1
        let u = max(abs(x), abs(y))
        let v = min(abs(x), abs(y))

        // If u >= 1 or u² + v² >= u (no cancellation), use direct formula
        let r = v / u
        if u >= 1 || u >= u * u + v * v {
            return Complex.Number(
                Scalar._log(u) + Scalar._log1p(r * r) / 2,
                phase
            )
        }

        // Near |z| = 1: use augmented arithmetic for accuracy
        // We compute log(1 + (u² + v² - 1)) / 2
        let (a, b) = Numeric.Augmented.product(u, u)
        let (c, d) = Numeric.Augmented.product(v, v)
        var (s, e) = Numeric.Augmented.sum(large: Scalar(-1), small: a)
        s = (s + c) + e + b + d

        return Complex.Number(
            Scalar._log1p(s) / 2,
            phase
        )
    }
}

extension Complex.Number.Math.Log.One where Scalar: BinaryFloatingPoint & Numeric.Transcendental {
    /// ln(1 + z), computed accurately for small z.
    ///
    /// Uses augmented arithmetic to avoid cancellation when z is small.
    @inlinable
    public func plus() -> Complex.Number<Scalar> {
        let z = complex

        let x = z.real._value
        let y = z.imaginary._value

        // If |x| or |y| is large, just use log(1 + z) directly
        guard 2 * abs(x) < 1 && abs(y) < 1 else {
            let one = Complex.Number<Scalar>.one
            return (one + z).math.log()
        }

        // Phase of (1 + z)
        let onePlusX = 1 + x
        let phase = Scalar._atan2(y, onePlusX)

        // Real part uses: Re(log(1+z)) = log(1 + 2x + x² + y²) / 2
        //                              = log(1 + (2+x)x + y²) / 2
        // Computed with augmented arithmetic for accuracy
        let xp2 = Numeric.Augmented.sum(large: Scalar(2), small: x)
        let a = Numeric.Augmented.product(x, xp2.head)
        let y2 = Numeric.Augmented.product(y, y)
        let s = (a.head + y2.head + a.tail + y2.tail) + x * xp2.tail

        return Complex.Number(
            Scalar._log1p(s) / 2,
            phase
        )
    }
}
