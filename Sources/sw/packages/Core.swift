extension packages {
    class Core: Package {
        let anyType: AnyType
        let bitType: BitType
        let formType: FormType
        let intType: IntType
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

            let parseTypes = {(_ body: Forms,
                              _ result: inout [ValueType]) in
                for f in body {
                    if f.isEnd {
                        result.append(self.anyType)
                    } else if let t = f
                         .getValue(vm)?
                         .tryCast(self.metaType) {
                        result.append(t)
                    } else {
                        throw EmitError("Missing value",
                                        f.location)
                    }
                }
            }
            
            bindMacro(
              vm, ":", [], [anyType], [methodType],
              {(vm, arguments, location) in
                  let id = arguments
                    .removeFirst()
                    .tryCast(forms.Id.self)!
                    .value

                  var as1: [ValueType] = []
                  var as2: [ValueType] = []
                  var rs: [ValueType] = []
                  
                  if let argSpec =
                       arguments.first?.tryCast(
                         forms.Sexpr.self) {
                      arguments.removeFirst()

                      let ss = argSpec.body.split(
                        omittingEmptySubsequences: false,
                        whereSeparator: {$0.isEnd})

                      switch ss.count {
                      case 0:
                          break
                      case 1:
                          try parseTypes(Forms(ss[0]), &as1)
                      case 2:
                          try parseTypes(Forms(ss[0]), &as1)
                          try parseTypes(Forms(ss[1]), &rs) 
                      case 3:
                          try parseTypes(Forms(ss[0]), &as2)
                          try parseTypes(Forms(ss[1]), &as1)
                          try parseTypes(Forms(ss[2]), &rs)
                      default:
                          throw EmitError("Invalid argument list: \(argSpec.dump(vm))", argSpec.location)
                      }
                  }

                  let gotoPc = vm.emit(ops.Fail.make(vm, location))

                  let m = SwMethod(vm,
                                   id,
                                   as1, as2, rs,
                                   vm.emitPc,
                                   location)
                  
                  vm.currentMethod = m
                  vm.currentPackage[id] = Value(self.swMethodType, m)
                  vm.beginPackage()
                  defer { vm.endPackage() }
                  
                  while !arguments.isEmpty {
                      let f = arguments.removeFirst()
                      if f.isEnd { break }
                      try f.emit(vm, &arguments)
                  }

                  m.endPc = vm.emitPc
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

            bindMethod(vm, "dec", [intType], [intType],
                       {(vm, location) in
                           vm.stack[vm.stack.count-1] =
                             Value(vm.core.intType,
                                   vm.stack.last!.cast(vm.core.intType) - 1)
                       })

            bindMacro(vm, "do", [], [], [],
                      {(vm, arguments, location) in
                          let das = arguments
                            .prefix(while: {
                              $0.tryCast(forms.Id.self)?.value != "do"
                          }).prefix(while: {!$0.isEnd})

                          arguments =
                            Forms(arguments.dropFirst((arguments.isEmpty ||
                                                         !arguments.first!.isEnd)
                                                        ? das.count
                                                        : das.count+1))

                          vm.emit(ops.Do.make(vm, Forms(das)))
                      })

            bindMethod(vm, "dump", [anyType], [],
                       {(vm, location) in
                           vm.stack.push(self.stringType,
                                         vm.stack.pop().dump(vm))
                       })

            bindMacro(vm, "recall", [], [], [],
                      {(vm, arguments, location) in
                          vm.emit(ops.Goto.make(vm.doStack.last!))
                      })

            bindMethod(vm, "say", [anyType], [],
                       {(vm, location) in
                           print(vm.stack.pop().say(vm))
                       })
        }
    }
}
