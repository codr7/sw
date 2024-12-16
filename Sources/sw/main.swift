import SystemPackage

let location = Location("main")

func load(_ vm: VM, _ offset: Int) throws {
    for p in CommandLine.arguments[offset...] { try vm.load(FilePath(p), location) }
}

let vm = VM()

vm.user.bind(vm, vm.core)
vm.user.bind(vm, vm.char)
vm.user.bind(vm, vm.user)

vm.user.importFrom(vm.core, vm.core.ids)

if CommandLine.arguments.count == 1 {
    try REPL(vm).run()
} else {
    //vm.user.importFrom(vm.core, ["import"])
    let startPc = vm.emitPc

    switch CommandLine.arguments[1] {
    case "dump":
        try load(vm, 2)
        
        for i in startPc..<vm.emitPc {
            let op = vm.code[i]
            print("\(i) \(ops.decode(op)) \(ops.dump(vm, op))")
        }
    default:
        try load(vm, 1)
        try vm.eval(from: startPc)
    }
}
