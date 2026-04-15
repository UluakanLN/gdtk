set term postscript eps enhanced 20
set output "sphere_p.eps"
set style line 1 linetype 1 linewidth 3.0
set title "History of pressure near sphere surface"
set xlabel "time, microseconds"
set ylabel "p, Pa"
set xtic 20.0
set ytic 10000.0
plot "sphere_p.dat" using 1:2 