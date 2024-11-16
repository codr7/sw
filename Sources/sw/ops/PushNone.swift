extension ops {
    struct PushNone {
        static func make(_ vm: VM, _ value: Value) -> Op { encode(OpCode.PushNone) }
        static func dump(_ vm: VM, _ op: Op) -> String { "" }
        static func trace(_ vm: VM, _ op: Op) -> String { "" }
    }
}
