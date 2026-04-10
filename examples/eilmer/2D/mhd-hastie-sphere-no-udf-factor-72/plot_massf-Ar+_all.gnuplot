set term postscript eps enhanced color 20
set output "sphere_massf-Ar+_all.eps"
set key top left

set xlabel "time, {/Symbol m}s"
set ylabel "massf-Ar+"

set xtic 2.0
set ytic 0.005

plot \
"sphere_massf-Ar+_161.dat" using 1:2 with linespoints pt 7 ps 0.5 lw 2 lc rgb "blue" title "ID 161", \
"sphere_massf-Ar+_188.dat" using 1:2 with linespoints pt 5 ps 0.5 lw 2 lc rgb "red" title "ID 188", \
"sphere_massf-Ar+_210.dat" using 1:2 with linespoints pt 9 ps 0.5 lw 2 lc rgb "green" title "ID 210"