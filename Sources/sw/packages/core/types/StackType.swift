
extension packages.Core {
    class StackType: BaseType<Stack>, CountTrait, ValueType {
        var count: CountTrait.Count?

        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
            let t = self
            
            count = {(target) in target.cast(t).count}
            dump = {(vm, value) in value.cast(t).dump(vm)}
            say = {(vm, value) in value.cast(t).say(vm)}
            eq = {(value1, value2) in value1.cast(t) == value2.cast(t)}
            toBit = {(value) in !value.cast(t).isEmpty}
        }
    }
}
