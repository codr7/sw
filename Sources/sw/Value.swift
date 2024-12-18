struct Value: Equatable {
    static func ==(l: Value, r: Value) -> Bool { l.eq(r) }

    let data: Any
    let type: any ValueType

    init<TT, T>(_ type: TT, _ data: T) where TT: BaseType<T>, TT: ValueType {
        self.type = type
        self.data = data
    }

    func cast<T, TT>(_ _: TT) -> T where TT: BaseType<T> { data as! T }
    func tryCast<T, TT>(_ _: TT) -> T? where TT: BaseType<T> { data as? T }
    func dump(_ vm: VM) -> String { type.dump(vm, self) }

    func emit(_ vm: VM,
              _ arguments: inout Forms,
              _ location: Location) throws {
        try type.emit(vm, self, &arguments, location)
    } 

    func emitId(_ vm: VM,
                _ arguments: inout Forms,
                _ location: Location) throws {
        try type.emitId(vm, self, &arguments, location)
    }
    
    func eq(_ other: Value) -> Bool {
        type.equals(other.type) && type.eq(self, other)
    }
    
    func findId(_ id: String) -> Value? { type.findId(self, id) }
    func toBit() -> Bit { type.toBit(self) }

    func toString(_ vm: VM, _ location: Location) throws -> String {
        try type.toString(vm, self, location)
    }
}
