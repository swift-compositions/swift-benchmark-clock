// This source file is part of the swift-benchmark-clock open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-benchmark-clock project authors
// Licensed under Apache License v2.0

public import Benchmark

extension Benchmark.Clock {
    /// Whether the timing was collected alone or under perturbing instrumentation.
    public enum Condition: Sendable, Hashable {
        case clean
        case instrumented(reason: String)
    }
}
