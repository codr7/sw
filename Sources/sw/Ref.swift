protocol Ref {
    func call(_ vm: VM, _ location: Location) throws
    func dump(_ vm: VM) -> String
    func equals(_ other: Ref) -> Bool
}
