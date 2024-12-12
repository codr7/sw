extension ops {
    struct CopyLeft {
        static func make() -> Op { encode(OpCode.CopyLeft) }
        static func dump(_ vm: VM, _ op: Op) -> String { "" }
        static func trace(_ vm: VM, _ op: Op) -> String { "" }
    }
}
