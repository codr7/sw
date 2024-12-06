extension packages.Core {
    class MethodType: BaseType<Method>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
            let t = self
            call = {(vm, target, location) throws in try target.cast(t).call(vm, location) }
            eq = {(value1, value2) in value1.cast(t).id == value2.cast(t).id}
        }

        func emitId(_ vm: VM,
                    _ target: Value,
                    _ arguments: inout Forms,
                    _ location: Location) throws {
            vm.emit(ops.CallTag.make(vm, target, location))
        }
    }
}
