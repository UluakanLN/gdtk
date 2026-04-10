set term postscript eps enhanced color 20
set output "sphere_p_all.eps"

set xlabel "time, {/Symbol m}s"
set ylabel "p, kPa"

set xtic 2.0
set ytic 15.0

plot \
"sphere_p_161.dat" using 1:2 with linespoints pt 7 ps 0.5 lw 2 lc rgb "blue" title "ID 161", \
"sphere_p_188.dat" using 1:2 with linespoints pt 5 ps 0.5 lw 2 lc rgb "red" title "ID 188", \
"sphere_p_210.dat" using 1:2 with linespoints pt 9 ps 0.5 lw 2 lc rgb "green" title "ID 210"