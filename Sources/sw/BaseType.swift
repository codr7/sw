nonisolated(unsafe) var nextTypeId: TypeId = 0
nonisolated(unsafe) var typeLookup: [TypeId:ValueType] = [:]

class BaseType<T>: CustomStringConvertible {    
    typealias Data = T

    static func == (l: BaseType<T>, r: BaseType<T>) -> Bool { l.id == r.id }   
    static func findId(_ id: TypeId) -> ValueType? { typeLookup[id] }

    var description: String { id }
    let id: String
    var parents: ValueType.Parents = []
    let typeId: TypeId

    var call: ValueType.Call? = {(vm, target, location) in vm.stack.push(target) }
    var dump: ValueType.Dump? = {(vm, value) in "\(value.data)" }
    var eq: ValueType.Eq? = nil
    var eqv: ValueType.Eq?
    var findId: ValueType.FindId? = nil
    var say: ValueType.Say? = {(vm, target) in target.dump(vm)}
    var toBit: ValueType.ToBit? = {(value) in true }

    init(_ id: String, _ parents: [any ValueType] = []) {
        self.id = id
        typeId = nextTypeId
        nextTypeId += 1

        eqv = {[self] in eq!($0, $1)}
        
        self.parents.insert(typeId)
        for p in parents { addParent(p) }
    }

    func addParent(_ parent: any ValueType) {
        for pid in parent.parents {
            parents.insert(pid)
            let p = typeLookup[pid]!
            dump = dump ?? p.dump
            eq = eq ?? p.eq
            toBit = toBit ?? p.toBit
        }
    }

    func compile(_ vm: VM,
                 _ target: Value,
                 _ arguments: inout Forms,
                 _ index: Int,
                 _ location: Location) throws {
        arguments[index] = forms.Literal(target, location)
    }

    func isDerived(from: ValueType) -> Bool { parents.contains(from.typeId) }
}
