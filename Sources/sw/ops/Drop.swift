extension ops {
    struct Drop {
        static let countStart = opCodeWidth
        static let countWidth = 8
        static func count(_ op: Op) -> Int { Int(decode(op, countStart, countWidth)) }
        static func make(count: Int = 1) -> Op { encode(OpCode.Drop) + encode(count, countStart, countWidth) }
        static func dump(_ vm: VM, _ op: Op) -> String { "count: \(count(op))" }
        static func trace(_ vm: VM, _ op: Op) -> String { dump(vm, op) }
    }
}
