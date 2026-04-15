set term postscript eps enhanced color 20
set output "sphere_massf-e_all.eps"
set key top right

set xlabel "time, {/Symbol m}s"
set ylabel "massf-e"

set xtic 10.0
set ytic 0.00000005

plot \
"sphere_massf-e_269.dat" using 1:2 with linespoints pt 7 ps 0.5 lw 2 lc rgb "blue" title "ID 269", \
"sphere_massf-e_314.dat" using 1:2 with linespoints pt 5 ps 0.5 lw 2 lc rgb "red" title "ID 314", \
"sphere_massf-e_350.dat" using 1:2 with linespoints pt 9 ps 0.5 lw 2 lc rgb "green" title "ID 350"