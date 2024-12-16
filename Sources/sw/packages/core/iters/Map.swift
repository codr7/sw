extension packages.Core.iters {
    struct Map: Iter {
        let fn: Ref
        var input: Iter
        
        init(_ fn: Ref, _ input: Iter) {
            self.fn = fn
            self.input = input
        }
        
        func dump(_ vm: VM) -> String { "Map \(input.dump(vm))" }
        
        func equals(_ other: Iter) -> Bool {
            if let o = other as? Map,
               fn.equals(o.fn),
               input.equals(o.input) {true}
            else {false}
        }

        mutating func next(_ vm: VM, _ location: Location) throws -> Bool {
            if try self.input.next(vm, location) {
                try fn.call(vm, location)
                return true
            }
            
            return false
        }
    }
}
