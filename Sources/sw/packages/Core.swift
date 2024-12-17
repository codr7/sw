extension packages {
    class Core: Package {
        struct iters {}
        struct traits {}
        
        let anyType: AnyType
        let bitType: BitType
        let charType: CharType
        let formType: FormType
        let i64Type: I64Type
        let iterType: IterType
        let maybeType: MaybeType
        let metaType: MetaType
        let nilType: NilType
        let packageType: PackageType
        let pairType: PairType
        let pathType: PathType
        let refType: RefType
        let seqType: SeqType
        let stackType: StackType
        let stringType: StringType
        let timeType: TimeType

        let methodType: MethodType
        let swMethodType: SwMethodType
        let swiftMethodType: SwiftMethodType

        let NIL: Value

        let TRUE: Value
        let FALSE: Value
        
        init() {
            nilType = NilType("Nil", [])
            anyType = AnyType("Any", [])
            maybeType = MaybeType("Maybe", [anyType, nilType])

            bitType = BitType("Bit", [anyType])
            charType = CharType("Char", [anyType])
            formType = FormType("Form", [anyType])
            i64Type = I64Type("I64", [anyType])
            iterType = IterType("Iter", [anyType])
            metaType = MetaType("Meta", [anyType])
            packageType = PackageType("Package", [anyType])
            pairType = PairType("Pair", [anyType])
            pathType = PathType("Path", [anyType])
            refType = RefType("Ref", [anyType])
            seqType = SeqType("Seq", [anyType])
            stackType = StackType("Stack", [seqType])
            stringType = StringType("String", [seqType])
            timeType = TimeType("Time", [anyType])
            methodType = MethodType("Method", [anyType])
            swMethodType = SwMethodType("SwMethod", [methodType, refType])

            swiftMethodType =
              SwiftMethodType("SwiftMethod", [methodType, refType])

            NIL = Value(nilType, Nil())
            TRUE = Value(bitType, true)
            FALSE = Value(bitType, false)

            super.init("core")
        }
        
        override func initBindings(_ vm: VM) {
            bind(vm, anyType)
            bind(vm, bitType)
            bind(vm, formType)
            bind(vm, i64Type)
            bind(vm, iterType)
            bind(vm, maybeType)
            bind(vm, metaType)
            bind(vm, methodType)
            bind(vm, nilType)
            bind(vm, packageType)
            bind(vm, pairType)
            bind(vm, pathType)
            bind(vm, refType)
            bind(vm, seqType)
            bind(vm, stackType)
            bind(vm, stringType)
            bind(vm, swMethodType)
            bind(vm, timeType)

            self["#_"] = NIL;
            self["#t"] = TRUE
            self["#f"] = FALSE

            bindMacro(vm, "[", [], [], 
                      {(vm, arguments, location) in
                          vm.emit(ops.BeginStack.make())
                          vm.beginPackage()
                      })

            bindMacro(vm, "]", [], [stackType],
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

            bindMethod(vm, ",", [formType], [],
                       {(vm, location) in
                           try vm.stack.pop().cast(self.formType).eval(vm)
                       })            

            bindMethod(vm, "=", [anyType, anyType], [bitType],
                       {(vm, location) in
                           let r = vm.stack.pop()
                           vm.stack.put(self.bitType, vm.stack.top == r)
                       })            

            bindMethod(vm, ">", [anyType, anyType], [bitType],
                       {(vm, location) in
                           let r = vm.stack.pop().cast(self.i64Type)

                           vm.stack.put(self.bitType,
                                        vm.stack.top.cast(self.i64Type) > r)
                       })            
            
            bindMethod(vm, "+", [anyType, anyType], [bitType],
                       {(vm, location) in
                           let r = vm.stack.pop().cast(self.i64Type)

                           vm.stack.put(self.i64Type,
                                        vm.stack.top.cast(self.i64Type) + r)
                       })
            
            bindMacro(vm, "C", [anyType], [anyType, anyType],
                      {(vm, arguments, location) in
                          vm.emit(ops.Copy.make(1))
                      })

            bindMacro(vm, "CC", [anyType], [anyType, anyType],
                      {(vm, arguments, location) in
                          vm.emit(ops.Copy.make(2))
                      })

            bindMacro(vm, "L",
                      [anyType, anyType, anyType],
                      [anyType, anyType, anyType],
                      {(vm, arguments, location) in
                          vm.emit(ops.ShiftLeft.make())
                      })

            bindMacro(vm, "P", [anyType], [],
                      {(vm, arguments, location) in
                          vm.emit(ops.Pop.make(1))
                      })

            bindMacro(vm, "PP", [anyType], [],
                      {(vm, arguments, location) in
                          vm.emit(ops.Pop.make(2))
                      })

            bindMacro(vm, "R",
                      [anyType, anyType, anyType],
                      [anyType, anyType, anyType],
                      {(vm, arguments, location) in
                          vm.emit(ops.ShiftRight.make())
                      })

            bindMacro(vm, "S", [anyType, anyType], [anyType, anyType],
                      {(vm, arguments, location) in
                          vm.emit(ops.Swap.make())
                      })

            bindMacro(vm, "U", [pairType], [anyType, anyType],
                      {(vm, arguments, location) in
                          vm.emit(ops.Unzip.make())
                      })

            bindMacro(vm, "Z", [anyType, anyType], [pairType],
                      {(vm, arguments, location) in
                          vm.emit(ops.Zip.make())
                      })

            bindMacro(vm, "benchmark:", [], [],
                      {(vm, arguments, location) in
                          var body = arguments.getBody()

                          let benchmarkPc =
                            vm.emit(ops.Fail.make(vm, location))

                          try body.emit(vm)
                          
                          vm.code[benchmarkPc] =
                            ops.Benchmark.make(vm, vm.emitPc)
                      })

            
            bindMacro(vm, "check", [anyType, anyType], [],
                      {(vm, arguments, location) in
                          vm.emit(ops.Check.make(vm, location))
                      })

            bindMethod(vm, "dec", [i64Type], [i64Type],
                       {(vm, location) in
                           vm.stack.put(
                             vm.core.i64Type,
                             vm.stack.top.cast(vm.core.i64Type) - 1)
                       })

            bindMacro(
              vm, "define:", [anyType], [methodType],
              {(vm, arguments, location) in
                  let id = arguments
                    .removeFirst()
                    .tryCast(forms.Id.self)!
                    .value

                  var ars: [ValueType] = []
                  var res: [ValueType] = []
                  
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
                          try parseTypes(Forms(ss[0]), &ars)
                      case 2:
                          try parseTypes(Forms(ss[0]), &ars)
                          try parseTypes(Forms(ss[1]), &res) 
                      default:
                          throw EmitError("Invalid argument list: \(argSpec.dump(vm))", argSpec.location)
                      }
                  }

                  let gotoPc = vm.emit(ops.Fail.make(vm, location))
                  let startPc = vm.emitPc
                  var body = arguments.getBody()
                  vm.beginPackage()
                  defer { vm.endPackage() }
                  try body.emit(vm)
                  let endPc = vm.emitPc
                  vm.code[gotoPc] = ops.Goto.make(vm.emitPc)

                  let m = SwMethod(vm,
                                   id,
                                   ars, res,
                                   (startPc, endPc),
                                   location)

                  vm.currentPackage.parent![id] = Value(self.swMethodType, m)
              })
            
            bindMacro(vm, "do:", [], [],
                      {(vm, arguments, location) in
                          let body = arguments.getBody("do:")
                          vm.emit(ops.Do.make(vm, body))
                      })

            bindMethod(vm, "dump", [anyType], [],
                       {(vm, location) in
                           vm.stack.push(self.stringType,
                                         vm.stack.pop().dump(vm))
                       })

            bindMacro(vm, "if:", [], [],
                      {(vm, arguments, location) in
                          let branchPc = vm.emit(ops.Fail.make(vm, location))
                          var elseBody = arguments.getBody()
                          var ifBody = elseBody.getBody("else:")
                          try ifBody.emit(vm)
                          var elsePc = vm.emitPc

                          if !elseBody.isEmpty {
                              elseBody.removeFirst()
                              elseBody = elseBody.getBody()
                              let skipElsePc =
                                vm.emit(ops.Fail.make(vm, location))
                              elsePc = vm.emitPc
                              try elseBody.emit(vm)
                              vm.code[skipElsePc] = ops.Goto.make(vm.emitPc)
                          }                          

                          vm.code[branchPc] = ops.Branch.make(elsePc)
                      })

            bindMethod(vm, "map", [seqType, refType], [iterType],
                       {(vm, location) in
                           let fn = vm.stack.pop().cast(self.refType)
                           let input = vm.stack.pop()
                           let st = input.type as! traits.Seq
                           let it = st.makeIter(input)
                           vm.stack.push(self.iterType, iters.Map(fn, it))
                      })

            bindMethod(vm, "next", [iterType], [iterType, maybeType],
                       {(vm, location) in
                           var it = vm.stack.top.cast(vm.core.iterType)
                           
                           if (try it.next(vm, location)) {
                               vm.stack.put(vm.core.iterType, it, 1)
                           } else {
                               vm.stack.put(vm.core.NIL)
                           }
                       })
            
            bindMacro(vm, "recall", [], [],
                      {(vm, arguments, location) in
                          vm.emit(ops.Goto.make(vm.dos.last!))
                      })

            bindMethod(vm, "say", [anyType], [],
                       {(vm, location) in
                           print(vm.stack.pop().say(vm))
                       })
        }
    }
}
