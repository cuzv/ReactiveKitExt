import ReactiveKit
import Bond

// MARK: - Operators

extension SignalProtocol {
    public func optional() -> Signal<Element?, Error> {
        map(Optional.init)
    }

    public func void() -> Signal<Void, Error> {
        replaceElements(with: ())
    }

    public func succeeding<Successor>(_ element: @escaping @autoclosure () -> Successor) -> Signal<Successor, Error> {
        map { _ in element() }
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

    public func with<Inserted>(_ element: @escaping @autoclosure () -> Inserted) -> Signal<(Element, Inserted), Error> {
        map { ($0, element()) }
    }

    public func with<A, B, Inserted>(_ element: @escaping @autoclosure () -> Inserted) -> Signal<(A, B, Inserted), Error> where Element == (A, B) {
        map { ($0.0, $0.1, element()) }
    }

    public func reverse<A, B>() -> Signal<(B, A), Error> where Element == (A, B) {
        map { ($0.1, $0.0) }
    }

    public func reverse<A, B, C>() -> Signal<(C, B, A), Error> where Element == (A, B, C) {
        map { ($0.2, $0.1, $0.0) }
    }

    public func squeeze<A, B, C>() -> Signal<(A, B, C), Error> where Element == (((A, B), C)) {
        map { ($0.0, $0.1, $1) }
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
        }, receiveCompletion: { _ in
            activityIndicator.value = false
        }, receiveCancel: {
            activityIndicator.value = false
        })
    }
}

// MARK: - Equatable

extension SignalProtocol where Element: Equatable {
    public func filter(_ valueToFilter: @escaping @autoclosure () -> Element) -> Signal<Element, Error> {
        filter { valueToFilter() == $0 }
    }

    public func filter(_ valuesToFilter: Element...) -> Signal<Element, Error> {
        filter { valuesToFilter.contains($0) }
    }

    public func filter<Sequence: Swift.Sequence>(_ valuesToFilter: @escaping @autoclosure () -> Sequence) -> Signal<Element, Error> where Sequence.Element == Element {
        filter { valuesToFilter().contains($0) }
    }

    public func ignore(_ valueToFilter: @escaping @autoclosure () -> Element) -> Signal<Element, Error> {
        filter { valueToFilter() != $0 }
    }

    public func ignore(_ valuesToIgnore: Element...) -> Signal<Element, Error> {
        filter { !valuesToIgnore.contains($0) }
    }

    public func ignore<Sequence: Swift.Sequence>(_ valuesToIgnore: @escaping @autoclosure () -> Sequence) -> Signal<Element, Error> where Sequence.Element == Element {
        filter { !valuesToIgnore().contains($0) }
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
    public func toggle() -> Signal<Bool, Error> {
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

    public func terminal() -> Signal<Bool, Error> {
        map(\.event.isTerminal)
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
