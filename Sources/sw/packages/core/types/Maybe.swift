extension packages.Core {
    class MaybeType: BaseType<Value?>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
        }
        
        override func dump(_ vm: VM, _ value: Value) -> String {
            let v = value.cast(self)
            return "\((v == nil) ? "_" : "\(v!.dump(vm))?")"
        }
        
        func eq(_ value1: Value, _ value2: Value) -> Bool {
            let v1 = value1.cast(self)
            let v2 = value2.cast(self)
            if v1 == nil && v1 == nil { return true }
            if v1 == nil || v2 == nil { return false }
            return v1! == v2!
        }
        
        func toBit(_ value: Value) -> Bool { value.cast(self) != nil }
    }
}
