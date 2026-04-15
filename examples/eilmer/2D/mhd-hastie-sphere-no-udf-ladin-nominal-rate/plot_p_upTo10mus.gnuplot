set term postscript eps enhanced color 20
set output "sphere_p_upTo10mus.eps"

set xlabel "time, {/Symbol m}s"
set ylabel "p, kPa"

set xtic 1.0
set ytic 15.0

plot \
"sphere_p_269.dat" using ($1<=15 ? $1 : 1/0):2 with linespoints pt 7 ps 0.5 lw 2 lc rgb "blue" title "ID 269", \
"sphere_p_314.dat" using ($1<=15 ? $1 : 1/0):2 with linespoints pt 5 ps 0.5 lw 2 lc rgb "red" title "ID 314", \
"sphere_p_350.dat" using ($1<=15 ? $1 : 1/0):2 with linespoints pt 9 ps 0.5 lw 2 lc rgb "green" title "ID 350"