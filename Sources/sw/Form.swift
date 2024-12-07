protocol Form {
    var location: Location {get}

    func compile(_ vm: VM,
                 _ arguments: inout Forms,
                 _ index: Int) throws

    func dump(_ vm: VM) -> String
    func emit(_ vm: VM, _ arguments: inout Forms) throws
    func eval(_ vm: VM) throws
    func getType(_ vm: VM) -> ValueType?
    func getValue(_ vm: VM) -> Value?
    var isNone: Bool {get}
    var isSeparator: Bool {get}
    func tryCast<T>(_ type: T.Type) -> T?
}

extension Form {
    func compile(_ vm: VM,
                 _ arguments: inout Forms,
                 _ index: Int) throws { }
    
    func eval(_ vm: VM) throws {
        let skipPc = vm.emit(ops.Stop.make())
        let startPc = vm.emitPc
        var arguments: Forms = []
        _ = try emit(vm, &arguments)
        vm.emit(ops.Stop.make())
        vm.code[skipPc] = ops.Goto.make(vm.emitPc)
        try vm.eval(startPc)
    }

    var isNone: Bool { false }
    var isSeparator: Bool { false }
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
        "\(map({$0.dump(vm)}).joined(separator: " "))"
    }
    
    mutating func emit(_ vm: VM) throws {        
        for i in 0..<count { try self[i].compile(vm, &self, i) }
        while !isEmpty { try removeFirst().emit(vm, &self) }
    }
}

final class EmitError: BaseError, @unchecked Sendable {}

struct forms {}

