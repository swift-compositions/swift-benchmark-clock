public import Benchmark
import Clock

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
