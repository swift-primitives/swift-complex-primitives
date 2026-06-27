// MARK: - BinaryFloatingPoint

extension Complex.Real where Scalar: BinaryFloatingPoint {
    /// Returns the sum of two real numbers.
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(lhs._value + rhs._value)
    }

    /// Returns the difference of two real numbers.
    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(lhs._value - rhs._value)
    }

    /// Returns the product of two real numbers.
    @inlinable
    public static func * (lhs: Self, rhs: Self) -> Self {
        Self(lhs._value * rhs._value)
    }

    /// Returns the quotient of two real numbers.
    @inlinable
    public static func / (lhs: Self, rhs: Self) -> Self {
        Self(lhs._value / rhs._value)
    }

    /// Returns the additive inverse of a real number.
    @inlinable
    public static prefix func - (x: Self) -> Self {
        Self(-x._value)
    }

    /// Adds a real number into this value in place.
    @inlinable
    public static func += (lhs: inout Self, rhs: Self) {
        lhs._value += rhs._value
    }

    /// Subtracts a real number from this value in place.
    @inlinable
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs._value -= rhs._value
    }

    /// Multiplies this value by a real number in place.
    @inlinable
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs._value *= rhs._value
    }

    /// Divides this value by a real number in place.
    @inlinable
    public static func /= (lhs: inout Self, rhs: Self) {
        lhs._value /= rhs._value
    }
}
