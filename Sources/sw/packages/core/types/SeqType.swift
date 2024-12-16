extension packages.Core {
    class SeqType: BaseType<Any>, ValueType, traits.Seq {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
        }

        func eq(_ value1: Value, _ value2: Value) -> Bool {
            fatalError("Not supported")
        }

        func makeIter(_ target: Value) -> Iter {
            fatalError("Not supported")
        }
    }
}
