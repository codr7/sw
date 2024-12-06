extension packages {
    class Core: Package {
        nonisolated(unsafe) static let anyType = AnyType("Any", [])

        nonisolated(unsafe) static let bitType = BitType("Bit", [anyType])
        nonisolated(unsafe) static let intType = IntType("Int", [anyType])
        nonisolated(unsafe) static let macroType = MacroType("Macro", [anyType])
        nonisolated(unsafe) static let metaType = MetaType("Meta", [anyType])
        nonisolated(unsafe) static let packageType = PackageType("Package", [anyType])
        nonisolated(unsafe) static let pairType = PairType("Pair", [anyType])
        nonisolated(unsafe) static let pathType = PathType("Path", [anyType])
        nonisolated(unsafe) static let stackType = StackType("Stack", [anyType])
        nonisolated(unsafe) static let stringType = StringType("String", [anyType])
        nonisolated(unsafe) static let timeType = TimeType("Time", [anyType])

        nonisolated(unsafe) static let methodType = MethodType("Method", [anyType])
        nonisolated(unsafe) static let swMethodType = SwMethodType("SwMethod", [methodType])

        nonisolated(unsafe) static let T = Value(Core.bitType, true)
        nonisolated(unsafe) static let F = Value(Core.bitType, false)

        override func initBindings(_ vm: VM) {
            bind(Core.anyType)
            bind(Core.bitType)
            bind(Core.intType)
            bind(Core.macroType)
            bind(Core.metaType)
            bind(Core.methodType)
            bind(Core.packageType)
            bind(Core.pairType)
            bind(Core.pathType)
            bind(Core.stackType)
            bind(Core.stringType)
            bind(Core.swMethodType)
            bind(Core.timeType)
            
            self["T"] = Core.T
            self["F"] = Core.F
        }
    }
}
