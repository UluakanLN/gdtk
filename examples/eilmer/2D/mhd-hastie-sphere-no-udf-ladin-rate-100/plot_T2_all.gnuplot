set term postscript eps enhanced color 20
set output "sphere_T2_all.eps"

set xlabel "time, {/Symbol m}s"
set ylabel "T2, K"

set xtic 10.0
set ytic 40000.0

plot \
"sphere_T2_269.dat" using 1:2 with linespoints pt 7 ps 0.5 lw 2 lc rgb "blue" title "ID 269", \
"sphere_T2_314.dat" using 1:2 with linespoints pt 5 ps 0.5 lw 2 lc rgb "red" title "ID 314", \
"sphere_T2_350.dat" using 1:2 with linespoints pt 9 ps 0.5 lw 2 lc rgb "green" title "ID 350"