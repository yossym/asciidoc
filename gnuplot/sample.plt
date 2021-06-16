
set encoding utf8
set title "this is gnupot test plot" font "Meiryo,20"

set xrange [-10:10]
set yrange [-10:10]
set ytics 20
set xtics 5


plot "sample.txt" using 2:3 with lines title "hoge"\
,"sample.txt" using 1:2 title "fuga"
