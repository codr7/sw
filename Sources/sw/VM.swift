import Foundation
import SystemPackage

let VERSION = 1

class VM {
    var calls: [Call] = []
    var code: [Op] = []
    var loadPath: FilePath = ""
    
    let reader = readers.AnyReader(
      readers.Whitespace.instance,
      readers.IntReader.instance,
      readers.IdReader.instance,
      readers.StringReader.instance
    )
    
    var pc: PC = 0
    var stack: Stack = []
    var stacks: [Stack] = []
    var tags: [Any] = []

    let core: packages.Core
    let user: Package
    var currentPackage: Package
    
    init() {
        core = packages.Core()
        user = Package("user")
        currentPackage = user
        core.initBindings(self)
        user.initBindings(self)
    }

    func doPackage<T>(_ bodyPackage: Package?, _ body: () throws -> T) throws -> T {
        let pp = currentPackage
        currentPackage = bodyPackage ?? Package(currentPackage.id, currentPackage)
        defer { currentPackage = pp }
        return try body()
    }
    
    @discardableResult
    func emit(_ op: Op) -> PC {
        let result = emitPc
        code.append(op)
        return result
    }

    var emitPc: PC { code.count }

    func endCall() -> Call { calls.removeLast() }

    func load(_ path: FilePath, _ location: Location) throws {
        let prevLoadPath = loadPath
        let p = loadPath.appending("\(path)")
        loadPath.append("\(path.removingLastComponent())")
        defer { loadPath = prevLoadPath }

        if let fh = FileHandle(forReadingAtPath: "\(p)") {
            defer { try! fh.close() }
            var input = Input(try fh.readAll())
            var location = Location("\(p)")
            let fs = try read(&input, &location)
            emit(ops.SetLoadPath.make(self, loadPath))
            try fs.emit(self)
            emit(ops.SetLoadPath.make(self, prevLoadPath))
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

    func tag(_ value: Any) -> Tag {
        let result = tags.count
        tags.append(value)
        return result
    }
}
