extension ops {
    struct Fail {
        static let locationStart = opCodeWidth
        static let locationWidth = tagWidth
        
        static func location(_ op: Op) -> Tag {
            decodeTag(op, locationStart)
        }

        static func make(_ vm: VM, _ location: Location) -> Op {
            encode(OpCode.Fail) + encodeTag(vm.tag(location), locationStart)
        }
        
        static func dump(_ vm: VM, _ op: Op) -> String {
            "location: \(location(op))"
        }
        
        static func trace(_ vm: VM, _ op: Op) -> String {
            "\(vm.tags[location(op)] as! Location)"
        }
    }
}
