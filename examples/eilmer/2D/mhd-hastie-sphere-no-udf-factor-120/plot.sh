#!/bin/bash
# plot.sh
# Plot pressure against the previously computed high-res data
#
# The data file name will change depending on grid sizing used


#=================================================================================
# cell ID 161 
#=================================================================================

# extract history data to dat files
awk -f p-history.awk hist/sphere-blk-0-cell-161.dat.0>sphere_p_161.dat

awk -f T-history.awk hist/sphere-blk-0-cell-161.dat.0>sphere_T1_161.dat

awk -f Tev-history.awk hist/sphere-blk-0-cell-161.dat.0>sphere_T2_161.dat

awk -f massf-Ar-history.awk hist/sphere-blk-0-cell-161.dat.0>sphere_massf-Ar_161.dat

awk -f massf-Ar+-history.awk hist/sphere-blk-0-cell-161.dat.0>sphere_massf-Ar+_161.dat

awk -f massf-e-history.awk hist/sphere-blk-0-cell-161.dat.0>sphere_massf-e_161.dat


#=================================================================================
# cell ID 188
#=================================================================================

# extract history data to dat files
awk -f p-history.awk hist/sphere-blk-0-cell-188.dat.0>sphere_p_188.dat

awk -f T-history.awk hist/sphere-blk-0-cell-188.dat.0>sphere_T1_188.dat

awk -f Tev-history.awk hist/sphere-blk-0-cell-188.dat.0>sphere_T2_188.dat

awk -f massf-Ar-history.awk hist/sphere-blk-0-cell-188.dat.0>sphere_massf-Ar_188.dat

awk -f massf-Ar+-history.awk hist/sphere-blk-0-cell-188.dat.0>sphere_massf-Ar+_188.dat

awk -f massf-e-history.awk hist/sphere-blk-0-cell-188.dat.0>sphere_massf-e_188.dat


#=================================================================================
# cell ID 210
#=================================================================================

# extract history data to dat files
awk -f p-history.awk hist/sphere-blk-0-cell-210.dat.0>sphere_p_210.dat

awk -f T-history.awk hist/sphere-blk-0-cell-210.dat.0>sphere_T1_210.dat

awk -f Tev-history.awk hist/sphere-blk-0-cell-210.dat.0>sphere_T2_210.dat

awk -f massf-Ar-history.awk hist/sphere-blk-0-cell-210.dat.0>sphere_massf-Ar_210.dat

awk -f massf-Ar+-history.awk hist/sphere-blk-0-cell-210.dat.0>sphere_massf-Ar+_210.dat

awk -f massf-e-history.awk hist/sphere-blk-0-cell-210.dat.0>sphere_massf-e_210.dat


# generate plots
gnuplot plot_p_all.gnuplot
gnuplot plot_T1_all.gnuplot
gnuplot plot_T2_all.gnuplot
gnuplot plot_massf-Ar_all.gnuplot
gnuplot plot_massf-Ar+_all.gnuplot
gnuplot plot_massf-e_all.gnuplot


#-------------------------------------------------------------------------------------
#awk -f p-history.awk hist/sphere-blk-0-cell-161.dat.0>sphere_p_161.dat
#gnuplot plot_p_161.gnuplot

#awk -f T-history.awk hist/sphere-blk-0-cell-161.dat.0>sphere_T1_161.dat
#gnuplot plot_T1_161.gnuplot

#awk -f Tev-history.awk hist/sphere-blk-0-cell-161.dat.0>sphere_T2_161.dat
#gnuplot plot_T2_161.gnuplot

#awk -f p-history.awk hist/sphere-blk-0-cell-188.dat.0>sphere_p_188.dat
#gnuplot plot_p_188.gnuplot

#awk -f T-history.awk hist/sphere-blk-0-cell-188.dat.0>sphere_T1_188.dat
#gnuplot plot_T1_188.gnuplot

#awk -f Tev-history.awk hist/sphere-blk-0-cell-188.dat.0>sphere_T2_188.dat
#gnuplot plot_T2_188.gnuplot

#awk -f p-history.awk hist/sphere-blk-0-cell-210.dat.0>sphere_p_210.dat
#gnuplot plot_p_210.gnuplot

#awk -f T-history.awk hist/sphere-blk-0-cell-210.dat.0>sphere_T1_210.dat
#gnuplot plot_T1_210.gnuplot

#awk -f Tev-history.awk hist/sphere-blk-0-cell-210.dat.0>sphere_T2_210.dat
#gnuplot plot_T2_210.gnuplot



