extension packages.Core {
    class PackageType: BaseType<Package>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
        }

        func eq(_ value1: Value, _ value2: Value) -> Bool {
            value1.cast(self) == value2.cast(self)
        }
        
        func findId(_ source: Value, _ id: String) -> Value? {
            source.cast(self)[id]
        }
    }
}
