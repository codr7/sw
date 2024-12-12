define: fib (Int Int Int;Int) do:
  RC 1 >
  if: dec LCL + recall
  else: 1 = if S;
  P;

10 0 1 fib say