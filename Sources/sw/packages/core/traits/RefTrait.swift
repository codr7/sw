extension packages.Core.traits {
    protocol Ref {
        func makeRef(_ target: Value) -> sw.Ref
    }
}