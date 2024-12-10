## Intro
`sw` is a pure stack language in the Forth tradition.

An attempt to simplify some of Forth's ideas, as well as combine them with other ideas; without losing the soul of the original language.

`sw` is designed to be embedded in Swift, which is a different game compared to Forth's origin. To me, a good approach when writing interpreters is to spend less energy pretending to be hardware and more on making good use of whatever sits below.

## Status
`sw` is still in a very explorative phase, pleae mind the gaps.

## REPL
Launching `sw` without arguments enters the REPL.

```
$ swift run
sw2

1> "hello" say
2>
hello
```

`:clear` may be used to clear the stack.

```
1> 1 2 3
2>
[1 2 3]

2> :clear
[]
```

## Stacks

### Operations
Stack operations have uppercase single letter names to be 1) convenient to type and 2) easy to identify visually when reading code.

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

## Definitions

`sw` steals a line from Forth and uses a similarly flexible mechanism for definitions, which is different enough from most other languages to deserve a thorough explanation.

`:` expects to be positioned between an identifier and a body, which is anything  up until `;`. The body is evaluated once for every reference to the name at emit time with trailing forms in reverse order on the stack. `,` may be used to evaluate a form.

### Macros

By default, definitions are macros. Also by default, macros expect to be called in prefix position, name before arguments. Since we're operating at emit time, run time values can't be evaluated.

```
is-42: , 42 =;
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

Argument lists are optional, this means exactly the same thing:

```
is-42: (Int;Bit) , 42 =;
```

Extending the argument list allows accepting arguments in postfix position. Note that arguments are shifted syntactically at read time, which is not always appropriate.

```
is-42: (Int;;Bit) , 42 =;
42 is-42
```
`[#t]`

### Constants
This is a constant:

```
foo: 42;
foo
```
`[42]`

### Functions
`do` arranges for its body to be evaluated at run time in the context where `:` was called. 

```
is-42: (Int;Bit) do 42 =;
42 is-42
```
`[#t]`

You may add as many `do`-blocks as you wish, each block needs to be terminated with `;`, the start of another `do`-block or `EOF`.

```
is-42: (Int;Bit) do 42 do =;
42 is-42
```
`[#t]`

#### Recursion
`recall` may be used to trigger a tail recursive call to the currently evaluating `do`-block.

```
repeat: (Int;Int) do C C say if dec recall;
3 repeat
```
```
3
2
1
0
```
`[0]`


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

## Debugging
`dump` may be used to get a helpful string representation of any value.

```
[1 2 3] dump
```
`["[1 2 3]"]`