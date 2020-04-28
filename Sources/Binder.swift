import ReactiveKit
import Bond

// MARK: Method Binder

extension ReactiveExtensions where Base: Deallocatable & BindingExecutionContextProvider {
    public subscript(_ action: @escaping (Base) -> () -> Void) -> Bond<Void> {
        Bond(target: base) { base, _ in
            action(base)()
        }
    }

    public subscript<Value>(_ action: @escaping (Base) -> () -> Void) -> Bond<Value> {
        Bond<Value>(target: base) { base, _ in
            action(base)()
        }
    }

    public subscript<Value>(_ action: @escaping (Base) -> (Value) -> Void) -> Bond<Value> {
        Bond(target: base) { base, value in
            action(base)(value)
        }
    }

    public subscript<A, B>(_ action: @escaping (Base) -> (A, B) -> Void) -> Bond<(A, B)> {
        Bond(target: base) { base, args in
            action(base)(args.0, args.1)
        }
    }

    public subscript<A, B, C>(_ action: @escaping (Base) -> (A, B, C) -> Void) -> Bond<(A, B, C)> {
        Bond(target: base) { base, args in
            action(base)(args.0, args.1, args.2)
        }
    }

    public subscript<A, B, C, D>(_ action: @escaping (Base) -> (A, B, C, D) -> Void) -> Bond<(A, B, C, D)> {
        Bond(target: base) { base, args in
            action(base)(args.0, args.1, args.2, args.3)
        }
    }

    public subscript<A, B, C, D, E>(_ action: @escaping (Base) -> (A, B, C, D, E) -> Void) -> Bond<(A, B, C, D, E)> {
        Bond(target: base) { base, args in
            action(base)(args.0, args.1, args.2, args.3, args.4)
        }
    }
}

// MARK: Closure Binder

extension ReactiveExtensions where Base: Deallocatable & BindingExecutionContextProvider {
    public subscript(_ action: ((Base) -> Void)?) -> Bond<Void> {
        Bond(target: base) { base, _ in
            action?(base)
        }
    }

    public subscript<Value>(_ action: ((Base) -> Void)?) -> Bond<Value> {
        Bond<Value>(target: base) { base, _ in
            action?(base)
        }
    }

    public subscript<Value>(_ action: ((Base, Value) -> Void)?) -> Bond<Value> {
        Bond(target: base) { base, value in
            action?(base, value)
        }
    }

    public subscript<A, B>(_ action: ((Base, A, B) -> Void)?) -> Bond<(A, B)> {
        Bond(target: base) { base, args in
            action?(base, args.0, args.1)
        }
    }

    public subscript<A, B, C>(_ action: ((Base, A, B, C) -> Void)?) -> Bond<(A, B, C)> {
        Bond(target: base) { base, args in
            action?(base, args.0, args.1, args.2)
        }
    }

    public subscript<A, B, C, D>(_ action: ((Base, A, B, C, D) -> Void)?) -> Bond<(A, B, C, D)> {
        Bond(target: base) { base, args in
            action?(base, args.0, args.1, args.2, args.3)
        }
    }

    public subscript<A, B, C, D, E>(_ action: ((Base, A, B, C, D, E) -> Void)?) -> Bond<(A, B, C, D, E)> {
        Bond(target: base) { base, args in
            action?(base, args.0, args.1, args.2, args.3, args.4)
        }
    }
}

// MARK: KeyPath Binder

extension ReactiveExtensions where Base: Deallocatable & BindingExecutionContextProvider {
    public subscript<Element>(_ keyPath: ReferenceWritableKeyPath<Base, Element>) -> Bond<Element> {
        Bond(target: base) { base, value in
            base[keyPath: keyPath] = value
        }
    }

    public subscript<Element>(_ keyPath: ReferenceWritableKeyPath<Base, Element?>) -> Bond<Element?> {
        Bond(target: base) { base, value in
            base[keyPath: keyPath] = value
        }
    }
}
