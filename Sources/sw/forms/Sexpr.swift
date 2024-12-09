extension forms {
    class Sexpr: BaseForm, Form {
        let body: Forms
        
        init(_ body: Forms, _ location: Location) {
            self.body = body
            super.init(location)
        }

        func dump(_ vm: VM) -> String { body.dump(vm) }

        func emit(_ vm: VM, _ arguments: inout Forms) throws {
            try getValue(vm)!.emit(vm, &arguments, location)
        }

        func equals(_ other: Form) -> Bool {
            if let o = other.tryCast(Sexpr.self) { self.body.equals(o.body) }
            else {false}
        }

        override func getType(_ vm: VM) -> ValueType? { vm.core.stackType }

        override func getValue(_ vm: VM) -> Value? {
            Value(vm.core.stackType,
                  Stack(body.map({Value(vm.core.formType, $0)}).reversed()))
        }
    }
}
