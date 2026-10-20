// This source file is part of the swift-benchmark-clock open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-benchmark-clock project authors
// Licensed under Apache License v2.0

import Benchmark
import Benchmark_Clock
import Clock
import Clock_Concurrency
import Testing
import Formatter

@Suite
struct `Benchmark Clock Tests` {
    @Suite
    struct Unit {
        @Test
        func `fake clock observes exactly the explicit advancement`() throws {
            let clock = Clock::Clock.Test()
            let probe = Benchmark.Clock.probe(clock)
            let plan = try Benchmark.Plan(warmup: 0, measurements: 1)
            let workload = Benchmark.Workload<Void, Never>(
                setup: {},
                operation: { _ in clock.advance(by: .milliseconds(5)) },
                teardown: { _ in }
            )

            let receipt = try Benchmark.run(plan: plan, workload: workload, probe: probe)
            let observation = try #require(receipt.measurement.values.first)

            #expect(observation.raw == .milliseconds(5))
            #expect(observation.adjusted == .milliseconds(5))
            #expect(observation.condition == .clean)
        }
    }

    @Suite
    struct `Edge Case` {
        @Test
        func `calibration floor prevents negative adjusted durations`() {
            let clock = Clock::Clock.Test()
            clock.minimumResolution = .nanoseconds(5)
            let calibration = Benchmark.Clock.calibrate(clock)
            let observation = Benchmark.Clock.Observation(
                raw: .nanoseconds(3),
                calibration: calibration,
                condition: .instrumented(reason: "allocation tracking")
            )

            #expect(calibration.resolution.declared == .nanoseconds(5))
            #expect(calibration.resolution.observed == nil)
            #expect(calibration.floor == .nanoseconds(5))
            #expect(observation.adjusted == .zero)
            #expect(observation.formatted(
                Formatter::Formatter.Duration(numeric: Formatter::Formatter.Number())
            ) == "0 ns")
        }
    }

    @Suite
    struct Integration {
        @Test
        func `continuous probe and duration evaluation compose without Memory`() throws {
            let probe = Benchmark.Clock.continuous(calibration: .zero)
            let plan = try Benchmark.Plan(warmup: 0, measurements: 1)
            let workload = Benchmark.Workload<Int, Never>(
                setup: { 0 },
                operation: { value in
                    value += 1
                    Benchmark.consume(value)
                },
                teardown: { _ in }
            )

            let receipt = try Benchmark.run(plan: plan, workload: workload, probe: probe)
            let observation = try #require(receipt.measurement.values.first)
            let evaluation = Benchmark.Clock.maximum(.seconds(1))
            let baseline = Benchmark.Baseline(name: "limit", value: observation)

            #expect(observation.raw >= .zero)
            #expect(evaluation(current: observation, baseline: baseline) == .unchanged)
        }
    }
}
