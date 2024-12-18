extension packages.Core.traits {
    protocol Index {
        func getItem(_ vm: VM, _ target: Value, _ i: Value) -> Value
    }
}
