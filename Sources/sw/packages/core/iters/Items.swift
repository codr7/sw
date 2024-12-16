extension packages.Core.iters {
    struct Items: Iter {
        var source: any IteratorProtocol<Value>
        
        init(_ source: any IteratorProtocol<Value>) {
            self.source = source
        }

        func dump(_ vm: VM) -> String { "Iter \(source)" }
        func equals(_ other: Iter) -> Bool { fatalError("Not supported") }
        
        mutating func next(_ vm: VM, _ location: Location) -> Bool {
            if let v = source.next() {
                vm.stack.push(v)
                return true
            }

            return false
        }
    }
}
