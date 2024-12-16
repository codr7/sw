extension packages.Core.iters {
    struct Chars: Iter {
        var source: any IteratorProtocol<Character>
        
        init(_ source: any IteratorProtocol<Character>) {
            self.source = source
        }

        func dump(_ vm: VM) -> String { "Iter \(source)" }        
        func equals(_ other: Iter) -> Bool { fatalError("Not supported") }

        mutating func next(_ vm: VM, _ location: Location) -> Bool {
            if let v = source.next() {
                vm.stack.push(vm.core.charType, v)
                return true
            }

            return false
        }
    }
}
