define: fib (I64 I64 I64;I64) do:
  R C 1 >
  if: dec L C L + recall
  else: 1 = if: S;;;
  P;;

10 0 1 fib say
10000 benchmark: 80 0 1 fib P; say