// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-primitives open source project
//
// Copyright (c) 2024-2025 Coen ten Thije Boonkkamp and the swift-primitives
// project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

@_exported import Dimension_Primitives
@_exported import Numeric_Relaxed_Primitives
// Real_Primitives provides Numeric.Math, Numeric.Augmented, and Numeric.Fraction.
// Numeric_Relaxed_Primitives provides Numeric.Relaxed (carved out so that
// `public import _Shims` no longer leaks through Real_Primitives' interface).
// We provide Complex.Real<Scalar>, Complex.Imaginary<Scalar>, and Complex.Number<Scalar> structs.
@_exported import Real_Primitives
