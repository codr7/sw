extension readers {
    struct Char: Reader {
        static let instance = Char()
        
        func read(_ vm: VM,
                  _ input: inout Input,
                  _ output: inout Output,
                  _ location: inout Location) throws -> Bool {
            if input.peekChar() != "\\" { return false }
            input.dropChar()
            let startLocation = location
            location.column += 1
            
            if let c = input.popChar() {
                output.append(forms.Literal(Value(vm.core.charType, c),
                                            startLocation))
            } else {
                throw ReadError("Invalid char", location)
            }
            
            return true
        }
    }
}
