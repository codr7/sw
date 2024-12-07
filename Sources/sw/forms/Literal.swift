extension forms {
    class Literal: BaseForm, Form {
        let value: Value
        
        init(_ value: Value, _ location: Location) {
            self.value = value
            super.init(location)
        }

        func dump(_ vm: VM) -> String { value.dump(vm) }

        func emit(_ vm: VM, _ arguments: inout Forms) throws {
            try value.emit(vm, &arguments, location)
        }

        func equals(_ other: Form) -> Bool {
            if let o = other.tryCast(Literal.self) { self.value == o.value }
            else {false}
        }

        override func getType(_ vm: VM) -> ValueType? { value.type }
        override func getValue(_ vm: VM) -> Value? { value }
    }
}
