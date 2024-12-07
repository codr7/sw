## Intro
`sw` is a pure stack language, as in without support for runtime bindings. In classical Forth fashion it also doesn't have a lot of opinions on how you combine features. 

## Stacks

### Operations
Stack manipulators have uppercase single letter names to be 1) convenient to type and 2) easy to identify visually when reading code.

- `C`opy (a;;a a)
- `P`op (a)
- `S`wap (a b;;b a)

- `L`eft Shift (a b c;;c a b)
- `R`ight Shift (a b c;;b c a)

- `U`nzip (a;;b c)
- `Z`ip (a b;;c)

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
`:` may be used to bind names to values at compile time, the value needs to be terminated with `;`. 

```
foo: 42; foo
```
`42`

The body is evaluated on compile time reference with the form stream pushed on the stack, `,` may be used to evaluate forms.

```
foo: , 42 =;
```
`[]`

```
foo 7
```
`[#f]`

```
foo 42
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