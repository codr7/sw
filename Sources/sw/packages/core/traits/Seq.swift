extension packages.Core.traits {
    protocol Seq {
        func makeIter(_ target: Value) -> Iter
    }
}
