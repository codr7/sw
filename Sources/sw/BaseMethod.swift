class BaseMethod: CustomStringConvertible {
    static func == (l: BaseMethod, r: BaseMethod) -> Bool { l.id == r.id }

    let id: String
    let arguments1: [ValueType]
    let arguments2: [ValueType]
    var arguments: [ValueType] {arguments2 + arguments1}

    var description: String {
        "\(id) (\(arguments1.dump());\(arguments1.dump());\(results.dump())):"
    }

    var results: [ValueType]

    init(_ id: String,
         _ arguments1: [ValueType],
         _ arguments2: [ValueType],
         _ results: [ValueType]) {
        self.id = id
        self.arguments1 = arguments1
        self.arguments2 = arguments2
        self.results = results
    }
}
