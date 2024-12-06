extension packages.Core {
    class SwMethodType: BaseType<SwMethod>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
            let t = self

            call = {(vm, target, location) throws in
                try target.cast(t).call(vm, location)
            }
            
            eq = {(value1, value2) in value1.cast(t) === value2.cast(t)}
        }

        func emitId(_ vm: VM,
                    _ target: Value,
                    _ arguments: inout Forms,
                    _ location: Location) throws {
            let m = target.cast(self)

            if vm.stack.count < m.arguments.count {
                throw EmitError("Not enough arguments: \(m)", location)
            }
            
            vm.emit(ops.CallTag.make(vm, target, location))
        }
    }
}

