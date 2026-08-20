// This source file is part of the swift-benchmark-clock open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-benchmark-clock project authors
// Licensed under Apache License v2.0

public import Benchmark
public import Time_Format_Primitives

extension Benchmark.Clock {
    /// One typed duration observation with calibration and contamination provenance.
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
    public func formatted(_ format: Time.Format = .duration) -> String {
        adjusted.formatted(format)
    }
}
