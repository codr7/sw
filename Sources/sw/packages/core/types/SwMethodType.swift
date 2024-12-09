extension packages.Core {
    class SwMethodType: BaseType<SwMethod>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
            let t = self

            call = {(vm, target, location) throws in
                try target.cast(t).call(vm, location)
            }
            
            eq = {(value1, value2) in
                value1.cast(t) === value2.cast(t)
            }
        }

        override func compile(_ vm: VM,
                              _ target: Value,
                              _ arguments: inout Forms,
                              _ index: Int,
                              _ location: Location) throws {
            let arity = target.cast(self).arguments2.count
            if arity > 0 { arguments.swapAt(index, index - arity) }
        }

        func emitId(_ vm: VM,
                    _ target: Value,
                    _ arguments: inout Forms,
                    _ location: Location) throws {
            try target.cast(self).emit(vm, &arguments, location)
        }
    }
}

