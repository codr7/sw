class REPL {
    let vm: VM    
    init(_ vm: VM) { self.vm = vm }
    
    func run() throws  {
        print("sw\(VERSION)\n")
        var input = Input()
        var prompt = 1
        var location = Location("repl")
        
        while true {
            print("\(prompt)> ", terminator: "")
            let line = readLine(strippingNewline: false)

            if line == ":clear\n" && input.data.isEmpty {
                vm.stack = []
                print("\(vm.stack.dump(vm))\n")
            } else if line == nil || line! == "\n" {
                do {     
                    var fs = try vm.read(&input, &location)
                    let startPc = vm.emitPc
                    try fs.emit(vm)
                    vm.emit(ops.Stop.make())
                    try vm.eval(from: startPc)
                    print("\(vm.stack.dump(vm))\n")
                    input.reset()
                } catch {
                    print(error)
                }
                
                prompt = 1
            } else {
                input.append(line!)
                prompt += 1
            }
        }
    }
}
