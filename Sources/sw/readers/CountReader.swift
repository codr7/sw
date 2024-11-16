extension readers {
    struct CountReader: Reader {
        static let instance = CountReader()
        
        func read(_ vm: VM,
                  _ input: inout Input,
                  _ output: inout Output,
                  _ location: inout Location) throws -> Bool {
            if input.peekChar() != "#" { return false }
            let startLocation = location
            input.dropChar()
            location.column += 1
            if !(try vm.read(&input, &output, &location)) { throw ReadError("Invalid count", location) }
            Whitespace.instance.read(vm, &input, &output, &location)

            if input.peekChar() == ":" {
                _ = try PairReader.instance.read(vm, &input, &output, &location)
            }

            output.append(forms.Id("count", startLocstion))
            return true
        }
    }
}
