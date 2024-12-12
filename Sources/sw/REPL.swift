class REPL {
    let vm: VM    
    init(_ vm: VM) { self.vm = vm }
    
    func run() throws  {
        print("sw\(VERSION)\n")
        var input = Input()
        var location = Location("repl")
        var lineNumber = 1
        
        while true {
            print("\(lineNumber)> ", terminator: "")
            let line = readLine(strippingNewline: false)

            if line == nil || line! == "\n" {
                do {     
                    var fs = try vm.read(&input, &location)
                    let startPc = vm.emitPc
                    try fs.emit(vm)
                    try vm.eval(from: startPc)
                    print("\(vm.stack.dump(vm))\n")
                    input.reset()
                } catch {
                    print(error)
                }
            } else if line! == "clear!\n" {
                vm.stack = []
            } else {
                input.append(line!)
                lineNumber += 1
            }
        }
    }
}
