extension packages.Core {
    class PairType: BaseType<Pair>, CountTrait, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self            
        }

        func count(_ target: Value) -> Int {
            var p = target
            var n = 1

            while let np = p.tryCast(self) {
                p = np.1
                n += 1
            }

            return n
        }
        
        override func dump(_ vm: VM, _ value: Value) -> String {
            sw.dump(vm, value.cast(self))
        }

        func eq(_ value1: Value, _ value2: Value) -> Bool {
            value1.cast(self) == value2.cast(self)
        }
    }
}
