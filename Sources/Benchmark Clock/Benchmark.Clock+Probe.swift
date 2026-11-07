public import Benchmark
import Clock

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
