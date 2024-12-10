extension ops {
    struct Nop {
        static func make() -> Op { encode(OpCode.Nop) }
        static func dump(_ vm: VM, _ op: Op) -> String { "" }
        static func trace(_ vm: VM, _ op: Op) -> String { "" }
    }
}
