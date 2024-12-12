
extension packages.Core {
    class StackType: BaseType<Stack>, CountTrait, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
        }

        func count(_ target: Value) -> Int { target.cast(self).count }

        override func dump(_ vm: VM, _ value: Value) -> String {
            value.cast(self).dump(vm)
        }

        func eq(_ value1: Value, _ value2: Value) -> Bool {
            value1.cast(self) == value2.cast(self)
        }

        func say(_ vm: VM, _ value: Value) -> String {
            value.cast(self).say(vm)
        }
        
        func toBit(_ value: Value) -> Bool { !value.cast(self).isEmpty }
    }
}
