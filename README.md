## Intro
`sw` is a pure stack language in the Forth tradition.

An attempt to simplify some of Forth's ideas; as well as combine them with other, new ideas; without losing the essence of the language.

## Stacks

### Operations
Stack manipulators have uppercase single letter names to be 1) convenient to type and 2) easy to identify visually when reading code.

- `C`opy (a;a a)
- `P`op (a)
- `S`wap (a b;b a)

- `L`eft Shift (a b c;c a b)
- `R`ight Shift (a b c;b c a)

- `U`nzip (Pair;a b)
- `Z`ip (a b;Pair)

### Literals
`[` may be used to set up a new, empty stack; while `]` pushes the stack as a value.

```
[1 2 "hello" say [3 4] 5]
```
```
hello
```
`[[1 2 [3 4] 5]]`

## Definitions

`sw` steals a line from Forth and uses a similarly flexible mechanism for definitions, which is different enough from most other languages to deserve a thorough explanation.

One could claim the idea is more powerful than Lisp macros, definitely more flexible.

`:` expects to be positioned between an identifier and a body, which is anything  up until `;`. The body is evaluated once for every reference to the name at emit time with trailing forms in reverse order on the stack. `,` may be used to evaluate a form.

This is a constant:

```
foo: 42;
foo
```
`[42]`

And this is a macro (Observe that we're currently operating at emit time, which means that run time values can't be evaluated. We're also not declaring any arguments, which means they are expected in prefix position for macros, name before arguments.):

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


## IO
`say` may be used to print any value to standard output.

```
[1 2 3] say
```
```
1 2 3
```
`[]`

## Debugging
`dump` may be used to get a helpful string representation of any value.

```
[1 2 3] dump
```
`["[1 2 3]"]`