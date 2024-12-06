extension ops {
    struct ShiftRight {
        static func make() -> Op { encode(OpCode.ShiftRight) }
        static func dump(_ vm: VM, _ op: Op) -> String { "" }
        static func trace(_ vm: VM, _ op: Op) -> String { "" }
    }
}
