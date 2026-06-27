# Complex Primitives

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Typed complex numbers for Swift — real and imaginary parts are distinct types, so `i × i` collapses to a real at compile time, alongside elementary functions, polar form, and relaxed arithmetic.

---

## Quick Start

`Complex.Number<Scalar>` is a complex number `a + bi` built from a typed real part and a typed imaginary part. Because the two parts are separate types, the algebra is encoded in the type system — not just in the runtime value. `Imaginary × Imaginary` returns a `Real`, because `i² = -1`, and the compiler tracks that for you.

```swift
import Complex_Primitives

// Build complex numbers fluently; the type tracks real vs. imaginary parts.
let z = 3.0.real + 4.0.i          // Complex.Number<Double>

// Algebraic rules live in the types, not only the values:
let unit = 1.0.i
let minusOne = unit * unit        // Complex.Real<Double>(-1) — i² collapses to a Real

// Magnitude and polar form:
let r = z.magnitude()             // Complex.Real<Double>(5.0)
let theta = z.polar.phase         // Radian<Double>(atan2(4, 3))

// Elementary functions with Kahan-style branch cuts:
let e = z.math.exp()              // e^z
let root = z.math.sqrt()          // principal √z

// Tolerance-based comparison instead of fragile exact equality:
let almost = Complex.Number(1.0, 2.0)
almost.equals.approximate(z, tolerance: 1e-9.real)  // Bool
```

The mixed-type arithmetic (`Real + Imaginary → Complex`, `Real × Imaginary → Imaginary`, `Imaginary × Imaginary → Real`, …) is exhaustive, so expressions stay in the typed domain and only unwrap to raw scalars at computation boundaries.

---

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-primitives/swift-complex-primitives.git", branch: "main")
]
```

```swift
.target(
    name: "App",
    dependencies: [
        .product(name: "Complex Primitives", package: "swift-complex-primitives"),
    ]
)
```

Requires Swift 6.3.1 and macOS 26 / iOS 26 / tvOS 26 / watchOS 26 / visionOS 26 (or the matching Linux / Windows toolchain).

---

## Architecture

One library product, `Complex Primitives`, exposing the `Complex` namespace.

| Type / accessor | Purpose |
|-----------------|---------|
| `Complex.Number<Scalar>` | A complex number `a + bi` with a typed real and imaginary part. |
| `Complex.Real<Scalar>` | The real component; `Real × Real → Real`. |
| `Complex.Imaginary<Scalar>` | The imaginary component; `Imaginary × Imaginary → Real` (since `i² = -1`). |
| `Double.real` / `Double.i` (and `Float`) | Fluent constructors for the typed components. |
| `z.math` | Elementary functions: `exp`, `log`, `sqrt`, `pow`, trigonometric, hyperbolic, and their inverses. |
| `z.polar` | Polar form: modulus (`length`) and argument (`phase`, a `Radian`); plus `init(length:phase:)`. |
| `z.magnitude` | Euclidean norm (`hypot`-based) and its faster `squared` form. |
| `z.equals` | Norm-based and componentwise approximate equality with explicit tolerances. |
| `Numeric.Relaxed.sum` / `.product` / `.multiplyAdd` | Reassociation- and FMA-friendly arithmetic for `Double` and `Float`. |

The numeric core builds on `swift-numeric-primitives` (real scalars, transcendental functions, relaxed arithmetic) and `swift-dimension-primitives` (the `Radian` argument type). It imports no Foundation.

---

## Platform Support

| Platform | Status |
|----------|--------|
| macOS 26 | Full support |
| Linux | Full support |
| Windows | Full support |
| iOS / tvOS / watchOS / visionOS | Supported |
| Swift Embedded | Partial (arithmetic, magnitude, polar, and elementary math; `Codable` and `debugDescription` excluded) |

Under Embedded Swift the full numeric surface — construction, the typed mixed-type arithmetic, magnitude, polar form, and the elementary `math` functions — is available. The `Codable` conformances and the reflection-based `debugDescription` are guarded out, because Embedded has neither the `Codable` machinery nor runtime reflection.

---

## Community

<!-- BEGIN: discussion -->
<!-- Discussion thread created at publication. -->
<!-- END: discussion -->

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
