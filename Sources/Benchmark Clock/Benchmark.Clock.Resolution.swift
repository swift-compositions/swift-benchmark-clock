// This source file is part of the swift-benchmark-clock open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-benchmark-clock project authors
// Licensed under Apache License v2.0

public import Benchmark

extension Benchmark.Clock {
    /// Declared and empirically observed clock resolution.
    public struct Resolution: Sendable, Hashable {
        public let declared: Duration
        public let observed: Duration?

        public init(declared: Duration, observed: Duration?) {
            self.declared = declared
            self.observed = observed
        }
    }
}

extension Benchmark.Clock.Resolution {
    public var floor: Duration {
        guard let observed else { return declared }
        return Swift.max(declared, observed)
    }
}
