extension readers {
    struct SexprReader: Reader {
        static let instance = SexprReader()
        
        func read(_ vm: VM,
                  _ input: inout Input,
                  _ output: inout Output,
                  _ location: inout Location) throws -> Bool {
            if input.peekChar() != "(" { return false }
            input.dropChar()
            let startLocation = location
            location.column += 1
            var body: Forms = []
            
            while true {
                Whitespace.instance.read(vm, &input, &output, &location)
                let c = input.peekChar()

                if c == ")" {
                    location.column += 1
                    input.dropChar()
                    break
                }

                if try c == nil || !vm.read(&input, &body, &location) {
                    throw ReadError("Unexpected end of sexpr", location)
                }
            }

            output.append(forms.Sexpr(body, startLocation))
            return true
        }
    }
}
