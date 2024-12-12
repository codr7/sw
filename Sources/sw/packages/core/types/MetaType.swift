extension packages.Core {
    class MetaType: BaseType<ValueType>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
        }

        func eq(_ value1: Value, _ value2: Value) -> Bool {
            value1.cast(self).id == value2.cast(self).id
        }
    }
}
