extension ops {
    struct Return {
        static func make() -> Op { encode(OpCode.Return) }
        static func dump(_ vm: VM, _ op: Op) -> String { "" }
        static func trace(_ vm: VM, _ op: Op) -> String { "" }
    }
}
