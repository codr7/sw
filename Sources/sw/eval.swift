import SystemPackage

extension VM {
    func eval() throws {
        let stopPc = emit(.Stop)
        
        defer {
            if code.count == stopPc+1 { code.removeLast() }
            else { code[stopPc] = .Nop }
        }
        
        NEXT:
          do {
            let op = code[pc]
            //print("\(pc) \(op)")
            
            switch op {
            case let .BeginIter(location):
                do {
                    let s = stack.pop()

                    if let st = s.type as? packages.Core.traits.Seq {
                        iters.append(st.makeIter(s))
                    } else {
                        throw EvalError("Not supported: \(s.dump(self))",
                                        location)
                    }

                    pc += 1
                }
            case .BeginStack:
                beginStack()
                pc += 1
            case let .Benchmark(endPc):
                do {
                    let n = stack.pop().cast(core.i64Type)
                    let startPc = pc + 1
                    var t: Duration = Duration.milliseconds(0)
                    
                    t = try ContinuousClock().measure {
                        for _ in 0..<n {
                            try eval(from: startPc, to: endPc)
                        }
                    }
                    
                    stack.push(core.timeType, t)
                    pc = endPc
                }
            case let .Branch(elsePc):
                pc = stack.pop().toBit() ? pc + 1 : elsePc
            case let .Call(target, location):
                pc += 1
                try target.call(self, location)
            case let .Check(location):
                do {
                    let expected = stack.pop().cast(core.stackType)
                    let n = expected.count
                    let actual = Stack(stack.suffix(n))
                    stack = stack.dropLast(n)
                    
                    if actual != expected {
                        throw BaseError("Check failed, actual: \(actual.dump(self)), expected: \(expected.dump(self))", location)
                    }

                    pc += 1
                }
            case let .Copy(count):
                stack.copy(count)
                pc += 1
            case var .Do(body):
                dos.append(emitPc)
                try body.emit(self)
                dos.removeLast()
                pc += 1
            case .EndIter:
                iters.removeLast()
                pc += 1
            case .EndStack:
                endStack(push: true)
                pc += 1
            case let .Fail(location):
                throw BaseError("Fail", location)
            case let .Goto(targetPc):
                pc = targetPc
            case let .Iter(endPc, location):
                do {
                    var it = iters.last!
                    
                    if try it.next(self, location) {
                        iters[iters.count-1] = it
                        pc += 1
                    } else {
                        pc = endPc
                    }
                }
            case .Nop:
                pc += 1
            case let .Pop(count):
                stack.drop(count)
                pc += 1
            case let .Push(value):
                stack.push(value)
                pc += 1
            case let .SetLoadPath(path):
                loadPath = path
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
