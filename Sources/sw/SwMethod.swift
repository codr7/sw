class SwMethod: BaseMethod, Method {    
    let location: Location
    let callPc = -1
    let emitPc: PC
    let arguments1: [ValueType]
    let arguments2: [ValueType]

    override var description: String {
        "\(id) (\(arguments1.dump());\(arguments1.dump());\(results.dump())):"
    }

    init(_ vm: VM,
         _ id: String,
         _ arguments1: [ValueType],
         _ arguments2: [ValueType],
         _ results: [ValueType],
         _ emitPc: PC,
         _ location: Location) {
        self.emitPc = emitPc
        self.location = location
        self.arguments1 = arguments1
        self.arguments2 = arguments2
        super.init(id, arguments2 + arguments1, results)
    }

    func call(_ vm: VM, _ location: Location) throws {
        if arguments.count < arguments.count {
            throw EvalError("Not enough arguments: \(self)", location)
        }
        
        vm.calls.append(Call(vm, self, vm.pc + 1, location))
        vm.pc = callPc
    }

    func emit(_ vm: VM, _ arguments: inout Forms, _ location: Location) throws {
        let stackOffset = vm.stack.count
        for f in arguments.reversed() { vm.stack.push(vm.core.formType, f) }
        vm.emit(ops.Stop.make())
        try vm.eval(from: emitPc)
        arguments = []

        for v in vm.stack[stackOffset...] {
            let f = v.tryCast(vm.core.formType) ?? forms.Literal(v, location)
            arguments.append(f)
        }
    }
}
