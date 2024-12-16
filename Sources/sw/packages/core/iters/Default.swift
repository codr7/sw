extension packages.Core.iters {
    struct Default: Iter {
        var source: any IteratorProtocol
        init(_ source: any IteratorProtocol) { self.source = source }

        func dump(_ vm: VM) -> String { "Iter \(source)" }
        
        func equals(_ other: Iter) -> Bool {
            false
        }

        mutating func next(_ vm: VM, _ location: Location) -> Bool {
            if let v = source.next() {
                vm.stack.push(v as! Value)
                return true
            }

            return false
        }
    }
}
