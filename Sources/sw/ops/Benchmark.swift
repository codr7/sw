extension ops {
    struct Benchmark {
        static let endPcStart = opCodeWidth
        static let endPcWidth = tagWidth

        static func endPc(_ op: Op) -> Tag { decodeTag(op, endPcStart) }

        static func make(_ vm: VM, _ endPc: PC) -> Op {
            encode(OpCode.Benchmark) + encodeTag(vm.tag(endPc), endPcStart)
        }
        static func dump(_ vm: VM, _ op: Op) -> String { "" }
        static func trace(_ vm: VM, _ op: Op) -> String { "" }
    }
}
