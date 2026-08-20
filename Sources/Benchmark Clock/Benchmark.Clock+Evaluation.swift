// This source file is part of the swift-benchmark-clock open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-benchmark-clock project authors
// Licensed under Apache License v2.0

public import Benchmark

extension Benchmark.Clock {
    public static func maximum(
        _ duration: Duration
    ) -> Benchmark.Evaluation<Observation> {
        .init { current, _ in
            current.adjusted > duration ? .regressed : .unchanged
        }
    }

    public static func regression(
        tolerance: Duration = .zero
    ) -> Benchmark.Evaluation<Observation> {
        .init { current, baseline in
            let difference = current.adjusted - baseline.adjusted
            if difference > tolerance {
                return .regressed
            } else if difference < .zero - tolerance {
                return .improved
            } else {
                return .unchanged
            }
        }
    }
}
