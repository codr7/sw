extension ops {
    struct Zip {
        static func make() -> Op { encode(OpCode.Zip) }
        static func dump(_ vm: VM, _ op: Op) -> String { "" }
        static func trace(_ vm: VM, _ op: Op) -> String { "" }
    }
}

