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

/// Namespace for complex number types.
public enum Complex {}

extension Complex {
    /// A complex number with typed real and imaginary components.
    ///
    /// Complex numbers extend the real numbers with an imaginary unit `i`,
    /// where `i² = -1`. Every complex number can be written as `a + bi`
    /// where `a` is the real part and `b` is the imaginary part.
    ///
    /// This implementation uses typed wrappers (`Real<Scalar>` and `Imaginary<Scalar>`)
    /// to encode algebraic rules in the type system. The design philosophy is to
    /// stay in the typed domain as long as possible, only unwrapping to raw scalars
    /// at computation boundaries.
    ///
    /// ## Example
    ///
    /// ```swift
    /// // Using typed constructors
    /// let z = 3.0.real + 4.0.i     // Complex.Number<Double>
    /// let w = 1.0.real + 2.0.i     // Complex.Number<Double>
    ///
    /// // Type-safe algebra
    /// let i = 4.0.i
    /// let product = i * i           // Complex.Real<Double> with value -16.0 (i² = -1)
    ///
    /// // Traditional construction still works
    /// let z2 = Complex.Number(3.0, 4.0)
    ///
    /// z.polar.length                // Complex.Real<Double> (magnitude)
    /// z.polar.phase                 // Radian<Double> (argument)
    /// ```
    public struct Number<Scalar>: Sendable where Scalar: Sendable {
        /// The real component.
        public var real: Real<Scalar>

        /// The imaginary component.
        public var imaginary: Imaginary<Scalar>

        /// Creates a complex number from typed real and imaginary parts.
        @inlinable
        public init(real: Real<Scalar>, imaginary: Imaginary<Scalar>) {
            self.real = real
            self.imaginary = imaginary
        }

        /// Creates a complex number from scalar real and imaginary parts.
        ///
        /// This is a convenience initializer for API compatibility.
        /// Prefer using typed construction: `3.0.real + 4.0.i`
        @inlinable
        public init(_ real: Scalar, _ imaginary: Scalar) {
            self.real = Real(real)
            self.imaginary = Imaginary(imaginary)
        }
    }
}

// MARK: - Raw Value Access

extension Complex.Number {
    /// The raw scalar value of the real component.
    ///
    /// Use this only at computation boundaries (interop with external APIs).
    /// Prefer staying in the typed domain.
    @inlinable
    public var realValue: Scalar { real.value }

    /// The raw scalar value of the imaginary component.
    ///
    /// Use this only at computation boundaries (interop with external APIs).
    /// Prefer staying in the typed domain.
    @inlinable
    public var imaginaryValue: Scalar { imaginary.value }
}

// MARK: - Static Properties

extension Complex.Number where Scalar: BinaryFloatingPoint {
    /// The complex number zero (0 + 0i).
    @inlinable
    public static var zero: Self { Self(.zero, .zero) }

    /// The complex number one (1 + 0i).
    @inlinable
    public static var one: Self { Self(1, .zero) }

    /// The imaginary unit (0 + 1i).
    @inlinable
    public static var i: Self { Self(.zero, 1) }

    /// Creates a complex number with zero imaginary part.
    @inlinable
    public init(_ real: Scalar) {
        self.init(real, .zero)
    }
}

// MARK: - ExpressibleByIntegerLiteral

extension Complex.Number: ExpressibleByIntegerLiteral
where Scalar: ExpressibleByIntegerLiteral & BinaryFloatingPoint {
    /// Creates a complex number from an integer literal, with zero imaginary part.
    @inlinable
    public init(integerLiteral value: Scalar.IntegerLiteralType) {
        self.init(Scalar(integerLiteral: value), .zero)
    }
}

// MARK: - ExpressibleByFloatLiteral

extension Complex.Number: ExpressibleByFloatLiteral
where Scalar: ExpressibleByFloatLiteral & BinaryFloatingPoint {
    /// Creates a complex number from a floating-point literal, with zero imaginary part.
    @inlinable
    public init(floatLiteral value: Scalar.FloatLiteralType) {
        self.init(Scalar(floatLiteral: value), .zero)
    }
}

// MARK: - Codable

#if !hasFeature(Embedded)
    // swiftlint:disable typed_throws_required no_any_protocol_existential
    // reason: Encodable.encode(to:) and Decodable.init(from:) are Swift standard-library
    // protocol requirements with fixed signatures — the untyped `throws` and the
    // `any Encoder` / `any Decoder` existentials are mandated by the witnessed protocols
    // and cannot be narrowed to typed throws or concrete types.
    extension Complex.Number: Encodable where Scalar: Encodable {
        /// Encodes this complex number as an unkeyed container of its real and imaginary parts.
        public func encode(to encoder: any Encoder) throws {
            var container = encoder.unkeyedContainer()
            try container.encode(real.value)
            try container.encode(imaginary.value)
        }
    }

    extension Complex.Number: Decodable where Scalar: Decodable {
        /// Creates a complex number by decoding an unkeyed container of its real and imaginary parts.
        public init(from decoder: any Decoder) throws {
            var container = try decoder.unkeyedContainer()
            let real = try container.decode(Scalar.self)
            let imaginary = try container.decode(Scalar.self)
            self.init(real, imaginary)
        }
    }
// swiftlint:enable typed_throws_required no_any_protocol_existential
#endif
