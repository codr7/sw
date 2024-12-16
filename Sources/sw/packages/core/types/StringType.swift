extension packages.Core {
    final class StringType: BaseType<String>, ValueType,
                            traits.Count, traits.Seq {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self            
        }

        func count(_ target: Value) -> Int { target.cast(self).count }

        override func dump(_ vm: VM, _ value: Value) -> String {
            "\"\(value.cast(self))\""
        }

        func eq(_ value1: Value, _ value2: Value) -> Bool {
            value1.cast(self) == value2.cast(self)
        }

        func makeIter(_ target: Value) -> Iter {
            iters.Chars(target.cast(self).makeIterator())
        }

        func say(_ vm: VM, _ value: Value) -> String { value.cast(self) }
        func toBit(_ value: Value) -> Bool { !value.cast(self).isEmpty }
    }
}
