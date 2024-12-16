extension packages {
    class Char: Package {
        init() {
            super.init("char")
        }
        
        override func initBindings(_ vm: VM) {
            bindMethod(vm, "up", [vm.core.charType], [vm.core.charType],
                       {(vm, location) in
                           vm.stack[vm.stack.count-1] =
                             Value(vm.core.charType,
                                   vm.stack.top
                                     .cast(vm.core.charType)
                                     .uppercased().first!)
                       })            

            bindMethod(vm, "down", [vm.core.charType], [vm.core.charType],
                       {(vm, location) in
                           vm.stack[vm.stack.count-1] =
                             Value(vm.core.charType,
                                   vm.stack.top
                                     .cast(vm.core.charType)
                                     .lowercased().first!)
                       })            
        }
    }
}
