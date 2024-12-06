extension packages.Core {
    class MacroType: BaseType<Macro>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
            let t = self
            eq = {(value1, value2) in value1.cast(t).id == value2.cast(t).id}
        }

        func emitId(_ vm: VM, _ target: Value, _ arguments: Forms, _ location: Location) throws -> Forms {
            try target.cast(self).emit(vm, arguments, location)
        }
    }
}
