import ReactiveKit
import Bond

// MARK: - Bind to Closure

extension SignalProtocol where Error == Never, Element == Void {
    @discardableResult
    public func bind<Target: Deallocatable & BindingExecutionContextProvider>(
        to target: Target,
        action: ((Target) -> Void)?
    ) -> Disposable {
        bind(to: target, setter: { target in
            action?(target)
        })
    }
}

extension SignalProtocol where Error == Never {
    @discardableResult
    public func bind<Target: Deallocatable & BindingExecutionContextProvider>(
        to target: Target,
        action: ((Target, Element) -> Void)?
    ) -> Disposable {
        bind(to: target) { target, element in
            action?(target, element)
        }
    }

    @discardableResult
    public func bind<Target: Deallocatable & BindingExecutionContextProvider, A, B>(
        to target: Target,
        action: @escaping (Target, A, B) -> Void
    ) -> Disposable where (A, B) == Element {
        bind(to: target) { target, args in
            action(target, args.0, args.1)
        }
    }

    @discardableResult
    public func bind<Target: Deallocatable & BindingExecutionContextProvider, A, B>(
        to target: Target,
        action: ((Target, A, B) -> Void)?
    ) -> Disposable where (A, B) == Element {
        bind(to: target) { target, args in
            action?(target, args.0, args.1)
        }
    }

    @discardableResult
    public func bind<Target: Deallocatable & BindingExecutionContextProvider, A, B, C>(
        to target: Target,
        action: @escaping (Target, A, B, C) -> Void
    ) -> Disposable where (A, B, C) == Element {
        bind(to: target) { target, args in
            action(target, args.0, args.1, args.2)
        }
    }

    @discardableResult
    public func bind<Target: Deallocatable & BindingExecutionContextProvider, A, B, C>(
        to target: Target,
        action: ((Target, A, B, C) -> Void)?
    ) -> Disposable where (A, B, C) == Element {
        bind(to: target) { target, args in
            action?(target, args.0, args.1, args.2)
        }
    }

    @discardableResult
    public func bind<Target: Deallocatable & BindingExecutionContextProvider, A, B, C, D>(
        to target: Target,
        action: @escaping (Target, A, B, C, D) -> Void
    ) -> Disposable where (A, B, C, D) == Element {
        bind(to: target) { target, args in
            action(target, args.0, args.1, args.2, args.3)
        }
    }

    @discardableResult
    public func bind<Target: Deallocatable & BindingExecutionContextProvider, A, B, C, D>(
        to target: Target,
        action: ((Target, A, B, C, D) -> Void)?
    ) -> Disposable where (A, B, C, D) == Element {
        bind(to: target) { target, args in
            action?(target, args.0, args.1, args.2, args.3)
        }
    }

    @discardableResult
    public func bind<Target: Deallocatable & BindingExecutionContextProvider, A, B, C, D, E>(
        to target: Target,
        action: @escaping (Target, A, B, C, D, E) -> Void
    ) -> Disposable where (A, B, C, D, E) == Element {
        bind(to: target) { target, args in
            action(target, args.0, args.1, args.2, args.3, args.4)
        }
    }

    @discardableResult
    public func bind<Target: Deallocatable & BindingExecutionContextProvider, A, B, C, D, E>(
        to target: Target,
        action: ((Target, A, B, C, D, E) -> Void)?
    ) -> Disposable where (A, B, C, D, E) == Element {
        bind(to: target) { target, args in
            action?(target, args.0, args.1, args.2, args.3, args.4)
        }
    }
}

// MARK: - Bind to Method

extension SignalProtocol where Error == Never {
    @discardableResult
    public func bind<Target: Deallocatable & BindingExecutionContextProvider>(
        to target: Target,
        action: @escaping (Target) -> () -> Void
    ) -> Disposable {
        bind(to: target) { target, _ in
            action(target)()
        }
    }

    @discardableResult
    public func bind<Target: Deallocatable & BindingExecutionContextProvider>(
        to target: Target,
        action: @escaping (Target) -> (Element) -> Void
    ) -> Disposable {
        bind(to: target) { target, args in
            action(target)(args)
        }
    }

    @discardableResult
    public func bind<Target: Deallocatable & BindingExecutionContextProvider, A, B>(
        to target: Target,
        action: @escaping (Target) -> (A, B) -> Void
    ) -> Disposable where (A, B) == Element {
        bind(to: target) { target, args in
            action(target)(args.0, args.1)
        }
    }

    @discardableResult
    public func bind<Target: Deallocatable & BindingExecutionContextProvider, A, B, C>(
        to target: Target,
        action: @escaping (Target) -> (A, B, C) -> Void
    ) -> Disposable where (A, B, C) == Element {
        bind(to: target) { target, args in
            action(target)(args.0, args.1, args.2)
        }
    }

    @discardableResult
    public func bind<Target: Deallocatable & BindingExecutionContextProvider, A, B, C, D>(
        to target: Target,
        action: @escaping (Target) -> (A, B, C, D) -> Void
    ) -> Disposable where (A, B, C, D) == Element {
        bind(to: target) { target, args in
            action(target)(args.0, args.1, args.2, args.3)
        }
    }

    @discardableResult
    public func bind<Target: Deallocatable & BindingExecutionContextProvider, A, B, C, D, E>(
        to target: Target,
        action: @escaping (Target) -> (A, B, C, D, E) -> Void
    ) -> Disposable where (A, B, C, D, E) == Element {
        bind(to: target) { target, args in
            action(target)(args.0, args.1, args.2, args.3, args.4)
        }
    }
}
