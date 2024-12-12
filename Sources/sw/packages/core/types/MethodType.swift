extension packages.Core {
    class MethodType: BaseType<Method>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
        }

        func emitId(_ vm: VM,
                    _ target: Value,
                    _ arguments: inout Forms,
                    _ location: Location) throws {
            try target.cast(self).emit(vm, &arguments, location)
        }

        func eq(_ value1: Value, _ value2: Value) -> Bool {
            value1.cast(self).id == value2.cast(self).id
        }
    }
}
