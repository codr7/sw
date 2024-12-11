class SwMethod: BaseMethod, Method {    
    let location: Location
    let body: (PC, PC)
    
    init(_ vm: VM,
         _ id: String,
         _ arguments: [ValueType],
         _ results: [ValueType],
         _ body: (PC, PC),
         _ location: Location) {
        self.body = body
        self.location = location
        super.init(id, arguments, results)
    }

    func emit(_ vm: VM,
              _ arguments: inout Forms,
              _ location: Location) throws {
        let stackOffset = vm.stack.count
        for f in arguments.reversed() { vm.stack.push(vm.core.formType, f) }
        try vm.eval(from: body.0, to: body.1)

        arguments = Forms(vm.stack
          .suffix(vm.stack.count-stackOffset)
          .map({$0.tryCast(vm.core.formType) ?? forms.Literal($0, location)})
          .reversed())

        vm.stack = Array(vm.stack.prefix(stackOffset))
    }
}
