extension packages.Core {
    class AnyType: BaseType<Any>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
        }

        func eq(_ _: Value, _ _: Value) -> Bool {
            fatalError("Not supported")
        }
    }
}

