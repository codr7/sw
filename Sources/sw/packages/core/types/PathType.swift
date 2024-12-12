extension packages.Core {
    class PathType: BaseType<Path>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
        }

        override func dump(_ _: VM, _ value: Value) -> String {
            "$\(value.cast(self))"
        }

        func eq(_ value1: Value, _ value2: Value) -> Bool {
            value1.cast(self) == value2.cast(self)
        }
        
        func toBit(_ value: Value) -> Bool { !value.cast(self).isEmpty }
    }
}
