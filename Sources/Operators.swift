import ReactiveKit
import Bond

// MARK: - Operators

extension SignalProtocol {
    public func void() -> Signal<Void, Error> {
        replaceElements(with: ())
    }

    public func map<Result>(_ keyPath: KeyPath<Element, Result>) -> Signal<Result, Error> {
        map { $0[keyPath: keyPath] }
    }

    public func compactMap<Result>(_ keyPath: KeyPath<Element, Result?>) -> Signal<Result, Error> {
        compactMap { $0[keyPath: keyPath] }
    }

    public func `as`<Transformed>(_ transformedType: Transformed.Type) -> Signal<Transformed?, Error> {
        map { $0 as? Transformed }
    }

    public func of<Transformed>(_ transformedType: Transformed.Type) -> Signal<Transformed, Error> {
        compactMap { $0 as? Transformed }
    }

    public func filter(_ keyPath: KeyPath<Element, Bool>) -> Signal<Element, Error> {
        filter { $0[keyPath: keyPath] }
    }

    public func ignore(_ keyPath: KeyPath<Element, Bool>) -> Signal<Element, Error> {
        filter { !$0[keyPath: keyPath] }
    }

    public func ignore(_ predicate: @escaping (Element) -> Bool) -> Signal<Element, Error> {
        filter { !predicate($0) }
    }

    public func catchErrorJustComplete() -> Signal<Element, Error> {
        flatMapError { _ in Signal.completed() }
    }

    public func trackActivity(_ activityIndicator: Observable<Bool>) -> Signal<Element, Error> {
        handleEvents(receiveSubscription: {
            activityIndicator.value = true
        }, receiveOutput: { _ in
            activityIndicator.value = false
        }, receiveCompletion: { _ in
            activityIndicator.value = false
        }, receiveCancel: {
            activityIndicator.value = false
        })
    }
}

// MARK: - Equatable

extension SignalProtocol where Element: Equatable {
    public func filter(_ valuesToFilter: Element...) -> Signal<Element, Error> {
        filter { valuesToFilter.contains($0) }
    }

    public func filter<Sequence: Swift.Sequence>(_ valuesToFilter: Sequence) -> Signal<Element, Error> where Sequence.Element == Element {
        filter { valuesToFilter.contains($0) }
    }

    public func ignore(_ valuesToIgnore: Element...) -> Signal<Element, Error> {
        filter { !valuesToIgnore.contains($0) }
    }

    public func ignore<Sequence: Swift.Sequence>(_ valuesToIgnore: Sequence) -> Signal<Element, Error> where Sequence.Element == Element {
        filter { !valuesToIgnore.contains($0) }
    }
}

// MARK: - String?

extension SignalProtocol where Element == String? {
    public func ignoreEmpty() -> Signal<String, Error> {
        ignoreNils().ignoreEmpty()
    }
}

// MARK: - Bool

extension SignalProtocol where Element == Bool {
    public func not() -> Signal<Bool, Error> {
        map(!)
    }
}

// MARK: - Collection

extension SignalProtocol where Element: Collection {
    public func ignoreEmpty() -> Signal<Element, Error> {
        ignore(\.isEmpty)
    }

    public func mapElements<Transformed>(_ transform: @escaping (Element.Element) -> Transformed) -> Signal<[Transformed], Error> {
        map { $0.map(transform) }
    }
}

// MARK: - EventConvertible

extension Signal.Event: EventConvertible {
    /// Event representation of this instance
    public var event: Signal<Element, Error>.Event {
        self
    }
}

extension SignalProtocol where Element: EventConvertible {
    public func elements() -> Signal<Element.Element, Error> {
        compactMap(\.event.element)
    }

    public func errors() -> Signal<Element.Error, Error> {
        compactMap(\.event.error)
    }
}

// MARK: - ResultConvertible

import ResultConvertible

extension SignalProtocol where Element: ResultConvertible {
    public func elements() -> Signal<Element.Success, Error> {
        compactMap(\.result.success)
    }

    public func errors() -> Signal<Element.Failure, Error> {
        compactMap(\.result.failure)
    }
}
