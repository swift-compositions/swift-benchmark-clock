public import Benchmark
import Clock

extension Benchmark {
    public enum Clock {}
}

extension Benchmark.Clock {
    public static func calibrate<C: _Concurrency.Clock & Sendable>(
        _ clock: C
    ) -> Calibration
    where C.Duration == Swift::Duration, C.Instant: Sendable {
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

extension Benchmark.Clock {
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

extension Benchmark.Clock {
    public static func probe<C: _Concurrency.Clock & Sendable>(
        _ clock: C,
        calibration: Calibration = .zero,
        condition: Condition = .clean
    ) -> Benchmark.Probe<C.Instant, Observation, Never>
    where C.Duration == Swift::Duration, C.Instant: Sendable {
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
