// This source file is part of the swift-benchmark-clock open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-benchmark-clock project authors
// Licensed under Apache License v2.0

public import Benchmark
import Clock

extension Benchmark.Clock {
    /// Creates a duration probe from any sendable Swift clock.
    public static func probe<C: _Concurrency.Clock & Sendable>(
        _ clock: C,
        calibration: Calibration = .zero,
        condition: Condition = .clean
    ) -> Benchmark.Probe<C.Instant, Observation, Never>
    where C.Duration == Swift.Duration, C.Instant: Sendable {
        .init(
            start: { .success(clock.now) },
            stop: { start in
                .success(
                    Observation(
                        raw: start.duration(to: clock.now),
                        calibration: calibration,
                        condition: condition
                    )
                )
            }
        )
    }
}
