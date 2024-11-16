extension ops {
    struct Stop {
        static func make() -> Op { encode(OpCode.Stop) }
        static func dump(_ vm: VM, _ op: Op) -> String { "" }
        static func trace(_ vm: VM, _ op: Op) -> String { "" }
    }
}
