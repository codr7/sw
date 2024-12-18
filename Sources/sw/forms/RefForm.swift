extension forms {
    class Ref: BaseForm, Form {
        let target: Form
        
        init(_ target: Form, _ location: Location) {
            self.target = target
            super.init(location)
        }

        func dump(_ vm: VM) -> String { "&\(target.dump(vm))" }

        func emit(_ vm: VM, _ arguments: inout Forms) throws {
            if let v = target.getValue(vm),
               let rt = v.type as? packages.Core.traits.Ref {
                vm.emit(.Push(value: Value(vm.core.refType, rt.makeRef(v))))
            } else {
                throw EmitError("Missing ref target", location)
            }
        }

        func equals(_ other: Form) -> Bool {
            if let o = other.tryCast(Ref.self) {
                self.target.equals(o.target)
            }
            else {
                false
            }
        }

        override func getType(_ vm: VM) -> ValueType? { vm.core.refType }

        override func getValue(_ vm: VM) -> Value? {
            if let v = target.getValue(vm),
               let rt = v.type as? packages.Core.traits.Ref {
                Value(vm.core.refType, rt.makeRef(v))
            } else {
                nil
            }
        }
    }
}
