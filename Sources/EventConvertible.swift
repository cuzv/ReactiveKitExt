import ReactiveKit

public protocol EventConvertible {
    /// Type of element in event
    associatedtype Element
    associatedtype Error: Swift.Error

    /// Event representation of this instance
    var event: Signal<Element, Error>.Event { get }
}
