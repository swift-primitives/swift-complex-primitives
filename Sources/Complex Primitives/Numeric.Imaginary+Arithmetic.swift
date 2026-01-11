// MARK: - Double

extension Numeric.Imaginary where Scalar == Double {
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(lhs._value + rhs._value)
    }

    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(lhs._value - rhs._value)
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
}

/// Imaginary × Imaginary → Real
///
/// Since i² = -1, we have (ai)(bi) = ab·i² = -ab
@inlinable
public func * (lhs: Numeric.Imaginary<Double>, rhs: Numeric.Imaginary<Double>) -> Numeric.Real<Double> {
    Numeric.Real(-lhs._value * rhs._value)
}

/// Imaginary ÷ Imaginary → Real
///
/// Since (ai)/(bi) = a/b (the i cancels)
@inlinable
public func / (lhs: Numeric.Imaginary<Double>, rhs: Numeric.Imaginary<Double>) -> Numeric.Real<Double> {
    Numeric.Real(lhs._value / rhs._value)
}

// MARK: - Float

extension Numeric.Imaginary where Scalar == Float {
    @inlinable
    public static func + (lhs: Self, rhs: Self) -> Self {
        Self(lhs._value + rhs._value)
    }

    @inlinable
    public static func - (lhs: Self, rhs: Self) -> Self {
        Self(lhs._value - rhs._value)
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
}

/// Imaginary × Imaginary → Real
@inlinable
public func * (lhs: Numeric.Imaginary<Float>, rhs: Numeric.Imaginary<Float>) -> Numeric.Real<Float> {
    Numeric.Real(-lhs._value * rhs._value)
}

/// Imaginary ÷ Imaginary → Real
@inlinable
public func / (lhs: Numeric.Imaginary<Float>, rhs: Numeric.Imaginary<Float>) -> Numeric.Real<Float> {
    Numeric.Real(lhs._value / rhs._value)
}

