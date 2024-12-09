42
42 check

42 dump
"42" check

foo: 42;
foo
42 check

is-42: (Int;Bit) , 42 =;
is-42 7 #f = check
is-42 42 #t = check

is-42: (;Int;Bit) , 42 =;
7 is-42 #f = check
42 is-42 #t = check