class SwMethod: BaseMethod, Method {    
    let location: Location
    var callPc: PC?
    let emitPc: PC?
    
    init(_ vm: VM,
         _ id: String,
         _ arguments1: [ValueType],
         _ arguments2: [ValueType],
         _ results: [ValueType],
         _ emitPc: PC,
         _ location: Location) {
        self.emitPc = emitPc
        self.callPc = nil
        self.location = location
        super.init(id, arguments1, arguments2, results)
    }
    
    func call(_ vm: VM, _ location: Location) throws {
        if vm.stack.count < arguments.count {
            throw EvalError("Not enough arguments: \(self)", location)
        }
        
        vm.calls.append(Call(vm, self, vm.pc + 1, location))
        vm.pc = callPc!
    }

    func emit(_ vm: VM, _ arguments: inout Forms, _ location: Location) throws {
        let stackOffset = vm.stack.count
        for f in arguments.reversed() { vm.stack.push(vm.core.formType, f) }
        vm.emit(ops.Stop.make())
        try vm.eval(from: emitPc!)
        arguments = []

        for i in stride(from: vm.stack.count-1,
                        through: stackOffset,
                        by: -1) {
            let v = vm.stack[i]
            let f = v.tryCast(vm.core.formType) ?? forms.Literal(v, location)
            arguments.append(f)
        }

        vm.stack = Array(vm.stack[0..<stackOffset])
    }
}
