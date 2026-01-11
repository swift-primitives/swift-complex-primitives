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

// MARK: - CustomStringConvertible

extension Numeric.Complex: CustomStringConvertible {
    /// A textual representation of this complex number.
    ///
    /// Finite values are displayed as `"(real, imaginary)"`.
    /// Non-finite values are displayed as `"inf"`.
    public var description: String {
        guard isFinite else { return "inf" }
        return "(\(real), \(imaginary))"
    }
}

// MARK: - CustomDebugStringConvertible

#if !hasFeature(Embedded)
extension Numeric.Complex: CustomDebugStringConvertible {
    /// A detailed textual representation for debugging.
    public var debugDescription: String {
        "Numeric.Complex<\(Scalar.self)>(\(String(reflecting: real)), \(String(reflecting: imaginary)))"
    }
}
#endif
