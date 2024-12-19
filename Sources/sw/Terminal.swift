class Terminal {
    var buffer: String = ""

    @discardableResult
    func flush() -> Terminal {
        print(buffer, terminator: "")
        buffer = ""
        return self
    }

    func csi(_ args: CustomStringConvertible...) {
        buffer.append(Character(UnicodeScalar(27)))
        buffer.append("[")
        for a in args { buffer.append("\(a)") }
    }

    @discardableResult
    func clearScreen() -> Terminal {
        csi(2, "J")
        return self
    }

    @discardableResult
    func moveTo(_ x: Int, _ y: Int) -> Terminal {
        csi(y, ";", x, "H");
        return self
    }
}
