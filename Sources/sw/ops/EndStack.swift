extension ops {
    struct EndStack {
        static func make() -> Op { encode(OpCode.EndStack) }
        static func dump(_ vm: VM, _ op: Op) -> String { "" }
        static func trace(_ vm: VM, _ op: Op) -> String { "" }
    }
}
