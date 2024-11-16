extension ops {
    struct Push {
        static let valueStart = opCodeWidth
        static let valueWidth = tagWidth

        static func value(_ op: Op) -> Tag { decodeTag(op, valueStart) }
        
        static func make(_ vm: VM, _ value: Value) -> Op {
            if value == packages.Core.NONE { PushNone.make() }
            else { encode(OpCode.Push) + encodeTag(vm.tag(value), valueStart); }
        }

        static func dump(_ vm: VM, _ op: Op) -> String {
            "value: \((vm.tags[value(op)] as! Value).dump(vm))"
        }

        static func trace(_ vm: VM, _ op: Op) -> String {
            "value: \((vm.tags[value(op)] as! Value).dump(vm))"
        }
    }
}
