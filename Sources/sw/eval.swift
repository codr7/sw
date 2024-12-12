import SystemPackage

extension VM {
    func eval() throws {
        let stopPc = emit(ops.Stop.make())
        defer { code[stopPc] = ops.Nop.make() }
        
        NEXT:
          do {
            let op = code[pc]
            //print("\(pc) \(ops.decode(op)) \(ops.trace(self, op))")
            
            switch ops.decode(op) {
            case .BeginStack:
                beginStack()
                pc += 1
            case .Benchmark:
                do {
                    let n = stack.pop().cast(core.i64Type)
                    let startPc = pc + 1
                    let endPc = tags[ops.Benchmark.endPc(op)] as! PC
                    var t: Duration = Duration.milliseconds(0)
                    
                    t = try ContinuousClock().measure {
                        for _ in 0..<n {
                            try eval(from: startPc, to: endPc)
                        }
                    }
                    
                    stack.push(core.timeType, t)
                    pc = endPc
                }
            case .Branch:
                if stack.pop().toBit() {
                    pc += 1
                } else {
                    pc = ops.Branch.elsePc(op)
                }
            case .CallTag:
                do {
                    let t = tags[ops.CallTag.target(op)] as! SwiftMethod
                    let l = tags[ops.CallTag.location(op)] as! Location
                    try t.call(self, l)
                }
            case .Check:
                do {
                    let expected = stack.pop().cast(core.stackType)
                    let n = expected.count
                    let actual = Stack(stack.suffix(n))
                    stack = stack.dropLast(n)
                    
                    if actual != expected {
                        let location = tags[ops.Check.location(op)]
                          as! Location
                        
                        throw BaseError("Check failed, actual: \(actual.dump(self)), expected: \(expected.dump(self))", location)
                    }

                    pc += 1
                }
            case .Copy:
                stack.copy(ops.Copy.count(op))
                pc += 1
            case .Do:
                do {
                    dos.append(emitPc)
                    var body = tags[ops.Do.body(op)] as! Forms
                    try body.emit(self)
                    dos.removeLast()
                    pc += 1
                }
            case .EndStack:
                endStack(push: true)
                pc += 1
            case .Fail:
                throw BaseError("Fail",
                                tags[ops.Fail.location(op)]
                                  as! Location)
            case .Goto:
                pc = ops.Goto.pc(op)
            case .Nop:
                pc += 1
            case .Pop:
                stack.drop(ops.Pop.count(op))
                pc += 1
            case .Push:
                stack.push(tags[ops.Push.value(op)] as! Value)
                pc += 1
            case .PushI64:
                stack.push(core.i64Type, ops.PushI64.value(op))
                pc += 1
            case .SetLoadPath:
                loadPath = tags[ops.SetLoadPath.path(op)]
                  as! FilePath
                
                pc += 1
            case .ShiftLeft:
                stack.shiftLeft()
                pc += 1
            case .ShiftRight:
                stack.shiftRight()
                pc += 1
            case .Stop:
                pc += 1
                return            
            case .Swap:
                stack.swap()
                pc += 1
            case .Unzip:
                stack.unzip(self)
                pc += 1
            case .Zip:
                stack.zip(self)
                pc += 1
            }
            
            continue NEXT
        }
    }
}

final class EvalError: BaseError, @unchecked Sendable {}
