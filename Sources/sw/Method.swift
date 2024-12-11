protocol Method {
    var arguments: [ValueType] {get}
    func emit(_ vm: VM, _ arguments: inout Forms, _ location: Location) throws
    var id: String {get}
    var results: [ValueType] {get}
}
