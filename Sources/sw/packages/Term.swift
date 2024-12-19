extension packages {
    class Term: Package {
        let t = Terminal()

        init() {
            super.init("term")
        }
        
        override func initBindings(_ vm: VM) {
            bindMethod(vm, "clear", [], [],
                       {(vm, location) in self.t.clearScreen() })            

            bindMethod(vm, "flush", [], [],
                       {(vm, location) in self.t.flush() })            

            bindMethod(vm, "move-to", [vm.core.i64Type, vm.core.i64Type], [],
                       {(vm, location) in
                           let y = vm.stack.pop().cast(vm.core.i64Type)
                           let x = vm.stack.pop().cast(vm.core.i64Type)
                           self.t.moveTo(Int(x), Int(y))
                       })            
        }
    }
}
