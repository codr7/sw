extension ops {
    struct BeginStack {
        static func make() -> Op { encode(OpCode.BeginStack) }
        static func dump(_ vm: VM, _ op: Op) -> String { "" }
        static func trace(_ vm: VM, _ op: Op) -> String { "" }
    }
}
