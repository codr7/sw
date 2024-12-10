class SwiftMethod: BaseMethod, Method {
    typealias CallBody = (_ vm: VM, _ location: Location) throws -> Void

    typealias EmitBody = (_ vm: VM,
                          _ arguments: inout Forms,
                          _ location: Location) throws -> Void

    let callBody: CallBody?
    var emitBody: EmitBody?
    
    init(_ id: String,
         _ arguments: [ValueType],
         _ results: [ValueType],
         _ body: @escaping EmitBody) {
        self.emitBody = body
        self.callBody = nil
        super.init(id, arguments, results)
    }

    init(_ id: String,
         _ arguments: [ValueType],
         _ results: [ValueType],
         _ body: @escaping CallBody) {
        self.callBody = body        
        super.init(id, arguments, results)

        self.emitBody = {(vm, arguments, location) in
            vm.emit(ops.CallTag.make(vm, Value(vm.core.methodType, self), location))
        }
    }

    func call(_ vm: VM, _ location: Location) throws {
        if vm.stack.count < arguments.count {
            throw EvalError("Not enough arguments: \(self)", location)
        }
        
        vm.pc += 1
        try callBody!(vm, location)
    }

    func emit(_ vm: VM, _ arguments: inout Forms, _ location: Location) throws {
        try emitBody!(vm, &arguments, location)
    }
}
