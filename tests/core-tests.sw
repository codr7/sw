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

define: is-42 (I64;Bit) do: 42 do: =;;
7 is-42
[#f] check

42 is-42
[#t] check

define: repeat (I64;I64) do: dec CC if: recall;;;
3 repeat
[2 1 0 0] check

"ab" &char/up map
next S next S next
[\A \B #_] check
