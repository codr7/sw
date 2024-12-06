struct Value: Equatable {
    static func ==(l: Value, r: Value) -> Bool { l.eqv(r) }

    let data: Any
    let type: any ValueType

    init<TT, T>(_ type: TT, _ data: T) where TT: BaseType<T>, TT: ValueType {
        self.type = type
        self.data = data
    }

    func call(_ vm: VM, _ location: Location) throws {
        try type.call!(vm, self, location)
    }
 
    func cast<T, TT>(_ _: TT) -> T where TT: BaseType<T> { data as! T }

    func tryCast<T, TT>(_ _: TT) -> T? where TT: BaseType<T> { data as? T }

    func compile(_ vm: VM,
                 _ arguments: inout Forms,
                 _ index: Int) throws { try type.compile(vm, self, &arguments, index) }

    func dump(_ vm: VM) -> String { type.dump!(vm, self) }

    func emit(_ vm: VM, _ arguments: inout Forms, _ location: Location) throws {
        try type.emit(vm, self, &arguments, location)
    } 

    func emitId(_ vm: VM, _ arguments: inout Forms, _ location: Location) throws {
        try type.emitId(vm, self, &arguments, location)
    }
    
    func eq(_ other: Value) -> Bool { type.equals(other.type) && type.eq!(self, other) }
    func eqv(_ other: Value) -> Bool { type.equals(other.type) && type.eqv!(self, other) }
    func findId(_ id: String) -> Value? { type.findId!(self, id) }
    func say(_ vm: VM) -> String { type.say!(vm, self) }
    func toBit() -> Bit { type.toBit!(self) }
}
