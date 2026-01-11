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

extension Numeric.Complex.Math {
    /// Accessor for logarithm function variants.
    public struct Log {
        @usableFromInline
        let complex: Numeric.Complex<Scalar>

        @usableFromInline
        internal init(_ complex: Numeric.Complex<Scalar>) {
            self.complex = complex
        }
    }
}

extension Numeric.Complex.Math.Log: Sendable where Scalar: Sendable {}

extension Numeric.Complex.Math {
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

// MARK: - Primary Operation

extension Numeric.Complex.Math.Log {
    /// The complex natural logarithm.
    ///
    /// The principal value is returned with imaginary part in (-π, π].
    /// Uses augmented arithmetic for accuracy near |z| = 1.
    @inlinable
    public func callAsFunction() -> Numeric.Complex<Scalar> {
        let z = complex

        // Non-finite or zero: return infinity (phase undefined)
        guard z.isFinite && !z.isZero else { return .infinity }

        // Phase is always accurate via atan2
        let phase = Scalar.math.atan2(z.imaginary, z.real)

        // For the real part (log|z|), we need care near |z| = 1
        let u = max(z.real.magnitude, z.imaginary.magnitude)
        let v = min(z.real.magnitude, z.imaginary.magnitude)

        // If u >= 1 or u² + v² >= u (no cancellation), use direct formula
        let r = v / u
        if u >= 1 || u >= u * u + v * v {
            return Numeric.Complex(
                Scalar.math.log(u) + Scalar.math.log.one.plus(r * r) / 2,
                phase
            )
        }

        // Near |z| = 1: use augmented arithmetic for accuracy
        // We compute log(1 + (u² + v² - 1)) / 2
        let (a, b) = Numeric.Augmented.product(u, u)
        let (c, d) = Numeric.Augmented.product(v, v)
        var (s, e) = Numeric.Augmented.sum(large: -1, small: a)
        s = (s + c) + e + b + d

        return Numeric.Complex(
            Scalar.math.log.one.plus(s) / 2,
            phase
        )
    }
}

// MARK: - One Accessor

extension Numeric.Complex.Math.Log {
    /// Accessor for log(1 + z) variants.
    public struct One {
        @usableFromInline
        let complex: Numeric.Complex<Scalar>

        @usableFromInline
        internal init(_ complex: Numeric.Complex<Scalar>) {
            self.complex = complex
        }
    }
}

extension Numeric.Complex.Math.Log.One: Sendable where Scalar: Sendable {}

extension Numeric.Complex.Math.Log {
    /// Access log(1 + x) variants.
    @inlinable
    public var one: One {
        One(complex)
    }
}

// MARK: - Log One Plus

extension Numeric.Complex.Math.Log.One {
    /// ln(1 + z), computed accurately for small z.
    ///
    /// Uses augmented arithmetic to avoid cancellation when z is small.
    @inlinable
    public func plus() -> Numeric.Complex<Scalar> {
        let z = complex

        // If |x| or |y| is large, just use log(1 + z) directly
        guard 2 * z.real.magnitude < 1 && z.imaginary.magnitude < 1 else {
            let one = Numeric.Complex<Scalar>.one
            return (one + z).math.log()
        }

        // Phase of (1 + z)
        let onePlusZ = Numeric.Complex<Scalar>.one + z
        let phase = Scalar.math.atan2(onePlusZ.imaginary, onePlusZ.real)

        // Real part uses: Re(log(1+z)) = log(1 + 2x + x² + y²) / 2
        //                              = log(1 + (2+x)x + y²) / 2
        // Computed with augmented arithmetic for accuracy
        let xp2 = Numeric.Augmented.sum(large: 2, small: z.real)
        let a = Numeric.Augmented.product(z.real, xp2.head)
        let y2 = Numeric.Augmented.product(z.imaginary, z.imaginary)
        let s = (a.head + y2.head + a.tail + y2.tail) + z.real * xp2.tail

        return Numeric.Complex(
            Scalar.math.log.one.plus(s) / 2,
            phase
        )
    }
}
