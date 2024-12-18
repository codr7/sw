extension packages.Core {
    struct Nil {}
    
    class NilType: BaseType<Nil>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
        }
        
        override func dump(_ _: VM, _ value: Value) -> String { "_" }
        func eq(_ value1: Value, _ value2: Value) -> Bool { true }
        func toBit(_ value: Value) -> Bool { false }
    }
}
