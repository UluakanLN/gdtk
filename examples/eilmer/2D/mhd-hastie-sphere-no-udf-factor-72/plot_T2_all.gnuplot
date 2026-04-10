set term postscript eps enhanced color 20
set output "sphere_T2_all.eps"

set xlabel "time, {/Symbol m}s"
set ylabel "T2, K"

set xtic 2.0
set ytic 40000.0

plot \
"sphere_T2_161.dat" using 1:2 with linespoints pt 7 ps 0.5 lw 2 lc rgb "blue" title "ID 161", \
"sphere_T2_188.dat" using 1:2 with linespoints pt 5 ps 0.5 lw 2 lc rgb "red" title "ID 188", \
"sphere_T2_210.dat" using 1:2 with linespoints pt 9 ps 0.5 lw 2 lc rgb "green" title "ID 210"