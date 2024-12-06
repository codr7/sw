extension ops {
    struct ShiftLeft {
        static func make() -> Op { encode(OpCode.ShiftLeft) }
        static func dump(_ vm: VM, _ op: Op) -> String { "" }
        static func trace(_ vm: VM, _ op: Op) -> String { "" }
    }
}
