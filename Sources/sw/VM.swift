import Foundation
import SystemPackage

let VERSION = 5

class VM {
    var code: [Op] = []
    var loadPath: FilePath = ""
    
    let reader = readers.AnyReader(
      readers.Whitespace.instance,
      readers.I64Reader.instance,
      readers.Char.instance,
      readers.IdReader.instance,
      readers.Ref.instance,
      readers.SexprReader.instance,
      readers.StringReader.instance
    )
    
    var dos: [PC] = []
    var iters: [Iter] = []
    var pc: PC = 0
    var stack: Stack = []
    var stacks: [Stack] = []
    
    let core: packages.Core
    let char: packages.Char
    let term: packages.Term
    let user: Package
    
    var currentPackage: Package
    
    init() {
        core = packages.Core()
        char = packages.Char()
        term = packages.Term()
        user = Package("user")

        currentPackage = user
        user.bind(self, core)
        user.bind(self, char)
        user.bind(self, term)
        user.bind(self, user)

        core.initBindings(self)
        char.initBindings(self)
        term.initBindings(self)
        user.initBindings(self)
    }

    func beginPackage() {
        currentPackage = Package(currentPackage.id, currentPackage)
    }

    func beginStack() {
        stacks.append(stack)
        stack = []
    }

    func doStack(push: Bool, _ body: () throws -> Void) throws {
        beginStack()
        defer { endStack(push: push) }
        try body()
    }
    
    func endPackage() { currentPackage = currentPackage.parent! }

    func endStack(push: Bool) {
        var ns = stacks.removeLast()
        if push { ns.push(core.stackType, stack) }
        stack = ns
    }

    @discardableResult
    func emit(_ op: Op) -> PC {
        let result = emitPc
        code.append(op)
        return result
    }

    func emit(_ form: Form) throws {
        var arguments: Forms = [form]
        try arguments.emit(self)
    }

    var emitPc: PC { code.count }

    func eval(from: PC) throws {
        pc = from
        try eval()
    }
    
    func eval(to: PC) throws {
        if code.count == to {
            try eval(from: pc)
        } else {
            let prevOp = code[to]
            code[to] = .Stop
            defer { code[to] = prevOp }
            try eval(from: pc)
        }
    }

    func eval(from: PC, to: PC) throws {
        pc = from
        try eval(to: to)        
    }
    
    func load(_ path: FilePath, _ location: Location) throws {
        let prevLoadPath = loadPath
        let p = loadPath.appending("\(path)")
        loadPath.append("\(path.removingLastComponent())")
        defer { loadPath = prevLoadPath }

        if let fh = FileHandle(forReadingAtPath: "\(p)") {
            defer { try! fh.close() }
            var input = Input(try fh.readAll())
            var location = Location("\(p)")
            var fs = try read(&input, &location)
            emit(.SetLoadPath(path: loadPath))
            try fs.emit(self)
            emit(.SetLoadPath(path: prevLoadPath))
        } else {
            throw EmitError("File not found: \(p)", location)
        }
    }
    
    func read(_ input: inout Input,
              _ output: inout [Form],
              _ location: inout Location) throws -> Bool {
        try reader.read(self, &input, &output, &location)
    }

    func read(_ input: inout Input, _ location: inout Location) throws -> [Form] {
        var result: [Form] = []
        while try read(&input, &result, &location) {}
        return result
    }
}
