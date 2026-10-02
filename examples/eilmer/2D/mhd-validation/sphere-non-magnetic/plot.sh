#!/bin/bash
# plot.sh
# Plot pressure against the previously computed high-res data
#
# The data file name will change depending on grid sizing used

awk -f p-history.awk hist/sphere-blk-0-cell-161.dat.0>sphere_p.dat
gnuplot plot_p.gnuplot

awk -f T-history.awk hist/sphere-blk-0-cell-161.dat.0>sphere_T1.dat
gnuplot plot_T1.gnuplot

awk -f Tev-history.awk hist/sphere-blk-0-cell-161.dat.0>sphere_T2.dat
gnuplot plot_T2.gnuplot

#awk -f T-history.awk hist/sphere-blk-0-cell-210.dat.0>sphere_T2.dat
#gnuplot plot_T2.gnuplot
