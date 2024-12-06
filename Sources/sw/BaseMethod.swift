class BaseMethod: CustomStringConvertible {
    static func == (l: BaseMethod, r: BaseMethod) -> Bool { l.id == r.id }

    let id: String
    let arguments: [ValueType]

    var description: String {
        "\(id): [\(arguments.map({"\($0)"}).joined(separator: " "));\(results.map({"\($0)"}).joined(separator: " "))]"
    }
    
    var results: [ValueType]

    init(_ id: String,
         _ arguments: [ValueType],
         _ results: [ValueType]) {
        self.id = id
        self.arguments = arguments
        self.results = results
    }
}
