extension packages.Core.iters {
    struct Range: Iter {
        var value: I64
        let end: I64?
        let stride: I64
        
        init(_ start: I64, _ end: I64?, _ stride: I64) {
            self.value = start
            self.end = end
            self.stride = stride
        }

        func dump(_ vm: VM) -> String { "Range \(value)..\((end == nil) ? "*" : "\(end!)"):\(stride)" }        

        func equals(_ other: Iter) -> Bool {
            if let o = other as? Range {
                o.value == value &&
                  o.end == end &&
                  o.stride == stride
            } else {
                false
            }  
        }

        mutating func next(_ vm: VM, _ location: Location) -> Bool {
            if end == nil || value < end! {
                vm.stack.push(vm.core.i64Type, value)
                value += stride
                return true
            }

            return false
        }
    }
}
