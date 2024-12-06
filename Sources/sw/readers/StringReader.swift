extension readers {
    struct StringReader: Reader {
        static let instance = StringReader()
        
        func read(_ vm: VM,
                  _ input: inout Input,
                  _ output: inout Output,
                  _ location: inout Location) -> Bool {
            if input.peekChar() != "\"" { return false }
            input.dropChar()
            let startLocation = location
            location.column += 1
            var result = ""
            
            while let c = input.popChar() {
                if c == "\"" {
                    location.column += 1
                    break
                }
                
                result.append(c)
                location.column += 1
            }
            
            if result.isEmpty { return false }
            let v = Value(vm.core.stringType, result)
            output.append(forms.Literal(v, startLocation))
            return true
        }
    }
}
