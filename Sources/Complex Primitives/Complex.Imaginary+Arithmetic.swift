// MARK: - BinaryFloatingPoint

extension Complex.Imaginary where Scalar: BinaryFloatingPoint {
    /// Returns the sum of two imaginary numbers.
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(lhs._value + rhs._value)
    }

    /// Returns the difference of two imaginary numbers.
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(lhs._value - rhs._value)
    }

    /// Returns the additive inverse of an imaginary number.
    @inlinable
    public static prefix func - (x: Self) -> Self {
        Self(-x._value)
    }

    /// Adds an imaginary number into this value in place.
    @inlinable
    public static func += (lhs: inout Self, rhs: Self) {
        lhs._value += rhs._value
    }

    /// Subtracts an imaginary number from this value in place.
    @inlinable
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs._value -= rhs._value
    }

    /// Returns the product of two imaginary numbers as a real number.
    ///
    /// Since i² = -1, multiplying `ai` by `bi` yields `-ab`.
    @inlinable
    public static func * (lhs: Self, rhs: Self) -> Complex.Real<Scalar> {
        Complex.Real(-lhs._value * rhs._value)
    }

    /// Returns the quotient of two imaginary numbers as a real number.
    ///
    /// The imaginary units cancel, so `(ai) / (bi)` yields `a / b`.
    @inlinable
    public static func / (lhs: Self, rhs: Self) -> Complex.Real<Scalar> {
        Complex.Real(lhs._value / rhs._value)
    }
}
