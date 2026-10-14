public import Benchmark

extension Benchmark.Clock {
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
        return Swift::max(declared, observed)
    }
}
