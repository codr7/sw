extension packages.Core {
    class IndexType: BaseType<Any>, ValueType, traits.Index {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
        }

        func eq(_ value1: Value, _ value2: Value) -> Bool {
            fatalError("Not supported")
        }

        func at(_ vm: VM, _ target: Value, _ i: Value) -> Value {
            fatalError("Not supported")
        }
    }
}
