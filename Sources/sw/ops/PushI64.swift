extension ops {
    struct PushI64 {
        static let valueStart = opCodeWidth
        static let valueWidth = opWidth - opCodeWidth

        static func value(_ op: Op) -> I64 {
	       I64(decode(op, valueStart, valueWidth))
	}
        
        static func make(_ vm: VM, _ value: I64) -> Op {
            encode(OpCode.PushI64) + encode(value, valueStart, valueWidth);
        }

        static func dump(_ vm: VM, _ op: Op) -> String {
            "value: \(value(op))"
        }

        static func trace(_ vm: VM, _ op: Op) -> String {
            "value: \(value(op))"
        }
    }
}
