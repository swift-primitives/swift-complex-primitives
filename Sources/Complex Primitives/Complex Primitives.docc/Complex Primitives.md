# ``Complex_Primitives``

@Metadata {
    @DisplayName("Complex Primitives")
    @TitleHeading("Swift Primitives")
}

Typed complex numbers whose real and imaginary parts are distinct types, so algebraic rules such as `i² = -1` are enforced by the type system.

## Overview

`Complex.Number<Scalar>` represents a complex number `a + bi` built from a typed
``Complex/Real`` part and a typed ``Complex/Imaginary`` part. Because the two parts
are separate types, the mixed-type arithmetic returns the algebraically-correct
type — `Imaginary × Imaginary` yields a ``Complex/Real`` — and consumers stay in
the typed domain until they reach a computation boundary.

```swift
import Complex_Primitives

let z = 3.0.real + 4.0.i      // Complex.Number<Double>
let minusOne = 1.0.i * 1.0.i  // Complex.Real<Double>(-1)
let w = z.math.exp()          // e^z
```

## Topics

### Core Types

- ``Complex``

### Building Blocks

- ``Complex/Number``
- ``Complex/Real``
- ``Complex/Imaginary``
