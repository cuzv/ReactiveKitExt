import ReactiveKit

public func materialize<In, Out, Error: Swift.Error>(_ function: @escaping (In) -> Signal<Out, Error>) -> (In) -> Signal<Signal<Out, Error>.Event, Never> {
    return {
        function($0).materialize()
    }
}

public func mapToResult<In, Out, Error: Swift.Error>(_ function: @escaping (In) -> Signal<Out, Error>) -> (In) -> Signal<Result<Out, Error>, Never> {
    return {
        function($0).mapToResult()
    }
}
