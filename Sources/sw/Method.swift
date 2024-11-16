protocol Method {
    var arguments: [ValueType] {get}
    func call(_ vm: VM, _ location: Location) throws
    var id: String {get}
    var results: [ValueType] {get}
}
