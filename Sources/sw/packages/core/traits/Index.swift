extension packages.Core.traits {
    protocol Index {
        func at(_ vm: VM, _ target: Value, _ i: Value) -> Value
    }
}
