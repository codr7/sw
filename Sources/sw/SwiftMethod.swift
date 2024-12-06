class SwiftMethod: BaseMethod, Method {
    typealias Body = (_ vm: VM, _ location: Location) throws -> Void

    let body: Body

    init(_ id: String,
         _ arguments: [ValueType],
         _ results: [ValueType],
         _ body: @escaping Body) {
        self.body = body
        super.init(id, arguments, results)
    }

    func call(_ vm: VM, _ location: Location) throws {
        if vm.stack.count < arguments.count {
            throw EvalError("Not enough arguments: \(self)", location)
        }
        
        vm.pc += 1
        try body(vm, location)
    }
}
