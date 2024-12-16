extension readers {
    struct Ref: Reader {
        static let instance = Ref()
        
        func read(_ vm: VM,
                  _ input: inout Input,
                  _ output: inout Output,
                  _ location: inout Location) throws -> Bool {
            if input.peekChar() != "&" { return false }
            input.dropChar()
            let startLocation = location
            location.column += 1
            
            if !(try vm.read(&input, &output, &location)) {
                throw ReadError("Missing ref target", location)
            }

            output.append(forms.Ref(output.removeLast(), startLocation))
            return true
        }
    }
}
