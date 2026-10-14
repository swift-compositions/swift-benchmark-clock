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
