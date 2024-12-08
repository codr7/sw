class Package: CustomStringConvertible, Sequence {
    static func == (l: Package, r: Package) -> Bool { l.id == r.id }
    
    typealias Bindings = [String:Value]
    
    struct Iterator: IteratorProtocol {
        var package: Package
        var iterator: Bindings.Iterator
        
        init(_ package: Package) {
            self.package = package
            iterator = package.bindings.makeIterator()
        }
        
        mutating func next() -> (String, Value)? {
            if let next = iterator.next() { return next }
            if package.parent == nil { return nil }
            package = package.parent!
            iterator = package.bindings.makeIterator()
            return next()
        }
    }

    var description: String {id}
    let id: String
    var bindings: Bindings = [:]
    let parent: Package?

    subscript(id: String) -> Value? {
        get {
            return
              if let value = bindings[id] {value}
              else if parent != nil {parent![id]}
              else {nil}
        }
        
        set(value) {bindings[id] = value}
    }

    init(_ id: String) {
        self.id = id
        self.parent = nil
    }

    init(_ id: String, _ parent: Package) {
        self.id = id
        self.parent = parent
    }

    func initBindings(_ vm: VM) {}

    func bind(_ vm: VM, _ value: Method) {
        self[value.id] = Value(vm.core.methodType, value)
    }

    func bind(_ vm: VM, _ value: Package) {
        self[value.id] = Value(vm.core.packageType, value)
    }

    func bind(_ vm: VM, _ value: ValueType) {
        self[value.id] = Value(vm.core.metaType, value)
    }

    func bindMacro(_ vm: VM,
                   _ id: String,
                   _ arguments1: [ValueType],
                   _ arguments2: [ValueType],
                   _ results: [ValueType],
                   _ body: @escaping SwiftMethod.EmitBody) {
        self[id] = Value(vm.core.methodType,
                         SwiftMethod(id, arguments1, arguments2, results, body))
    }

    func bindMethod(_ vm: VM,
                    _ id: String,
                    _ arguments: [ValueType],
                    _ results: [ValueType],
                    _ body: @escaping SwiftMethod.CallBody) {
        self[id] = Value(vm.core.methodType,
                         SwiftMethod(id, arguments, [], results, body))
    }

    var ids: [String] { Array(bindings.keys) }
    
    func importFrom(_ source: Package, _ ids: [String]) {
        for id in ids { bindings[id] = source[id] }
    }
      
    func makeIterator() -> Iterator { Iterator(self) }
}

struct packages {}
