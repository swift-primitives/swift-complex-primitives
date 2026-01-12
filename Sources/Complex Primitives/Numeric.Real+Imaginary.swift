// MARK: - Double

/// Real + Imaginary → Complex
@inlinable
public func + (lhs: Numeric.Real<Double>, rhs: Numeric.Imaginary<Double>) -> Numeric.Complex<Double> {
    Numeric.Complex(real: lhs, imaginary: rhs)
}

/// Imaginary + Real → Complex
@inlinable
public func + (lhs: Numeric.Imaginary<Double>, rhs: Numeric.Real<Double>) -> Numeric.Complex<Double> {
    Numeric.Complex(real: rhs, imaginary: lhs)
}

/// Real - Imaginary → Complex
@inlinable
public func - (lhs: Numeric.Real<Double>, rhs: Numeric.Imaginary<Double>) -> Numeric.Complex<Double> {
    Numeric.Complex(real: lhs, imaginary: -rhs)
}

/// Imaginary - Real → Complex
@inlinable
public func - (lhs: Numeric.Imaginary<Double>, rhs: Numeric.Real<Double>) -> Numeric.Complex<Double> {
    Numeric.Complex(real: -rhs, imaginary: lhs)
}

/// Real × Imaginary → Imaginary
@inlinable
public func * (lhs: Numeric.Real<Double>, rhs: Numeric.Imaginary<Double>) -> Numeric.Imaginary<Double> {
    Numeric.Imaginary(lhs._value * rhs._value)
}

/// Imaginary × Real → Imaginary
@inlinable
public func * (lhs: Numeric.Imaginary<Double>, rhs: Numeric.Real<Double>) -> Numeric.Imaginary<Double> {
    Numeric.Imaginary(lhs._value * rhs._value)
}

/// Real ÷ Imaginary → Imaginary
///
/// a / (bi) = a / (bi) × (-i)/(-i) = -ai / b = (-a/b)i
@inlinable
public func / (lhs: Numeric.Real<Double>, rhs: Numeric.Imaginary<Double>) -> Numeric.Imaginary<Double> {
    Numeric.Imaginary(-lhs._value / rhs._value)
}

/// Imaginary ÷ Real → Imaginary
@inlinable
public func / (lhs: Numeric.Imaginary<Double>, rhs: Numeric.Real<Double>) -> Numeric.Imaginary<Double> {
    Numeric.Imaginary(lhs._value / rhs._value)
}

// MARK: - Float

/// Real + Imaginary → Complex
@inlinable
public func + (lhs: Numeric.Real<Float>, rhs: Numeric.Imaginary<Float>) -> Numeric.Complex<Float> {
    Numeric.Complex(real: lhs, imaginary: rhs)
}

/// Imaginary + Real → Complex
@inlinable
public func + (lhs: Numeric.Imaginary<Float>, rhs: Numeric.Real<Float>) -> Numeric.Complex<Float> {
    Numeric.Complex(real: rhs, imaginary: lhs)
}

/// Real - Imaginary → Complex
@inlinable
public func - (lhs: Numeric.Real<Float>, rhs: Numeric.Imaginary<Float>) -> Numeric.Complex<Float> {
    Numeric.Complex(real: lhs, imaginary: -rhs)
}

/// Imaginary - Real → Complex
@inlinable
public func - (lhs: Numeric.Imaginary<Float>, rhs: Numeric.Real<Float>) -> Numeric.Complex<Float> {
    Numeric.Complex(real: -rhs, imaginary: lhs)
}

/// Real × Imaginary → Imaginary
@inlinable
public func * (lhs: Numeric.Real<Float>, rhs: Numeric.Imaginary<Float>) -> Numeric.Imaginary<Float> {
    Numeric.Imaginary(lhs._value * rhs._value)
}

/// Imaginary × Real → Imaginary
@inlinable
public func * (lhs: Numeric.Imaginary<Float>, rhs: Numeric.Real<Float>) -> Numeric.Imaginary<Float> {
    Numeric.Imaginary(lhs._value * rhs._value)
}

/// Real ÷ Imaginary → Imaginary
@inlinable
public func / (lhs: Numeric.Real<Float>, rhs: Numeric.Imaginary<Float>) -> Numeric.Imaginary<Float> {
    Numeric.Imaginary(-lhs._value / rhs._value)
}

/// Imaginary ÷ Real → Imaginary
@inlinable
public func / (lhs: Numeric.Imaginary<Float>, rhs: Numeric.Real<Float>) -> Numeric.Imaginary<Float> {
    Numeric.Imaginary(lhs._value / rhs._value)
}

