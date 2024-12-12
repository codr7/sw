extension ops {
    struct CopyShiftLeft {
        static func make() -> Op { encode(OpCode.CopyShiftLeft) }
        static func dump(_ vm: VM, _ op: Op) -> String { "" }
        static func trace(_ vm: VM, _ op: Op) -> String { "" }
    }
}
