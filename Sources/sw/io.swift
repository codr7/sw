extension FileHandle {
    func readAll() throws -> String {
        let d = try readToEnd()!
        return String(decoding: d, as: UTF8.self)
    }
}
