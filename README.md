# Benchmark Clock

[![CI](https://github.com/swift-foundations/swift-benchmark-clock/actions/workflows/ci.yml/badge.svg)](https://github.com/swift-foundations/swift-benchmark-clock/actions/workflows/ci.yml)

The Benchmark × Clock relation: typed duration probes, toolchain continuous-clock observation, calibration, resolution and timing floors, honest instrumentation labels, clock evaluation, and diagnostics.

```swift
import Benchmark_Clock

let probe = Benchmark.Clock.continuous()
```

This package has no Test, Apple Testing, Memory, SwiftSyntax, JSON, FileSystem, Console, or reporter dependency. Importing Benchmark Clock is an explicit choice independent of Benchmark Memory.

## License

Apache 2.0. See [LICENSE.md](LICENSE.md).
