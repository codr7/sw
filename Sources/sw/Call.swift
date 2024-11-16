struct Call {
    let target: SwMethod
    let returnPc: PC
    let location: Location

    init(_ vm: VM,
         _ target: SwMethod,
         _ returnPc: PC,
         _ location: Location) {
        self.target = target
        self.returnPc = returnPc
        self.location = location
    }

    init(_ vm: VM,
         _ source: Call,
         _ target: SwMethod,
         _ location: Location) {
        self.target = target
        self.returnPc = source.returnPc
        self.location = location
    }
}
