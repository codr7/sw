extension packages.Core {
    class FormType: BaseType<Form>, ValueType {
        override init(_ id: String, _ parents: [any ValueType]) {
            super.init(id, parents)
            typeLookup[typeId] = self
            let t = self
            dump = {(vm, value) in value.cast(t).dump(vm)}
            eq = {(value1, value2) -> Bool in value1.cast(t).equals(value2.cast(t))}
        }
    }
}
