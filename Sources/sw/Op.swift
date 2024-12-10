typealias Op = UInt64;

enum OpCode: UInt8 {
    case BeginStack
    case Branch
    case CallTag
    case Check
    case Copy
    case Do
    case EndStack
    case Fail
    case Goto
    case Nop
    case Pop
    case Push
    case Return
    case Stop
    case SetLoadPath
    case ShiftLeft
    case ShiftRight
    case Swap
    case Unzip
    case Zip
}

struct ops {
    static let opCodeWidth = 6
    static let pcWidth = 20
    static let tagWidth = 20
    
    static func encode<T>(_ value: T, _ offset: Int, _ width: Int) -> Op
      where T: BinaryInteger {
        (Op(value) & ((Op(1) << width) - 1)) << offset
    }

    static func decode(_ op: Op, _ offset: Int, _ width: Int) -> Op {
        (op >> offset) & ((Op(1) << width) - 1)
    }
    
    static func encode(_ value: OpCode) -> Op {
        encode(value.rawValue, 0, opCodeWidth)
    }

    static func decode(_ op: Op) -> OpCode {
        OpCode(rawValue: UInt8(decode(op, 0, opCodeWidth)))!
    }
    
    static func encodeFlag(_ value: Bool, _ offset: Int) -> Op {
        encode(value ? 1 : 0, offset, 1)
    }

    static func decodeFlag(_ op: Op, _ offset: Int) -> Bool {
        decode(op, offset, 1) == 1
    }

    static func encodePc(_ value: PC, _ offset: Int) -> Op {
        encode(value, offset, pcWidth)
    }

    static func decodePc(_ op: Op, _ offset: Int) -> PC {
        PC(decode(op, offset, pcWidth))
    }
        
    static func encodeTag(_ value: Tag, _ offset: Int) -> Op {
        encode(value, offset, tagWidth)
    }

    static func decodeTag(_ op: Op, _ offset: Int) -> Tag {
        Tag(decode(op, offset, tagWidth))
    }

    static func dump(_ vm: VM, _ op: Op) -> String {
        switch decode(op) {
        case .BeginStack:
            BeginStack.dump(vm, op)
        case .Branch:
            Branch.dump(vm, op)
        case .CallTag:
            CallTag.dump(vm, op)
        case .Check:
            Check.dump(vm, op)
        case .Copy:
            Copy.dump(vm, op)
        case .Do:
            Do.dump(vm, op)
        case .EndStack:
            EndStack.dump(vm, op)
        case .Fail:
            Fail.dump(vm, op)
        case .Goto:
            Goto.dump(vm, op)
        case .Nop:
            Nop.dump(vm, op)
        case .Pop:
            Pop.dump(vm, op)
        case .Push:
            Push.dump(vm, op)
        case .Return:
            Return.dump(vm, op)
        case .SetLoadPath:
            SetLoadPath.dump(vm, op)
        case .ShiftLeft:
            ShiftLeft.dump(vm, op)
        case .ShiftRight:
            ShiftRight.dump(vm, op)
        case .Stop:
            Stop.dump(vm, op)
        case .Swap:
            Swap.dump(vm, op)
        case .Unzip:
            Unzip.dump(vm, op)
        case .Zip:
            Zip.dump(vm, op)
        }
    }

    static func trace(_ vm: VM, _ op: Op) -> String {
        switch decode(op) {
        case .BeginStack:
            BeginStack.trace(vm, op)
        case .Branch:
            Branch.trace(vm, op)
        case .CallTag:
            CallTag.trace(vm, op)
        case .Check:
            Check.trace(vm, op)
        case .Copy:
            Copy.trace(vm, op)
        case .Do:
            Do.trace(vm, op)
        case .EndStack:
            EndStack.trace(vm, op)
        case .Fail:
            Fail.trace(vm, op)
        case .Goto:
            Goto.trace(vm, op)
        case .Nop:
            Nop.trace(vm, op)
        case .Pop:
            Pop.trace(vm, op)
        case .Push:
            Push.trace(vm, op)
        case .Return:
            Return.trace(vm, op)
        case .SetLoadPath:
            SetLoadPath.trace(vm, op)
        case .ShiftLeft:
            ShiftLeft.trace(vm, op)
        case .ShiftRight:
            ShiftRight.trace(vm, op)
        case .Stop:
            Stop.trace(vm, op)
        case .Swap:
            Swap.trace(vm, op)
        case .Unzip:
            Unzip.trace(vm, op)
        case .Zip:
            Zip.trace(vm, op)
        }    
    }
}
