define: fib (Int Int Int;Int) do:
  R C 1 >
  if: dec L C L + recall
  else: 1 = if: S;;;
  P;;

10000 benchmark: 40 0 1 fib; say