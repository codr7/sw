extension packages {
    class Core: Package {
        let anyType: AnyType
        let bitType: BitType
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

        let T: Value
        let F: Value

        init() {
            anyType = AnyType("Any", [])
            bitType = BitType("Bit", [anyType])
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

            T = Value(bitType, true)
            F = Value(bitType, false)

            super.init("core")
        }
        
        override func initBindings(_ vm: VM) {
            bind(vm, anyType)
            bind(vm, bitType)
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
            
            self["#t"] = T
            self["#f"] = F


            bindMacro(vm, "[", [anyType], [anyType, anyType],
                      {(vm, arguments, location) in
                          vm.emit(ops.BeginStack.make())
                          return arguments
                      })

            bindMacro(vm, "]", [anyType], [anyType, anyType],
                      {(vm, arguments, location) in
                          vm.emit(ops.EndStack.make())
                          return arguments
                      })

            bindMacro(vm, "C", [anyType], [anyType, anyType],
                      {(vm, arguments, location) in
                          vm.emit(ops.Copy.make(1))
                          return arguments
                      })

            bindMacro(vm, "L",
                      [anyType, anyType, anyType],
                      [anyType, anyType, anyType],
                      {(vm, arguments, location) in
                          vm.emit(ops.ShiftLeft.make())
                          return arguments
                      })

            bindMacro(vm, "P", [anyType], [anyType, anyType],
                      {(vm, arguments, location) in
                          vm.emit(ops.Pop.make(1))
                          return arguments
                      })

            bindMacro(vm, "R",
                      [anyType, anyType, anyType],
                      [anyType, anyType, anyType],
                      {(vm, arguments, location) in
                          vm.emit(ops.ShiftRight.make())
                          return arguments
                      })

            bindMacro(vm, "S", [anyType, anyType], [anyType, anyType],
                      {(vm, arguments, location) in
                          vm.emit(ops.Swap.make())
                          return arguments
                      })

            bindMacro(vm, "U", [pairType], [anyType, anyType],
                      {(vm, arguments, location) in
                          vm.emit(ops.Unzip.make())
                          return arguments
                      })

            bindMacro(vm, "Z", [anyType, anyType], [pairType],
                      {(vm, arguments, location) in
                          vm.emit(ops.Zip.make())
                          return arguments
                      })

            bindMethod(vm, "say", [anyType], [],
                       {(vm, location) in print(vm.stack.pop().say(vm)) })
        }
    }
}
