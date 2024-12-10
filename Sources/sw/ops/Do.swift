extension ops {
    struct Do {
        static let bodyStart = opCodeWidth
        static let bodyWidth = tagWidth

        static func body(_ op: Op) -> Tag {
            decodeTag(op, bodyStart)
        }

        static func make(_ vm: VM, _ body: Forms) -> Op {
            encode(OpCode.Do) + encodeTag(vm.tag(body), bodyStart);
        }

        static func dump(_ vm: VM, _ op: Op) -> String {
            "body: \(body(op))"
        }

        static func trace(_ vm: VM, _ op: Op) -> String {
            "body: \((vm.tags[body(op)] as! Forms).dump(vm))"
        }
    }
}
