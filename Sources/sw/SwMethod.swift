class SwMethod: BaseMethod, Method {    
    let location: Location
    let startPc: PC
    
    init(_ vm: VM,
         _ id: String,
         _ arguments: [ValueType],
         _ results: [ValueType],
         _ location: Location) {
        self.location = location
        self.startPc = vm.emitPc
        super.init(id, arguments, results)
    }

    func call(_ vm: VM, _ location: Location) throws {
        if arguments.count < arguments.count {
            throw EvalError("Not enough arguments: \(self)", location)
        }
        
        vm.calls.append(Call(vm, self, vm.pc + 1, location))
        vm.pc = startPc
    }
}
