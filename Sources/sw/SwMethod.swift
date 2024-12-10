class SwMethod: BaseMethod, Method {    
    let location: Location
    let startPc: PC
    var endPc: PC? = nil
    
    init(_ vm: VM,
         _ id: String,
         _ arguments: [ValueType],
         _ results: [ValueType],
         _ startPc: PC,
         _ location: Location) {
        self.startPc = startPc
        self.location = location
        super.init(id, arguments, results)
    }

    func call(_ vm: VM, _ location: Location) throws {
        fatalError("Not done yet!")
        /*
        if vm.stack.count < arguments.count {
            throw EvalError("Not enough arguments: \(self)",
                            location)
        }

        let startPc = vm.emitPc
        
        // convert stack args to literals
        // call try emit(vm, &forms, location
        
        vm.calls.append(Call(vm, self, vm.pc + 1, location))
        vm.pc = startPc*/
    }

    func emit(_ vm: VM,
              _ arguments: inout Forms,
              _ location: Location) throws {
        let stackOffset = vm.stack.count
        for f in arguments.reversed() { vm.stack.push(vm.core.formType, f) }
        try vm.eval(from: startPc, to: endPc!)

        arguments = Forms(vm.stack
          .suffix(vm.stack.count-stackOffset)
          .map({$0.tryCast(vm.core.formType) ?? forms.Literal($0, location)})
          .reversed())

        vm.stack = Array(vm.stack.prefix(stackOffset))
    }
}
