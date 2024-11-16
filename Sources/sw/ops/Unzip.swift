extension ops {
    struct Unzip {
        static func make() -> Op { encode(OpCode.Unzip) }
        static func dump(_ vm: VM, _ op: Op) -> String { "" }
        static func trace(_ vm: VM, _ op: Op) -> String { "" }
    }
}
