import SystemPackage

extension VM {
    func eval(_ startPc: PC) throws {
        pc = startPc
        
        NEXT:
          do {
            let op = code[Int(pc)]
            //print("\(pc) \(ops.decode(op)) \(ops.trace(self, op))")
            
            switch ops.decode(op) {
            case .BeginStack:
                stacks.append(stack)
                stack = []
                pc += 1
            case .CallTag:
                do {
                    let t = tags[ops.CallTag.target(op)] as! Value
                    let l = tags[ops.CallTag.location(op)] as! Location
                    try t.call(self, l)
                }
            case .Copy:
                stack.copy(ops.Copy.count(op))
                pc += 1
            case .EndStack:
                do {
                    var ns = stacks.removeLast()
                    ns.push(core.stackType, stack)
                    stack = ns
                    pc += 1
                }
            case .Goto:
                pc = ops.Goto.pc(op)
            case .Pop:
                stack.drop(ops.Pop.count(op))
                pc += 1
            case .Push:
                stack.push(tags[ops.Push.value(op)] as! Value)
                pc += 1
            case .SetLoadPath:
                loadPath = tags[ops.SetLoadPath.path(op)] as! FilePath
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
