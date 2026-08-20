// This source file is part of the swift-benchmark-clock open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-benchmark-clock project authors
// Licensed under Apache License v2.0

public import Benchmark
import Clock_Primitives

extension Benchmark.Clock {
    /// Measures empty-read overhead without executing a benchmark workload.
    public static func calibrate<C: _Concurrency.Clock & Sendable>(
        _ clock: C
    ) -> Calibration
    where C.Duration == Duration, C.Instant: Sendable {
        var observations: [Duration] = []
        observations.reserveCapacity(32)
        for _ in 0..<32 {
            let start = clock.now
            observations.append(start.duration(to: clock.now))
        }
        let positive = observations.filter { $0 > .zero }
        let observed = positive.min()
        let overhead = observations.sorted()[observations.count / 2]
        return .init(
            resolution: .init(declared: clock.minimumResolution, observed: observed),
            overhead: overhead
        )
    }
}
