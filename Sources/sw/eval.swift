import SystemPackage

extension VM {
    func eval(_ startPc: PC) throws {
        pc = startPc
        
        NEXT:
          do {
            let op = code[Int(pc)]
            //print("\(pc) \(ops.decode(op)) \(ops.trace(self, op))")
            
            switch ops.decode(op) {
            case .Copy:
                stack.copy(ops.Copy.count(op))
                pc += 1
            case .Drop:
                stack.drop(ops.Drop.count(op))
                pc += 1
            case .Goto:
                pc = ops.Goto.pc(op)
            case .Push:
                stack.push(tags[ops.Push.value(op)] as! Value)
                pc += 1
            case .PushNone:
                stack.push(packages.Core.NONE)
                pc += 1
            case .Stop:
                pc += 1
                return            
            case .Swap:
                vm.stack.swap()
                pc += 1
            case .Unzip:
                stack.unzip()
                pc += 1
            case .Zip:
                stack.zip()
                pc += 1
            }
            
            continue NEXT
        }
    }
}

final class EvalError: BaseError, @unchecked Sendable {}
