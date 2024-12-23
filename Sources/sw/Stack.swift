typealias Stack = [Value]

extension Stack {
    var top: Value {last!}

    mutating func copy(_ n: Int) {
        for _ in 0..<n { push(top) } 
    }

    mutating func drop(_ n: Int) { self = dropLast(n) }

    func dump(_ vm: VM) -> String {
        "[\(self.map({$0.dump(vm)}).joined(separator: " "))]"
    }

    mutating func pop() -> Value { removeLast() }
    mutating func push(_ value: Value) { append(value) }
    
    mutating func push<TT, T>(_ type: TT, _ data: T)
      where TT: BaseType<T>, TT: ValueType { push(Value(type, data)) }

    mutating func put(_ value: Value, _ i: Int = 0) {
        self[count-i-1] = value
    }
    
    mutating func put<TT, T>(_ type: TT, _ data: T, _ i: Int = 0)
      where TT: BaseType<T>, TT: ValueType { put(Value(type, data), i) }

    func toString(_ vm: VM, _ location: Location) throws -> String {
        "\(try map({try $0.toString(vm, location)}).joined(separator: ""))"
    }
    
    mutating func shiftLeft() { insert(pop(), at: count-2) }
    mutating func shiftRight() { push(remove(at: count-3)) }
    mutating func swap() { swapAt(count-1, count-2) }

    mutating func zip(_ vm: VM) {
        let r = pop()
        let l = pop()
        push(vm.core.pairType, (l, r))
    }
    
    mutating func unzip(_ vm: VM) {
        let (l, r) = pop().cast(vm.core.pairType)
        push(l)
        push(r)            
    }
}
