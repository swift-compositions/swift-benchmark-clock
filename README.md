# swift-benchmark-clock

Use this package when you run benchmarks with swift-benchmark and want to measure wall time, with clock overhead taken out and a way to judge results against a time limit or a baseline. Start from `Benchmark.Clock.continuous(calibration:condition:)` for a ready probe, or `Benchmark.Clock.probe(_:calibration:condition:)` to time with a clock you pass in, such as a test clock. Each measurement is a `Benchmark.Clock.Observation`.

## Laws

- `Benchmark.Clock.calibrate(_:)` reads the clock 32 times back to back. The smallest positive gap is the observed resolution, or nil if every gap was zero. The median gap is the overhead.
- A calibration's floor is the largest of the declared resolution, the observed resolution and the overhead. An observation's adjusted duration is its raw duration minus that floor, and never below zero.
- `Benchmark.Clock.continuous(calibration:condition:)` calibrates a fresh `ContinuousClock` on every call unless you pass a calibration. `Benchmark.Clock.probe(_:calibration:condition:)` defaults to `Benchmark.Clock.Calibration.zero`, so adjusted equals raw.
- The condition is a label only. Marking an observation as instrumented changes neither its raw nor its adjusted duration.
- Evaluations and `Benchmark.Clock.Observation.formatted(_:)` use the adjusted duration, never the raw one.
- `Benchmark.Clock.maximum(_:)` ignores the baseline. It reports a regression only when the adjusted duration is strictly above the limit.
- `Benchmark.Clock.regression(tolerance:)` reports a regression when the current result is slower than the baseline by more than the tolerance, and an improvement when it is faster by more than the tolerance. A difference exactly at the tolerance is unchanged.
