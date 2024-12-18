class SwiftMethod: BaseMethod, Method, Ref {
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
            vm.emit(.Call(target: self, location: location))
        }
    }

    func call(_ vm: VM, _ location: Location) throws {
        if vm.stack.count < arguments.count {
            throw EvalError("Not enough arguments: \(self)", location)
        }
        
        try callBody!(vm, location)
    }

    func emit(_ vm: VM,
              _ arguments: inout Forms,
              _ location: Location) throws {
        try emitBody!(vm, &arguments, location)
    }

    func equals(_ other: Ref) -> Bool {
        if let o = other as? SwiftMethod {self.equals(o)}
        else {false}
    }
}
