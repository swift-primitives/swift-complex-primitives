extension Numeric {
    /// A real number wrapper that provides type-safe algebra.
    ///
    /// `Real<Scalar>` wraps a scalar value and participates in typed arithmetic
    /// where algebraic rules are encoded in the type system. For example,
    /// `Imaginary * Imaginary` returns `Real` (since i² = -1).
    ///
    /// The design philosophy is to stay in the typed domain as long as possible,
    /// only unwrapping to raw scalars at computation boundaries (e.g., libm calls).
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let r: Numeric.Real<Double> = 3.0.real
    /// let i: Numeric.Imaginary<Double> = 4.0.i
    /// let product = i * i  // Numeric.Real<Double> with value -16.0
    /// let z = r + i        // Numeric.Complex<Double>
    /// ```
    public struct Real<Scalar>: Sendable where Scalar: Sendable {
        @usableFromInline
        internal var _value: Scalar

        /// The underlying scalar value.
        ///
        /// Access this only at computation boundaries (interop with external APIs).
        /// Prefer staying in the typed domain using `Real` operations.
        @inlinable
        public var value: Scalar {
            @inline(__always) get { _value }
            @inline(__always) set { _value = newValue }
        }

        /// Creates a real number from a scalar value.
        @inlinable
        public init(_ value: Scalar) {
            self._value = value
        }
    }
}

// MARK: - Conditional Conformances

extension Numeric.Real: Equatable where Scalar: Equatable {}
extension Numeric.Real: Hashable where Scalar: Hashable {}

extension Numeric.Real: Comparable where Scalar: Comparable {
    @inlinable
    public static func < (lhs: Self, rhs: Self) -> Bool {
        lhs.value < rhs.value
    }
}

// MARK: - Literal Conformances

extension Numeric.Real: ExpressibleByIntegerLiteral where Scalar: ExpressibleByIntegerLiteral {
    @inlinable
    public init(integerLiteral value: Scalar.IntegerLiteralType) {
        self.init(Scalar(integerLiteral: value))
    }
}

extension Numeric.Real: ExpressibleByFloatLiteral where Scalar: ExpressibleByFloatLiteral {
    @inlinable
    public init(floatLiteral value: Scalar.FloatLiteralType) {
        self.init(Scalar(floatLiteral: value))
    }
}

// MARK: - Static Properties

extension Numeric.Real where Scalar: BinaryFloatingPoint {
    /// The additive identity (zero).
    @inlinable
    public static var zero: Self { Self(0) }

    /// The multiplicative identity (one).
    @inlinable
    public static var one: Self { Self(1) }
}

// MARK: - Floating Point Properties (Double)

extension Numeric.Real where Scalar == Double {
    /// True if this value is finite (not infinity or NaN).
    @inlinable
    public var isFinite: Bool { _value.isFinite }

    /// True if this value is zero.
    @inlinable
    public var isZero: Bool { _value == 0 }

    /// True if this value is normal (not zero, subnormal, infinity, or NaN).
    @inlinable
    public var isNormal: Bool { _value.isNormal }

    /// True if this value is subnormal.
    @inlinable
    public var isSubnormal: Bool { _value.isSubnormal }

    /// True if this value is NaN.
    @inlinable
    public var isNaN: Bool { _value.isNaN }

    /// True if this value is infinite.
    @inlinable
    public var isInfinite: Bool { _value.isInfinite }

    /// The sign of this value.
    @inlinable
    public var sign: FloatingPointSign { _value.sign }

    /// The absolute value.
    @inlinable
    public var abs: Self { Self(Swift.abs(_value)) }
}

// MARK: - Floating Point Properties (Float)

extension Numeric.Real where Scalar == Float {
    /// True if this value is finite (not infinity or NaN).
    @inlinable
    public var isFinite: Bool { _value.isFinite }

    /// True if this value is zero.
    @inlinable
    public var isZero: Bool { _value == 0 }

    /// True if this value is normal (not zero, subnormal, infinity, or NaN).
    @inlinable
    public var isNormal: Bool { _value.isNormal }

    /// True if this value is subnormal.
    @inlinable
    public var isSubnormal: Bool { _value.isSubnormal }

    /// True if this value is NaN.
    @inlinable
    public var isNaN: Bool { _value.isNaN }

    /// True if this value is infinite.
    @inlinable
    public var isInfinite: Bool { _value.isInfinite }

    /// The sign of this value.
    @inlinable
    public var sign: FloatingPointSign { _value.sign }

    /// The absolute value.
    @inlinable
    public var abs: Self { Self(Swift.abs(_value)) }
}

// MARK: - CustomStringConvertible

extension Numeric.Real: CustomStringConvertible where Scalar: CustomStringConvertible {
    @inlinable
    public var description: String { _value.description }
}

extension Numeric.Real: CustomDebugStringConvertible where Scalar: CustomDebugStringConvertible {
    @inlinable
    public var debugDescription: String { "Real(\(String(reflecting: _value)))" }
}


// MARK: - Scalar Extensions

extension Double {
    /// Wraps this value as a typed real number.
    @inlinable
    public var real: Numeric.Real<Double> { .init(self) }

    /// Wraps this value as a typed imaginary number (coefficient of i).
    @inlinable
    public var i: Numeric.Imaginary<Double> { .init(self) }
}

extension Float {
    /// Wraps this value as a typed real number.
    @inlinable
    public var real: Numeric.Real<Float> { .init(self) }

    /// Wraps this value as a typed imaginary number (coefficient of i).
    @inlinable
    public var i: Numeric.Imaginary<Float> { .init(self) }
}

