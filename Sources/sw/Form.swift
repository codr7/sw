protocol Form {    
    var location: Location {get}
    func dump(_ vm: VM) -> String
    func emit(_ vm: VM, _ arguments: inout Forms) throws
    func equals(_ other: Form) -> Bool
    func eval(_ vm: VM) throws
    func getType(_ vm: VM) -> ValueType?
    func getValue(_ vm: VM) -> Value?
    var isEnd: Bool {get}
    var isVoid: Bool {get}
    func tryCast<T>(_ type: T.Type) -> T?
}

extension Form {
    func eval(_ vm: VM) throws {
        let prevPc = vm.pc
        defer { vm.pc = prevPc }        
        let skipPc = vm.emit(ops.Fail.make(vm, location))
        let startPc = vm.emitPc
        try vm.emit(self)
        vm.code[skipPc] = ops.Goto.make(vm.emitPc)
        try vm.eval(from: startPc)
    }

    var isEnd: Bool { false }
    var isVoid: Bool { false }
}

class BaseForm {
    let location: Location
    init(_ location: Location) { self.location = location }
    func tryCast<T>(_ type: T.Type) -> T? {self as? T}
    func getType(_ vm: VM) -> ValueType? { nil }    
    func getValue(_ vm: VM) -> Value? { nil }
}

typealias Forms = [Form]

extension Forms {
    func dump(_ vm: VM) -> String {
        "(\(map({$0.dump(vm)}).joined(separator: " ")))"
    }

    mutating func emit(_ vm: VM) throws {
        while !isEmpty { try removeFirst().emit(vm, &self) }
    }

    func equals(_ other: Forms) -> Bool {
        if count != other.count { return false }
        
        for i in 0..<count {
            if !self[i].equals(other[i]) { return false }
        }

        return true
    }
}

final class EmitError: BaseError, @unchecked Sendable {}

struct forms {}

