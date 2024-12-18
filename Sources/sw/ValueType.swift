protocol ValueType {
    typealias Parents = Set<TypeId>

    var id: String {get}
    var parents: Parents {get}

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
    
    func dump(_ vm: VM, _ value: Value) -> String
    func eq (_ value1: Value, _ value2: Value) -> Bool
    func equals(_ other: any ValueType) -> Bool 
    func findId(_ source: Value, _ id: String) -> Value?

    func toString(_ vm: VM,
                  _ target: Value,
                  _ location: Location) throws -> String
    
    func toBit(_ value: Value) -> Bit
}

extension ValueType {
    func emit(_ vm: VM,
              _ target: Value,
              _ arguments: inout Forms,
              _ location: Location) throws {
        vm.emit(.Push(value: target))
    }

    func emitId(_ vm: VM,
                _ target: Value,
                _ arguments: inout Forms,
                _ location: Location) throws {
        try emit(vm, target, &arguments, location)
    }
    
    func equals(_ other: any ValueType) -> Bool { other.id == id }

    func findId(_ source: Value, _ id: String) -> Value? {
        fatalError("Not supported")
    }

    func getType(_ vm: VM) -> ValueType? { nil }

    func toString(_ vm: VM,
                  _ target: Value,
                  _ location: Location) throws -> String { dump(vm, target) }

    func toBit(_ value: Value) -> Bit { true }
}

func ==(l: any ValueType, r: any ValueType) -> Bool { l.id == r.id }
func !=(l: any ValueType, r: any ValueType) -> Bool { l.id != r.id }

extension [ValueType] {
    func dump() -> String {
        map({"\($0.id)"}).joined(separator: " ")
    }
}
