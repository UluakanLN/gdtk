set term postscript eps enhanced color 20
set output "sphere_massf-Ar_upTo10mus.eps"
set key bottom left

set xlabel "time, {/Symbol m}s"
set ylabel "massf-Ar"

set xtic 1.0
set ytic 0.005

plot \
"sphere_massf-Ar_269.dat" using ($1<=15 ? $1 : 1/0):2 with linespoints pt 7 ps 0.5 lw 2 lc rgb "blue" title "ID 269", \
"sphere_massf-Ar_314.dat" using ($1<=15 ? $1 : 1/0):2 with linespoints pt 5 ps 0.5 lw 2 lc rgb "red" title "ID 314", \
"sphere_massf-Ar_350.dat" using ($1<=15 ? $1 : 1/0):2 with linespoints pt 9 ps 0.5 lw 2 lc rgb "green" title "ID 350"