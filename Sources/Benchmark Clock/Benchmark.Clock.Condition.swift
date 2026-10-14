public import Benchmark

extension Benchmark.Clock {
    public enum Condition: Sendable, Hashable {
        case clean
        case instrumented(reason: String)
    }
}
