## Stacks

### Stack Operations
`sw` is a pure stack machine. Stack manipulators have uppercase single letter names to be 1) convenient to type and 2) easy to identify visually when reading code.

- `C`opy [a; a a]
- `P`op [a;]
- `S`wap [a b; b a]

- `L`eft Shift [a b c; c a b]
- `R`ight Shift [a b c; b c a]

- `U`nzip [a; b c]
- `Z`ip [a b; c]

### Literals
`[` may be used to set up a new, empty stack; while `]` pushes the stack as a value.

```
[1 2 "hello" say [3 4] 5]
```
```
hello
```
`[[1 2 [3 4] 5]]`