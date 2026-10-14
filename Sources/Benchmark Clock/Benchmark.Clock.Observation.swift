public import Benchmark
public import Formatter

extension Benchmark.Clock {
    public struct Observation: Sendable, Hashable {
        public let raw: Duration
        public let adjusted: Duration
        public let calibration: Calibration
        public let condition: Condition

        public init(
            raw: Duration,
            calibration: Calibration,
            condition: Condition
        ) {
            self.raw = raw
            self.adjusted = calibration.adjust(raw)
            self.calibration = calibration
            self.condition = condition
        }
    }
}

extension Benchmark.Clock.Observation {
    public func formatted(
        _ format: Formatter::Formatter.Duration<Formatter::Formatter.Number>
    ) -> String {
        adjusted.formatted(format)
    }
}
