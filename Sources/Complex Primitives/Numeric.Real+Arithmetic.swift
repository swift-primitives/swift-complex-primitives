// MARK: - Double

extension Numeric.Real<Double> {
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(lhs._value + rhs._value)
    }

    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(lhs._value - rhs._value)
    }

    @inlinable
    public static func * (lhs: Self, rhs: Self) -> Self {
        Self(lhs._value * rhs._value)
    }

    @inlinable
    public static func / (lhs: Self, rhs: Self) -> Self {
        Self(lhs._value / rhs._value)
    }

    @inlinable
    public static prefix func - (x: Self) -> Self {
        Self(-x._value)
    }

    @inlinable
    public static func += (lhs: inout Self, rhs: Self) {
        lhs._value += rhs._value
    }

    @inlinable
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs._value -= rhs._value
    }

    @inlinable
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs._value *= rhs._value
    }

    @inlinable
    public static func /= (lhs: inout Self, rhs: Self) {
        lhs._value /= rhs._value
    }
}

// MARK: - Float

extension Numeric.Real<Float> {
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(lhs._value + rhs._value)
    }

    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(lhs._value - rhs._value)
    }

    @inlinable
    public static func * (lhs: Self, rhs: Self) -> Self {
        Self(lhs._value * rhs._value)
    }

    @inlinable
    public static func / (lhs: Self, rhs: Self) -> Self {
        Self(lhs._value / rhs._value)
    }

    @inlinable
    public static prefix func - (x: Self) -> Self {
        Self(-x._value)
    }

    @inlinable
    public static func += (lhs: inout Self, rhs: Self) {
        lhs._value += rhs._value
    }

    @inlinable
    public static func -= (lhs: inout Self, rhs: Self) {
        lhs._value -= rhs._value
    }

    @inlinable
    public static func *= (lhs: inout Self, rhs: Self) {
        lhs._value *= rhs._value
    }

    @inlinable
    public static func /= (lhs: inout Self, rhs: Self) {
        lhs._value /= rhs._value
    }
}
