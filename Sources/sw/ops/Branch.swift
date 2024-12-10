extension ops {
    struct Branch {
        static let elsePcStart = opCodeWidth
        static let elsePcWidth = pcWidth
        
        static func elsePc(_ op: Op) -> PC { decodePc(op, elsePcStart) }

        static func make(_ elsePc: PC) -> Op {
            encode(OpCode.Branch) + encodePc(elsePc, elsePcStart)
        }
        
        static func dump(_ vm: VM, _ op: Op) -> String {
            "elsePc: \(elsePc(op))"
        }
        
        static func trace(_ vm: VM, _ op: Op) -> String { dump(vm, op) }
    }
}
