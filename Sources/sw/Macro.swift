class Macro: CustomStringConvertible {
    typealias Body = (_ vm: VM,
                      _ arguments: inout Forms,
                      _ location: Location) throws -> Void
    
    let arguments: [ValueType]

    var description: String {
        "\(id):[\(arguments.map({"\($0.id)"}).joined(separator: " "))]"
    }
    
    let body: Body
    let id: String
    
    init(_ id: String,
         _ arguments: [ValueType],
         _ body: @escaping Body) {
        self.id = id
        self.arguments = arguments
        self.body = body
    }

    func emit(_ vm: VM, _ arguments: inout Forms, _ location: Location) throws {
        try body(vm, &arguments, location)
    }
}
