## Intro
`sw` is a pure stack language in the Forth tradition.

An attempt to simplify some of Forth's ideas, as well as combine them with other ideas; without losing the soul of the original language.

`sw` is designed to be embedded in Swift, which is a different game compared to Forth's origin.

## Status
`sw` is still in a very explorative phase, please mind the gaps.

### Performance

```
swift run -Xswiftc -cross-module-optimization -c=release sw benchmarks/fib.sw

0.474359397
```

```
python3 benchmarks/python/fib.py

0.0685899
```

## REPL
Launching `sw` without arguments enters the REPL.

```
$ swift run
sw5

1> "hello" say
2>
hello
```

`clear!` may be used to clear the REPL stack.

```
1> 1 2 3
2>
[1 2 3]

2> clear!
3>
[]
```

## Stacks

### Operations
Fundamental operations have uppercase single letter names to be 1) convenient to type and 2) easy to identify visually when reading code.

#### `C`opy (a; a a)
#### `P`op (a)
#### `S`wap (a b; b a)
<br/>

#### `L`eft Shift (a b c; c a b)
#### `R`ight Shift (a b c; b c a)
<br/>

#### `U`nzip (Pair; a b)
#### `Z`ip (a b; Pair)

### Literals
`[` may be used to set up a new, empty stack; while `]` pushes the current stack as a value on the previous stack.

```
[1 2 "hello" say [3 4] 5]
```
```
hello
```
`[[1 2 [3 4] 5]]`

### Conversions
`to-stack` may be used to turn any value into a stack.

```
"foo" to-stack
```
`[[\f \o \o]]`

## Strings
Double quoted values are interpreted as strings.

```
"foo"
```
`["foo"]`

### Characters
Character literals are prefixed with `\`.

```
  \a char/up
```
`[\A]`

### Conversions
`to-string` may be used to turn any value into a string.

```
[\f \o \o] to-stack
```
`["foo"]`

## Definitions

`sw` steals a line from Forth and uses a similarly flexible mechanism for definitions, which is different enough from most other languages to deserve a thorough explanation.

`define:` expects an identifier and a body, which is anything up until `;`. The body is evaluated once for every reference to the name at emit time with trailing forms in reverse order on the stack. `,` may be used to evaluate a form.

### Macros

By default, definitions are macros.

```
define: is-42 , 42 =;
```
`[]`

```
is-42 7
```
`[#f]`

```
is-42 42
```
`[#t]`

Argument lists are optional:

```
define: is-42 (Int;Bit) , 42 =;
```

### Constants
This is a constant:

```
define: foo 42;
foo
```
`[42]`

### Functions
`do` arranges for its body to be evaluated at run time in the context where the definition was referenced. 

```
define: is-42 (Int;Bit) do:
  42 =;;
  
42 is-42
```
`[#t]`

There is no limit on the number of `do`-blocks, but each needs to be terminated with `;`.

```
define: is-42 (Int;Bit)
do: 42;
do: =;;

42 is-42
```
`[#t]`

#### Recursion
`recall` may be used to trigger a tail recursive call to the currently evaluating `do`-block.

```
repeat: (Int;Int) do:
  dec CC say if recall;;
3 repeat
```
```
2
1
0
```
`[0]`

## Branches
`if:` may be used for conditional evaluation, it expends a condition on the stack and a body terminated with `;`:

```
1 #f if: 2; 3
```
`[1 3]`

`else:` may be used to evaluate code when the condition is false.

```
1 #f if: 2 else: 3;; 4
```
`[1 3 4]`

## Loops
`for:` evaluates its body with each item on stack.

```
[1 2 3] for: dec;
```
`[0 1 2]`

## IO
`say` may be used to print any value to standard output followed by a newline.

```
[1 2 3] say
```
```
1 2 3
```
`[]`

## Sexprs
Sexprs are mostly used to pass multiple forms as one argument to macros. Evaluating a sexpr results in a stack containing its forms.

```
(1 2 3)
```
`[['1 '2 '3]]`

## Testing
`check` may be used to verify the specified stack suffix.

```
1 2 3 [1 2 3] check
```
`[]`

```
1 2 3 [1 2] check
```
```
Error in repl@1:13: Check failed, actual: [2 3], expected: [1 2]
```

## Debugging
`dump` may be used to get a string representation of any value.

```
[1 2 3] dump
```
`["[1 2 3]"]`