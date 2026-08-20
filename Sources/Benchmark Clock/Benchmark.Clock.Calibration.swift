// This source file is part of the swift-benchmark-clock open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-benchmark-clock project authors
// Licensed under Apache License v2.0

public import Benchmark

extension Benchmark.Clock {
    /// Empty-probe overhead and resolution used to establish an honest timing floor.
    public struct Calibration: Sendable, Hashable {
        public let resolution: Resolution
        public let overhead: Duration
        public let floor: Duration

        public init(resolution: Resolution, overhead: Duration) {
            self.resolution = resolution
            self.overhead = overhead
            self.floor = Swift.max(resolution.floor, overhead)
        }
    }
}

extension Benchmark.Clock.Calibration {
    public static let zero = Self(
        resolution: .init(declared: .zero, observed: nil),
        overhead: .zero
    )

    public func adjust(_ duration: Duration) -> Duration {
        Swift.max(.zero, duration - floor)
    }
}
