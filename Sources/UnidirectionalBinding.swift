import ReactiveKit
import Bond

precedencegroup BindingPrecedence {
    associativity: none

    // Binds tighter than assignment but looser than everything else
    higherThan: AssignmentPrecedence
}

infix operator => : BindingPrecedence

public protocol BindingTargetProvider {
    associatedtype Value

    var bindingTarget: BindingTarget<Value> { get }
}

public struct BindingTarget<Value>: BindingTargetProvider {
    public let deallocated: SafeSignal<Void>
    public let action: (Value) -> Void

    public var bindingTarget: BindingTarget<Value> {
        self
    }

    public init(deallocated: SafeSignal<Void>, action: @escaping (Value) -> Void) {
        self.deallocated = deallocated
        self.action = action
    }
}

extension BindingTarget {
    public init<Object: Deallocatable>(object: Object, action: @escaping (Value) -> Void) {
        self.init(deallocated: object.deallocated, action: action)
    }

    public init<Object: Deallocatable>(object: Object, keyPath: WritableKeyPath<Object, Value>) {
        self.init(object: object) { [weak object = object] value in
            object?[keyPath: keyPath] = value
        }
    }
}

public protocol BindingSource: BindingExecutionContextProvider, SignalProtocol where Error == Never {}

extension Observable: BindingSource {
    public var bindingExecutionContext: ExecutionContext { .immediateOnMain }
}

extension Signal: BindingExecutionContextProvider where Error == Never {}
extension Signal: BindingSource where Error == Never {
    public var bindingExecutionContext: ExecutionContext { .immediateOnMain }
}

extension BindingTargetProvider {
    @discardableResult
    public static func =>
        <Source: BindingSource>(
        source: Source,
        provider: Self
    ) -> Disposable where Value == Source.Element {
        let target = provider.bindingTarget
        let action = target.action
        let context = source.bindingExecutionContext

        return source.prefix(untilOutputFrom: target.deallocated).observeNext { value in
            context.execute {
                action(value)
            }
        }
    }

    @discardableResult
    public static func =>
        <Source: BindingSource>(
        source: Source,
        provider: Self
    ) -> Disposable where Value == Source.Element? {
        source.map(Optional.init) => provider
    }
}

// MARK: - BindingTargetProvider Extensions

extension ObserverProtocol where Self: BindingTargetProvider & Deallocatable {
    public var bindingTarget: BindingTarget<Element> {
        .init(deallocated: deallocated) { [weak self] element in
            self?.receive(element)
        }
    }
}

extension Observable: BindingTargetProvider {}

extension ReactiveExtensions where Base: Deallocatable {
    private func makeBindingTarget<Value>(keyPath: ReferenceWritableKeyPath<Base, Value>) -> BindingTarget<Value> {
        .init(object: base, keyPath: keyPath)
    }

    public subscript<Value>(keyPath: ReferenceWritableKeyPath<Base, Value>) -> BindingTarget<Value> {
        .init(object: base, keyPath: keyPath)
    }

    public subscript<Value>(action: @escaping (Base) -> (Value) -> Void) -> BindingTarget<Value> {
        .init(object: base) { [weak base = base] value in
            if let base = base {
                action(base)(value)
            }
        }
    }

    public func makeBindingTarget<Value>(action: ((Base, Value) -> Void)?) -> BindingTarget<Value> {
        .init(object: base) { [weak base = base] value in
            if let base = base {
                action?(base, value)
            }
        }
    }

    public subscript<Value>(action: ((Base, Value) -> Void)?) -> BindingTarget<Value> {
        makeBindingTarget(action: action)
    }

    public subscript<Value>(action: @escaping (Base, Value) -> Void) -> BindingTarget<Value> {
        makeBindingTarget(action: action)
    }

    public subscript(action: @escaping (Base) -> () -> Void) -> BindingTarget<Void> {
        .init(object: base) { [weak base = base] _ in
            if let base = base {
                action(base)()
            }
        }
    }

    public subscript(action: ((Base) -> Void)?) -> BindingTarget<Void> {
        makeBindingTarget { base, _ in
            action?(base)
        }
    }

    public subscript(action: @escaping (Base) -> Void) -> BindingTarget<Void> {
        self[Optional(action)]
    }

    public subscript<A, B>(action: @escaping (Base) -> (A, B) -> Void) -> BindingTarget<(A, B)> {
        .init(object: base) { [weak base = base] (a, b) in
            if let base = base {
                action(base)(a, b)
            }
        }
    }

    public subscript<A, B>(action: ((Base, A, B) -> Void)?) -> BindingTarget<(A, B)> {
        makeBindingTarget { base, args in
            let (a, b) = args
            action?(base, a, b)
        }
    }

    public subscript<A, B>(action: @escaping (Base, A, B) -> Void) -> BindingTarget<(A, B)> {
        self[Optional(action)]
    }

    public subscript<A, B, C>(action: @escaping (Base) -> (A, B, C) -> Void) -> BindingTarget<(A, B, C)> {
        .init(object: base) { [weak base = base] (a, b, c) in
            if let base = base {
                action(base)(a, b, c)
            }
        }
    }

    public subscript<A, B, C>(action: ((Base, A, B, C) -> Void)?) -> BindingTarget<(A, B, C)> {
        makeBindingTarget { base, args in
            let (a, b, c) = args
            action?(base, a, b, c)
        }
    }

    public subscript<A, B, C>(action: @escaping (Base, A, B, C) -> Void) -> BindingTarget<(A, B, C)> {
        self[Optional(action)]
    }

}
