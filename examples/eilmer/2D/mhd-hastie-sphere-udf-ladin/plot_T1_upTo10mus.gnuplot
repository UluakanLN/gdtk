set term postscript eps enhanced color 20
set output "sphere_T1_upTo10mus.eps"
set key bottom right

set xlabel "time, {/Symbol m}s"
set ylabel "T1, K"

set xtic 1.0
set ytic 10000.0

plot \
"sphere_T1_269.dat" using ($1<=15 ? $1 : 1/0):2 with linespoints pt 7 ps 0.5 lw 2 lc rgb "blue" title "ID 269", \
"sphere_T1_314.dat" using ($1<=15 ? $1 : 1/0):2 with linespoints pt 5 ps 0.5 lw 2 lc rgb "red" title "ID 314", \
"sphere_T1_350.dat" using ($1<=15 ? $1 : 1/0):2 with linespoints pt 9 ps 0.5 lw 2 lc rgb "green" title "ID 350"