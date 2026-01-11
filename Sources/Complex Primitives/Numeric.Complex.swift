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

extension Numeric {
    /// A complex number with real and imaginary components.
    ///
    /// Complex numbers extend the real numbers with an imaginary unit `i`,
    /// where `i² = -1`. Every complex number can be written as `a + bi`
    /// where `a` is the real part and `b` is the imaginary part.
    ///
    /// ## Example
    ///
    /// ```swift
    /// let z = Numeric.Complex(3.0, 4.0)  // 3 + 4i
    /// let w = Numeric.Complex(1.0, 2.0)  // 1 + 2i
    ///
    /// let sum = z + w                     // 4 + 6i
    /// let product = z * w                 // -5 + 10i
    ///
    /// z.polar.length                      // 5.0 (magnitude)
    /// z.polar.phase                       // atan2(4, 3) (argument in radians)
    /// ```
    public struct Complex<Scalar> where Scalar: Numeric.Real {
        /// The real component.
        public var real: Scalar

        /// The imaginary component.
        public var imaginary: Scalar

        /// Creates a complex number from real and imaginary parts.
        @inlinable
        public init(_ real: Scalar, _ imaginary: Scalar) {
            self.real = real
            self.imaginary = imaginary
        }

        /// Creates a complex number with zero imaginary part.
        @inlinable
        public init(_ real: Scalar) {
            self.real = real
            self.imaginary = .zero
        }
    }
}

// MARK: - Static Properties

extension Numeric.Complex {
    /// The complex number zero (0 + 0i).
    @inlinable
    public static var zero: Self { Self(.zero, .zero) }

    /// The complex number one (1 + 0i).
    @inlinable
    public static var one: Self { Self(1, .zero) }

    /// The imaginary unit (0 + 1i).
    @inlinable
    public static var i: Self { Self(.zero, 1) }
}

// MARK: - ExpressibleByIntegerLiteral

extension Numeric.Complex: ExpressibleByIntegerLiteral
where Scalar: ExpressibleByIntegerLiteral {
    @inlinable
    public init(integerLiteral value: Scalar.IntegerLiteralType) {
        self.init(Scalar(integerLiteral: value), .zero)
    }
}

// MARK: - ExpressibleByFloatLiteral

extension Numeric.Complex: ExpressibleByFloatLiteral
where Scalar: ExpressibleByFloatLiteral {
    @inlinable
    public init(floatLiteral value: Scalar.FloatLiteralType) {
        self.init(Scalar(floatLiteral: value), .zero)
    }
}

// MARK: - Sendable

extension Numeric.Complex: Sendable where Scalar: Sendable {}

// MARK: - Codable

#if !hasFeature(Embedded)
extension Numeric.Complex: Encodable where Scalar: Encodable {
    public func encode(to encoder: any Encoder) throws {
        var container = encoder.unkeyedContainer()
        try container.encode(real)
        try container.encode(imaginary)
    }
}

extension Numeric.Complex: Decodable where Scalar: Decodable {
    public init(from decoder: any Decoder) throws {
        var container = try decoder.unkeyedContainer()
        let real = try container.decode(Scalar.self)
        let imaginary = try container.decode(Scalar.self)
        self.init(real, imaginary)
    }
}
#endif
