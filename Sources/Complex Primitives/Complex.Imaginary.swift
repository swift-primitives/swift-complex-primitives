extension Complex {
    /// An imaginary number wrapper that provides type-safe algebra.
    ///
    /// `Imaginary<Scalar>` represents a pure imaginary number (a coefficient of i).
    /// It participates in typed arithmetic where algebraic rules are encoded in
    /// the type system:
    ///
    /// - `Imaginary * Imaginary -> Real` (since i² = -1)
    /// - `Imaginary / Imaginary -> Real`
    /// - `Real + Imaginary -> Complex.Number`
    /// - `Real * Imaginary -> Imaginary`
    ///
    /// ## Usage
    ///
    /// ```swift
    /// let i: Complex.Imaginary<Double> = 4.0.i
    /// let product = i * i  // Complex.Real<Double> with value -16.0
    /// let z = 3.0.real + i // Complex.Number<Double>
    /// ```
    public struct Imaginary<Scalar>: Sendable where Scalar: Sendable {
        @usableFromInline
        internal var _value: Scalar

        /// The coefficient of i (the imaginary unit).
        ///
        /// Access this only at computation boundaries (interop with external APIs).
        /// Prefer staying in the typed domain using `Imaginary` operations.
        @inlinable
        public var value: Scalar {
            @inline(always) get { _value }
            @inline(always) set { _value = newValue }
        }

        /// Creates an imaginary number from a scalar coefficient.
        ///
        /// The value represents the coefficient of i, so `Imaginary(3)` represents 3i.
        @inlinable
        public init(_ value: Scalar) {
            self._value = value
        }
    }
}

// MARK: - Conditional Conformances

extension Complex.Imaginary: Equatable where Scalar: Equatable {}
extension Complex.Imaginary: Hashable where Scalar: Hashable {}

// MARK: - Literal Conformances

extension Complex.Imaginary: ExpressibleByIntegerLiteral where Scalar: ExpressibleByIntegerLiteral {
    /// Creates an imaginary number from an integer literal coefficient.
    @inlinable
    public init(integerLiteral value: Scalar.IntegerLiteralType) {
        self.init(Scalar(integerLiteral: value))
    }
}

extension Complex.Imaginary: ExpressibleByFloatLiteral where Scalar: ExpressibleByFloatLiteral {
    /// Creates an imaginary number from a floating-point literal coefficient.
    @inlinable
    public init(floatLiteral value: Scalar.FloatLiteralType) {
        self.init(Scalar(floatLiteral: value))
    }
}

// MARK: - Static Properties

extension Complex.Imaginary where Scalar: BinaryFloatingPoint {
    /// The imaginary unit i.
    @inlinable
    public static var i: Self { Self(1) }

    /// The additive identity (zero imaginary).
    @inlinable
    public static var zero: Self { Self(0) }
}

// MARK: - Floating Point Properties (BinaryFloatingPoint)

extension Complex.Imaginary where Scalar: BinaryFloatingPoint {
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

    /// The sign of the coefficient.
    @inlinable
    public var sign: FloatingPointSign { _value.sign }

    /// The absolute value (magnitude) as a Real.
    @inlinable
    public var abs: Complex.Real<Scalar> { Complex.Real(Swift.abs(_value)) }
}

// MARK: - CustomStringConvertible

extension Complex.Imaginary: CustomStringConvertible where Scalar: CustomStringConvertible {
    /// A textual representation of this imaginary number.
    @inlinable
    public var description: String { "\(_value.description)i" }
}

extension Complex.Imaginary: CustomDebugStringConvertible where Scalar: CustomDebugStringConvertible {
    /// A textual representation of this imaginary number suitable for debugging.
    @inlinable
    public var debugDescription: String { "Imaginary(\(String(reflecting: _value)))" }
}
