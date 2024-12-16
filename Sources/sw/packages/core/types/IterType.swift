extension packages.Core {
    class IterType: BaseType<Iter>, ValueType, traits.Seq {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
        }

        override func dump(_ vm: VM, _ value: Value) -> String {
            "\(value.cast(self).dump(vm))"
        }

        func eq(_ value1: Value, _ value2: Value) -> Bool {
            value1.cast(self).equals(value2.cast(self))
        }

        func makeIter(_ target: Value) -> Iter {target.cast(self)}
    }
}
