import SystemPackage

enum Op {
    case BeginStack
    case Benchmark(endPc: PC)
    case Branch(elsePc: PC)
    case Call(target: SwiftMethod, location: Location)
    case Check(location: Location)
    case Copy(count: Int)
    case Do(body: Forms)
    case EndStack
    case Fail(location: Location)
    case Goto(targetPc: PC)
    case Nop
    case Pop(count: Int)
    case Push(value: Value)
    case Stop
    case SetLoadPath(path: FilePath)
    case ShiftLeft
    case ShiftRight
    case Swap
    case Unzip
    case Zip
}

