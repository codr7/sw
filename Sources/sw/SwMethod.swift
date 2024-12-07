class SwMethod: BaseMethod, Method {    
    let location: Location
    let callPc = -1
    let emitPc: PC
    
    init(_ vm: VM,
         _ id: String,
         _ arguments: [ValueType],
         _ results: [ValueType],
         _ emitPc: PC,
         _ location: Location) {
        self.emitPc = emitPc
        self.location = location
        super.init(id, arguments, results)
    }

    func call(_ vm: VM, _ location: Location) throws {
        if arguments.count < arguments.count {
            throw EvalError("Not enough arguments: \(self)", location)
        }
        
        vm.calls.append(Call(vm, self, vm.pc + 1, location))
        vm.pc = callPc
    }

    func emit(_ vm: VM, _ arguments: inout Forms, _ location: Location) throws {
        for f in arguments.reversed() { vm.stack.push(vm.core.formType, f) }
        vm.emitStop()
        try vm.eval(from: emitPc)
    }
}
