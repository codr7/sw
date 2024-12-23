define: queen  \Q;
define: king   \K;
define: rook   \R;
define: bishop \B;
define: knight \K;
define: pawn   \P;

define: columns [\a \b \c \d \e \f \g \h];
define: rows [8 7 6 5 4 3 2 1];

define: make-board [
  rook   #f Z
  knight #f Z
  bishop #f Z
  king   #f Z
  queen  #f Z
  bishop #f Z
  knight #f Z
  rook   #f Z

  pawn #f Z
  pawn #f Z
  pawn #f Z
  pawn #f Z
  pawn #f Z
  pawn #f Z
  pawn #f Z
  pawn #f Z

  pawn #t Z
  pawn #t Z
  pawn #t Z
  pawn #t Z
  pawn #t Z
  pawn #t Z
  pawn #t Z
  pawn #t Z

  rook   #t Z
  knight #t Z
  bishop #t Z
  king   #t Z
  queen  #t Z
  bishop #t Z
  knight #t Z
  rook   #t Z
];

1 1 term/move-to
columns for: term/print;
term/line-break

1 2 term/move-to

0 rows count 1 range for:
  rows S get term/print
  term/line-break;

term/flush