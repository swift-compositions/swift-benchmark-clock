public import Benchmark

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
