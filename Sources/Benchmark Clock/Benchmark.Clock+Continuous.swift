// This source file is part of the swift-benchmark-clock open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-benchmark-clock project authors
// Licensed under Apache License v2.0

public import Benchmark

extension Benchmark.Clock {
    /// A toolchain-provided monotonic continuous-clock probe.
    public static func continuous(
        calibration: Calibration? = nil,
        condition: Condition = .clean
    ) -> Benchmark.Probe<ContinuousClock.Instant, Observation, Never> {
        let clock = ContinuousClock()
        return probe(
            clock,
            calibration: calibration ?? calibrate(clock),
            condition: condition
        )
    }
}
