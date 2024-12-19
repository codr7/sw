42
[42] check

42 dump
["42"] check

7 42 CC
[7 42 42 42] check

1 #t if: 2 3; 4
[1 2 3 4] check

1 #f if: 2 3; 4
[1 4] check

1 #t if: 2 else: 3 4;; 5
[1 2 5] check

1 #f if: 2 else: 3 4;; 5
[1 3 4 5] check

1 #t if: #f if: 2 else: 3;;; 4
[1 3 4] check

define: foo 42;
foo
[42] check

define: is-42 (I64;Bit) , 42 =; is-42 7
[#f] check

is-42 42
[#t] check

define: is-42 (I64;Bit) do: 42 =;;
7 is-42
[#f] check

42 is-42
[#t] check

define: is-42 (I64;Bit) do: 42; do: =;;
7 is-42
[#f] check

42 is-42
[#t] check

define: repeat (I64;I64) do: dec CC if: recall;;;
3 repeat
[2 1 0 0] check

"foo" count
[3] check

[1 2 3] count
[3] check

\a char/up
[\A] check

"ab" &char/up map
next S next S next
[\A \B _] check

42 to-string
["42"] check

42 to-stack
[[42]] check 

"foo" to-stack C to-string
[[\f \o \o] "foo"] check

0 _ 1 range next S next S next S P
[0 1 2] check

"abc" 1 get
[\b] check

[1 2 3] 2 get
[3] check

[1 2 3] for: dec;
[0 1 2] check