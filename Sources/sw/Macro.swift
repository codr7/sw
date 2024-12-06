class Macro: CustomStringConvertible {
    typealias Body = (_ vm: VM,
                      _ arguments: [Form],
                      _ location: Location) throws -> Forms
    
    let arguments: [ValueType]
    let results: [ValueType]

    var description: String {
        "\(id):: [\(arguments.map({"\($0.id)"}).joined(separator: " "))]"
    }
    
    let body: Body
    let id: String
    
    init(_ id: String,
         _ arguments: [ValueType],
         _ results: [ValueType],
         _ body: @escaping Body) {
        self.id = id
        self.arguments = arguments
        self.results = results
        self.body = body
    }

    func emit(_ vm: VM, _ arguments: Forms, _ location: Location) throws -> Forms {
        try body(vm, arguments, location)
    }
}
