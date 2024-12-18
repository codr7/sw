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
        let indexType: IndexType
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
            indexType = IndexType("Index", [anyType])
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
            bind(vm, indexType)
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

            self["_"] = NIL
            self["#t"] = TRUE
            self["#f"] = FALSE

            bindMacro(vm, "[", [], [], 
                      {(vm, arguments, location) in
                          vm.emit(.BeginStack)
                          vm.beginPackage()
                      })

            bindMacro(vm, "]", [], [stackType],
                      {(vm, arguments, location) in
                          vm.endPackage()
                          vm.emit(.EndStack)
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

            bindMethod(vm, "=1", [iterType], [iterType, maybeType],
                       {(vm, location) in
                           vm.stack.put(self.bitType,
                                        vm.stack.top.cast(self.i64Type) == 1)
                       })

            bindMethod(vm, ">", [anyType, anyType], [bitType],
                       {(vm, location) in
                           let r = vm.stack.pop().cast(self.i64Type)

                           vm.stack.put(self.bitType,
                                        vm.stack.top.cast(self.i64Type) > r)
                       })            

            bindMethod(vm, ">1", [iterType], [iterType, maybeType],
                       {(vm, location) in
                           vm.stack.put(self.bitType,
                                        vm.stack.top.cast(self.i64Type) > 1)
                       })

            bindMethod(vm, "+", [anyType, anyType], [bitType],
                       {(vm, location) in
                           let r = vm.stack.pop().cast(self.i64Type)

                           vm.stack.put(self.i64Type,
                                        vm.stack.top.cast(self.i64Type) + r)
                       })
            
            bindMacro(vm, "C", [anyType], [anyType, anyType],
                      {(vm, arguments, location) in
                          vm.emit(.Copy(count: 1))
                      })

            bindMacro(vm, "CC", [anyType], [anyType, anyType],
                      {(vm, arguments, location) in
                          vm.emit(.Copy(count: 2))
                      })

            bindMacro(vm, "L",
                      [anyType, anyType, anyType],
                      [anyType, anyType, anyType],
                      {(vm, arguments, location) in
                          vm.emit(.ShiftLeft)
                      })

            bindMacro(vm, "P", [anyType], [],
                      {(vm, arguments, location) in
                          vm.emit(.Pop(count: 1))
                      })

            bindMacro(vm, "PP", [anyType], [],
                      {(vm, arguments, location) in
                          vm.emit(.Pop(count: 2))
                      })

            bindMacro(vm, "R",
                      [anyType, anyType, anyType],
                      [anyType, anyType, anyType],
                      {(vm, arguments, location) in
                          vm.emit(.ShiftRight)
                      })

            bindMacro(vm, "S", [anyType, anyType], [anyType, anyType],
                      {(vm, arguments, location) in
                          vm.emit(.Swap)
                      })

            bindMacro(vm, "U", [pairType], [anyType, anyType],
                      {(vm, arguments, location) in
                          vm.emit(.Unzip)
                      })

            bindMacro(vm, "Z", [anyType, anyType], [pairType],
                      {(vm, arguments, location) in
                          vm.emit(.Zip)
                      })

            bindMacro(vm, "benchmark:", [], [],
                      {(vm, arguments, location) in
                          var body = arguments.getBody()

                          let benchmarkPc =
                            vm.emit(.Fail(location: location))

                          try body.emit(vm)
                          
                          vm.code[benchmarkPc] =
                            .Benchmark(endPc: vm.emitPc)
                      })
            
            bindMacro(vm, "check", [anyType, anyType], [],
                      {(vm, arguments, location) in
                          vm.emit(.Check(location: location))
                      })

            bindMethod(vm, "count", [anyType], [i64Type],
                       {(vm, location) in
                           let v = vm.stack.top

                           if let ct = v.type as? traits.Count {
                               vm.stack.put(self.i64Type, Int64(ct.count(v)))
                           } else {
                               throw EvalError("Not supported: \(v.dump(vm))",
                                               location)
                           }
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

                  let gotoPc = vm.emit(.Fail(location: location))
                  let startPc = vm.emitPc
                  var body = arguments.getBody()
                  vm.beginPackage()
                  defer { vm.endPackage() }
                  try body.emit(vm)
                  let endPc = vm.emitPc
                  vm.code[gotoPc] = .Goto(targetPc: vm.emitPc)

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
                          vm.emit(.Do(body: body))
                      })

            bindMethod(vm, "dump", [anyType], [],
                       {(vm, location) in
                           vm.stack.push(self.stringType,
                                         vm.stack.pop().dump(vm))
                       })

            bindMethod(vm, "get", [indexType, anyType], [anyType],
                       {(vm, location) in
                           let i = vm.stack.pop()
                           let s = vm.stack.top
                           
                           if let it = s.type as? traits.Index {
                               vm.stack.put(it.getItem(vm, s, i))
                           } else {
                               throw EvalError("Not supported: \(i.dump(vm))",
                                               location)
                           }
                       })

            bindMacro(vm, "if:", [], [],
                      {(vm, arguments, location) in
                          let branchPc = vm.emit(.Fail(location: location))
                          var elseBody = arguments.getBody()
                          var ifBody = elseBody.getBody("else:")
                          try ifBody.emit(vm)
                          var elsePc = vm.emitPc

                          if !elseBody.isEmpty {
                              elseBody.removeFirst()
                              elseBody = elseBody.getBody()
                              let skipElsePc =
                                vm.emit(.Fail(location: location))
                              elsePc = vm.emitPc
                              try elseBody.emit(vm)
                              vm.code[skipElsePc] = .Goto(targetPc: vm.emitPc)
                          }                          

                          vm.code[branchPc] = .Branch(elsePc: elsePc)
                      })

            bindMethod(vm, "lhs", [pairType], [anyType],
                       {(vm, location) in
                           vm.stack.put(vm.stack.top.cast(self.pairType).0)
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
            
            bindMethod(vm, "range", [i64Type, maybeType, i64Type], [iterType],
                       {(vm, location) in
                           let stride = vm.stack.pop().cast(self.i64Type)
                           let end = vm.stack.pop()
                           let start = vm.stack.pop().cast(self.i64Type)
                           
                           let ev = (end == self.NIL)
                             ? nil
                             : end.cast(self.i64Type)
                           
                           vm.stack.push(self.iterType,
                                         iters.Range(start, ev, stride))
                       })

            bindMacro(vm, "recall", [], [],
                      {(vm, arguments, location) in
                          vm.emit(.Goto(targetPc: vm.dos.last!))
                      })

            bindMethod(vm, "rhs", [pairType], [anyType],
                       {(vm, location) in
                           vm.stack.put(vm.stack.top.cast(self.pairType).1)
                       })

            bindMethod(vm, "say", [anyType], [],
                       {(vm, location) in
                           print(try vm.stack.pop().toString(vm, location))
                       })

            bindMethod(vm, "to-stack", [anyType], [stackType],
                       {(vm, location) in
                           let input = vm.stack.pop()
                           vm.beginStack()
                           defer { vm.endStack(push: true) }
                           
                           if let st = input.type as? traits.Seq {
                               var it = st.makeIter(input)
                               while try it.next(vm, location) {}
                           } else {
                               vm.stack.push(input)
                           }
                       })

            bindMethod(vm, "to-string", [anyType], [stringType],
                       {(vm, location) in
                           vm.stack.put(self.stringType,
                                        try vm.stack.top.toString(vm, location))
                       })
        }
    }
}
