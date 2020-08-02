/// Protocol to define the opaque type returned from a request.
//一个request可以取消的概念
public protocol Cancellable {

    /// A Boolean value stating whether a request is cancelled.
    var isCancelled: Bool { get }

    /// Cancels the represented request.
    func cancel()
}

internal class CancellableWrapper: Cancellable {
    internal var innerCancellable: Cancellable = SimpleCancellable()

    var isCancelled: Bool { return innerCancellable.isCancelled }

    internal func cancel() {
        innerCancellable.cancel()
    }
}

internal class SimpleCancellable: Cancellable {
    var isCancelled = false
    func cancel() {
        isCancelled = true
    }
}
