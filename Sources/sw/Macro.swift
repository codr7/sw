class Macro: CustomStringConvertible {
    typealias Body = (_ vm: VM,
                      _ arguments: inout Forms,
                      _ location: Location) throws -> Void
    
    let arguments1: [ValueType]
    let arguments2: [ValueType]
    let results: [ValueType]
    
    var description: String {
        "\(id) (\(arguments1.dump());\(arguments2.dump());\(results.dump())):"
    }
    
    let body: Body
    let id: String
    
    init(_ id: String,
         _ arguments1: [ValueType],
         _ arguments2: [ValueType],
         _ results: [ValueType],
         _ body: @escaping Body) {
        self.id = id
        self.arguments1 = arguments1
        self.arguments2 = arguments2
        self.results = results
        self.body = body
    }

    func emit(_ vm: VM, _ arguments: inout Forms, _ location: Location) throws {
        try body(vm, &arguments, location)
    }
}
