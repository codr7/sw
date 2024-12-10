protocol ValueType {
    typealias Parents = Set<TypeId>

    var id: String {get}

    typealias Call = (_ vm: VM, _ target: Value, _ location: Location) throws -> Void
    var call: Call? {get}
    
    typealias Dump = (_ vm: VM, _ value: Value) -> String
    var dump: Dump? {get}

    func emit(_ vm: VM,
              _ target: Value,
              _ arguments: inout Forms,
              _ location: Location) throws
    
    func emitId(_ vm: VM,
                _ target: Value,
                _ arguments: inout Forms,
                _ location: Location) throws

    func getType(_ vm: VM) -> ValueType?
    func isDerived(from: ValueType) -> Bool
    var typeId: TypeId {get}
    
    typealias Eq = (_ value1: Value, _ value2: Value) -> Bool
    var eq: Eq? {get}
    
    typealias Eqv = (_ value1: Value, _ value2: Value) -> Bool
    var eqv: Eqv? {get}

    func equals(_ other: any ValueType) -> Bool 
    var parents: Parents {get}

    typealias FindId = (_ source: Value, _ id: String) -> Value?
    var findId: FindId? {get}

    typealias Say = (_ vm: VM, _ target: Value) -> String
    var say: Say? {get}
    
    typealias ToBit = (_ value: Value) -> Bit
    var toBit: ToBit? {get}
}

extension ValueType {
    func call(_ vm: VM, _ target: Value, _ location: Location) {
        vm.stack.push(target)
    }
    
    func emit(_ vm: VM,
              _ target: Value,
              _ arguments: inout Forms,
              _ location: Location) throws {
        vm.emit(ops.Push.make(vm, target))
    }

    func emitId(_ vm: VM,
                _ target: Value,
                _ arguments: inout Forms,
                _ location: Location) throws {
        try emit(vm, target, &arguments, location)
    }
    
    func equals(_ other: any ValueType) -> Bool { other.id == id }
    func getType(_ vm: VM) -> ValueType? { nil }
}

func ==(l: any ValueType, r: any ValueType) -> Bool { l.id == r.id }
func !=(l: any ValueType, r: any ValueType) -> Bool { l.id != r.id }

extension [ValueType] {
    func dump() -> String {
        map({"\($0.id)"}).joined(separator: " ")
    }
}
