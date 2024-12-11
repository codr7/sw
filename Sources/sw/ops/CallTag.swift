extension ops {
    struct CallTag {
        static let targetStart = opCodeWidth
        static let targetWidth = tagWidth

        static let locationStart = targetStart + targetWidth
        static let locationWidth = tagWidth

        static func target(_ op: Op) -> Tag { decodeTag(op, targetStart) }
        static func location(_ op: Op) -> Tag { decodeTag(op, locationStart) }

        static func make(_ vm: VM,
                         _ target: SwiftMethod,
                         _ location: Location) -> Op {
            encode(OpCode.CallTag) +
              encodeTag(vm.tag(target), targetStart) +
              encodeTag(vm.tag(location), locationStart)
        }

        static func dump(_ vm: VM, _ op: Op) -> String {
            "target: \(target(op)) location: \(location(op))"
        }

        static func trace(_ vm: VM, _ op: Op) -> String {
            "target: \(vm.tags[target(op)] as! SwiftMethod) location: \(vm.tags[location(op)] as! Location)"
        }
    }
}
