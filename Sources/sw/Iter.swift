protocol Iter {
    func dump(_ vm: VM) -> String
    func equals(_ other: Iter) -> Bool
    mutating func next(_ vm: VM, _ location: Location) throws -> Bool
}
