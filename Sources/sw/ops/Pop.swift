extension ops {
    struct Pop {
        static let countStart = opCodeWidth
        static let countWidth = 8
        static func count(_ op: Op) -> Int { Int(decode(op, countStart, countWidth)) }

        static func make(_ count: Int = 1) -> Op {
            encode(OpCode.Pop) + encode(count, countStart, countWidth)
        }

        static func dump(_ vm: VM, _ op: Op) -> String { "count: \(count(op))" }
        static func trace(_ vm: VM, _ op: Op) -> String { dump(vm, op) }
    }
}
