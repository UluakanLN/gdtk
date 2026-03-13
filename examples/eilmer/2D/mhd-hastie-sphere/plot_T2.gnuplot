set term postscript eps enhanced 20
set output "sphere_T2.eps"
set style line 1 linetype 1 linewidth 3.0
set title "History of temperature near sphere surface"
set xlabel "time, microseconds"
set ylabel "T, K"
set xtic 20.0
set ytic 10000.0
plot "sphere_T2.dat" using 1:2 title "10x40 + 30x40" 