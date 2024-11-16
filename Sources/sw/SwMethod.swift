class SwMethod: BaseMethod, Method {    
    let location: Location
    let startPc: PC
    
    init(_ vm: VM,
         _ id: String,
         _ arguments: [ValueType],
         _ resultType: ValueType?,
         _ location: Location) {
        self.location = location
        self.startPc = vm.emitPc
        super.init(id, arguments, resultType)
    }

    func call(_ vm: VM, _ location: Location) throws {
        
        if arguments.count < minArgumentCount {
            throw EvalError("Not enough arguments: \(self)", location)
        }

        vm.calls.append(Call(vm, self, vm.pc + 1, location))
        vm.pc = startPc
    }
}
