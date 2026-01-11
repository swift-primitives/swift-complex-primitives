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

extension Numeric.Complex: Hashable where Scalar: Hashable {
    @inlinable
    public func hash(into hasher: inout Hasher) {
        hasher.combine(real)
        hasher.combine(imaginary)
    }
}
