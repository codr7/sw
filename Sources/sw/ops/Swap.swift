extension ops {
    struct Swap {
        static func make() -> Op { encode(OpCode.Swap) }
        static func dump(_ vm: VM, _ op: Op) -> String { "" }
        static func trace(_ vm: VM, _ op: Op) -> String { "" }
    }
}
