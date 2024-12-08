extension packages {
    class Core: Package {
        let anyType: AnyType
        let bitType: BitType
        let formType: FormType
        let intType: IntType
        let macroType: MacroType
        let metaType: MetaType
        let packageType: PackageType
        let pairType: PairType
        let pathType: PathType
        let stackType: StackType
        let stringType: StringType
        let timeType: TimeType

        let methodType: MethodType
        let swMethodType: SwMethodType

        let t: Value
        let f: Value

        init() {
            anyType = AnyType("Any", [])
            bitType = BitType("Bit", [anyType])
            formType = FormType("Form", [anyType])
            intType = IntType("Int", [anyType])
            macroType = MacroType("Macro", [anyType])
            metaType = MetaType("Meta", [anyType])
            packageType = PackageType("Package", [anyType])
            pairType = PairType("Pair", [anyType])
            pathType = PathType("Path", [anyType])
            stackType = StackType("Stack", [anyType])
            stringType = StringType("String", [anyType])
            timeType = TimeType("Time", [anyType])
            methodType = MethodType("Method", [anyType])
            swMethodType = SwMethodType("SwMethod", [methodType])

            t = Value(bitType, true)
            f = Value(bitType, false)

            super.init("core")
        }
        
        override func initBindings(_ vm: VM) {
            bind(vm, anyType)
            bind(vm, bitType)
            bind(vm, formType)
            bind(vm, intType)
            bind(vm, macroType)
            bind(vm, metaType)
            bind(vm, methodType)
            bind(vm, packageType)
            bind(vm, pairType)
            bind(vm, pathType)
            bind(vm, stackType)
            bind(vm, stringType)
            bind(vm, swMethodType)
            bind(vm, timeType)
            
            self["#t"] = t
            self["#f"] = f


            bindMacro(vm, "[", [], [], [], 
                      {(vm, arguments, location) in
                          vm.emit(ops.BeginStack.make())
                          vm.beginPackage()
                      })

            bindMacro(vm, "]", [], [], [stackType],
                      {(vm, arguments, location) in
                          vm.endPackage()
                          vm.emit(ops.EndStack.make())
                      })

            bindMacro(vm, ":", [], [anyType], [methodType],
                      {(vm, arguments, location) in
                          let id = arguments
                            .removeFirst()
                            .tryCast(forms.Id.self)!
                            .value
                          
                          let gotoPc = vm.emit(ops.Fail.make(vm, location))
                          let m = SwMethod(vm, id, [], [], vm.emitPc, location)
                          vm.currentPackage[id] = Value(self.swMethodType, m)
                          vm.beginPackage()
                          defer { vm.endPackage() }
                          
                          while !arguments.isEmpty {
                              let f = arguments.removeFirst()
                              if f.isEnd { break }
                              try f.emit(vm, &arguments)
                          }
                          
                          vm.code[gotoPc] = ops.Goto.make(vm.emitPc)
                      })

            bindMethod(vm, ",", [formType], [],
                       {(vm, location) in
                           try vm.stack.pop().cast(self.formType).eval(vm)
                       })            

            bindMethod(vm, "=", [anyType, anyType], [bitType],
                       {(vm, location) in
                           let r = vm.stack.pop()
                           let i = vm.stack.count-1
                           vm.stack[i] = Value(self.bitType, vm.stack[i] == r)
                       })            

            bindMacro(vm, "C", [anyType], [], [anyType, anyType],
                      {(vm, arguments, location) in vm.emit(ops.Copy.make(1)) })

            bindMacro(vm, "L",
                      [anyType, anyType, anyType], [],
                      [anyType, anyType, anyType],
                      {(vm, arguments, location) in vm.emit(ops.ShiftLeft.make()) })

            bindMacro(vm, "P", [anyType], [], [],
                      {(vm, arguments, location) in vm.emit(ops.Pop.make(1)) })

            bindMacro(vm, "R",
                      [anyType, anyType, anyType], [],
                      [anyType, anyType, anyType],
                      {(vm, arguments, location) in vm.emit(ops.ShiftRight.make()) })

            bindMacro(vm, "S", [anyType, anyType], [], [anyType, anyType],
                      {(vm, arguments, location) in vm.emit(ops.Swap.make()) })

            bindMacro(vm, "U", [pairType], [], [anyType, anyType],
                      {(vm, arguments, location) in vm.emit(ops.Unzip.make()) })

            bindMacro(vm, "Z", [anyType, anyType], [], [pairType],
                      {(vm, arguments, location) in vm.emit(ops.Zip.make()) })

            bindMacro(vm, "check", [anyType, anyType], [], [],
                      {(vm, arguments, location) in
                          vm.emit(ops.Check.make(vm, location))
                      })

            bindMethod(vm, "dump", [anyType], [],
                       {(vm, location) in
                           vm.stack.push(self.stringType, vm.stack.pop().dump(vm))
                       })

            bindMethod(vm, "say", [anyType], [],
                       {(vm, location) in print(vm.stack.pop().say(vm)) })
        }
    }
}
