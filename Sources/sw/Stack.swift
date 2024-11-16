typealias Stack = [Value]

extension Stack {
    func copy(_ n: Int) {
        for i in 0..<n { stack.push(stack.top!) } 
    }

    func drop(_ n: Int) {
        for _ in 0..<n { stack.removeLast() }
    }

    func pop() -> Value { removeLast() }
    func push(_ value: Value) { append(value) }
    func push(_ type: ValueType, _ data: Any) { push(Value(type, data)) }
    
    func swap() {
        let i = count-1
        let v = self[i]
        self[i] = self[i-1]
        self[i-1] = v
    }

    var top = {last}

    func zip() {
        let r = pop()
        let l = pop()
        push(packages.Core.pairType, (l, r))
    }
    
    func unzip() {
        let (l, r) = pop().cast(packages.Core.pairType)
        push(l)
        push(r)            
    }
}
