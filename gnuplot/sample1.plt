set encoding utf8
set title "this is gnupot test plot" font "Meiryo,20"
# plot sin(x)/x title "sin/x"
plot sin(x)*100 title "sin"

set xrange [-100:100]
set yrange [-100:100]
set ytics 20
set xtics 5

set terminal png
set output "samplt.png"
replot

