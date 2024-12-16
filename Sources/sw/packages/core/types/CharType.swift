extension packages.Core {
    class CharType: BaseType<Character>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
        }

        override func dump(_ vm: VM, _ value: Value) -> String {
            switch value.cast(self) {
            case "\n": "\\\\n"
            case "\r": "\\\\r"
            case "\t": "\\\\t"
            case let c: "\\\(c)"
            }
        }
        
        func eq(_ value1: Value, _ value2: Value) -> Bool {
            value1.cast(self) == value2.cast(self)
        }
        
        func toBit(_ value: Value) -> Bool { value.cast(self) != "\0" }
    }
}
