// MARK: - Double

/// Returns the complex number formed from a real and an imaginary part.
@inlinable
public func + (lhs: Complex.Real<Double>, rhs: Complex.Imaginary<Double>) -> Complex.Number<Double> {
    Complex.Number(real: lhs, imaginary: rhs)
}

/// Returns the complex number formed from an imaginary and a real part.
@inlinable
public func + (lhs: Complex.Imaginary<Double>, rhs: Complex.Real<Double>) -> Complex.Number<Double> {
    Complex.Number(real: rhs, imaginary: lhs)
}

/// Returns the complex number with the given real part and negated imaginary part.
@inlinable
public func - (lhs: Complex.Real<Double>, rhs: Complex.Imaginary<Double>) -> Complex.Number<Double> {
    Complex.Number(real: lhs, imaginary: -rhs)
}

/// Returns the complex number with negated real part and the given imaginary part.
@inlinable
public func - (lhs: Complex.Imaginary<Double>, rhs: Complex.Real<Double>) -> Complex.Number<Double> {
    Complex.Number(real: -rhs, imaginary: lhs)
}

/// Returns an imaginary number scaled by a real factor.
@inlinable
public func * (lhs: Complex.Real<Double>, rhs: Complex.Imaginary<Double>) -> Complex.Imaginary<Double> {
    Complex.Imaginary(lhs._value * rhs._value)
}

/// Returns an imaginary number scaled by a real factor.
@inlinable
public func * (lhs: Complex.Imaginary<Double>, rhs: Complex.Real<Double>) -> Complex.Imaginary<Double> {
    Complex.Imaginary(lhs._value * rhs._value)
}

/// Returns the imaginary quotient of a real number divided by an imaginary number.
///
/// `a / (bi) = (-a / b)i`.
@inlinable
public func / (lhs: Complex.Real<Double>, rhs: Complex.Imaginary<Double>) -> Complex.Imaginary<Double> {
    Complex.Imaginary(-lhs._value / rhs._value)
}

/// Returns an imaginary number divided by a real factor.
@inlinable
public func / (lhs: Complex.Imaginary<Double>, rhs: Complex.Real<Double>) -> Complex.Imaginary<Double> {
    Complex.Imaginary(lhs._value / rhs._value)
}

// MARK: - Float

/// Returns the complex number formed from a real and an imaginary part.
@inlinable
public func + (lhs: Complex.Real<Float>, rhs: Complex.Imaginary<Float>) -> Complex.Number<Float> {
    Complex.Number(real: lhs, imaginary: rhs)
}

/// Returns the complex number formed from an imaginary and a real part.
@inlinable
public func + (lhs: Complex.Imaginary<Float>, rhs: Complex.Real<Float>) -> Complex.Number<Float> {
    Complex.Number(real: rhs, imaginary: lhs)
}

/// Returns the complex number with the given real part and negated imaginary part.
@inlinable
public func - (lhs: Complex.Real<Float>, rhs: Complex.Imaginary<Float>) -> Complex.Number<Float> {
    Complex.Number(real: lhs, imaginary: -rhs)
}

/// Returns the complex number with negated real part and the given imaginary part.
@inlinable
public func - (lhs: Complex.Imaginary<Float>, rhs: Complex.Real<Float>) -> Complex.Number<Float> {
    Complex.Number(real: -rhs, imaginary: lhs)
}

/// Returns an imaginary number scaled by a real factor.
@inlinable
public func * (lhs: Complex.Real<Float>, rhs: Complex.Imaginary<Float>) -> Complex.Imaginary<Float> {
    Complex.Imaginary(lhs._value * rhs._value)
}

/// Returns an imaginary number scaled by a real factor.
@inlinable
public func * (lhs: Complex.Imaginary<Float>, rhs: Complex.Real<Float>) -> Complex.Imaginary<Float> {
    Complex.Imaginary(lhs._value * rhs._value)
}

/// Returns the imaginary quotient of a real number divided by an imaginary number.
///
/// `a / (bi) = (-a / b)i`.
@inlinable
public func / (lhs: Complex.Real<Float>, rhs: Complex.Imaginary<Float>) -> Complex.Imaginary<Float> {
    Complex.Imaginary(-lhs._value / rhs._value)
}

/// Returns an imaginary number divided by a real factor.
@inlinable
public func / (lhs: Complex.Imaginary<Float>, rhs: Complex.Real<Float>) -> Complex.Imaginary<Float> {
    Complex.Imaginary(lhs._value / rhs._value)
}
