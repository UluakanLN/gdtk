set term postscript eps enhanced color 20
set output "sphere_massf-Ar_all.eps"
set key bottom left

set xlabel "time, {/Symbol m}s"
set ylabel "massf-Ar"

set xtic 2.0
set ytic 0.005

plot \
"sphere_massf-Ar_161.dat" using 1:2 with linespoints pt 7 ps 0.5 lw 2 lc rgb "blue" title "ID 161", \
"sphere_massf-Ar_188.dat" using 1:2 with linespoints pt 5 ps 0.5 lw 2 lc rgb "red" title "ID 188", \
"sphere_massf-Ar_210.dat" using 1:2 with linespoints pt 9 ps 0.5 lw 2 lc rgb "green" title "ID 210"