#!/bin/bash
# plot.sh
# Plot pressure against the previously computed high-res data
#
# The data file name will change depending on grid sizing used


#=================================================================================
# cell ID 269 
#=================================================================================

# extract history data to dat files
awk -f p-history.awk hist/sphere-blk-0-cell-269.dat.0>sphere_p_269.dat

awk -f T-history.awk hist/sphere-blk-0-cell-269.dat.0>sphere_T1_269.dat

awk -f Tev-history.awk hist/sphere-blk-0-cell-269.dat.0>sphere_T2_269.dat

awk -f massf-Ar-history.awk hist/sphere-blk-0-cell-269.dat.0>sphere_massf-Ar_269.dat

awk -f massf-Ar+-history.awk hist/sphere-blk-0-cell-269.dat.0>sphere_massf-Ar+_269.dat

awk -f massf-e-history.awk hist/sphere-blk-0-cell-269.dat.0>sphere_massf-e_269.dat


#=================================================================================
# cell ID 314
#=================================================================================

# extract history data to dat files
awk -f p-history.awk hist/sphere-blk-0-cell-314.dat.0>sphere_p_314.dat

awk -f T-history.awk hist/sphere-blk-0-cell-314.dat.0>sphere_T1_314.dat

awk -f Tev-history.awk hist/sphere-blk-0-cell-314.dat.0>sphere_T2_314.dat

awk -f massf-Ar-history.awk hist/sphere-blk-0-cell-314.dat.0>sphere_massf-Ar_314.dat

awk -f massf-Ar+-history.awk hist/sphere-blk-0-cell-314.dat.0>sphere_massf-Ar+_314.dat

awk -f massf-e-history.awk hist/sphere-blk-0-cell-314.dat.0>sphere_massf-e_314.dat


#=================================================================================
# cell ID 350
#=================================================================================

# extract history data to dat files
awk -f p-history.awk hist/sphere-blk-0-cell-350.dat.0>sphere_p_350.dat

awk -f T-history.awk hist/sphere-blk-0-cell-350.dat.0>sphere_T1_350.dat

awk -f Tev-history.awk hist/sphere-blk-0-cell-350.dat.0>sphere_T2_350.dat

awk -f massf-Ar-history.awk hist/sphere-blk-0-cell-350.dat.0>sphere_massf-Ar_350.dat

awk -f massf-Ar+-history.awk hist/sphere-blk-0-cell-350.dat.0>sphere_massf-Ar+_350.dat

awk -f massf-e-history.awk hist/sphere-blk-0-cell-350.dat.0>sphere_massf-e_350.dat


# generate plots for entire solution
gnuplot plot_p_all.gnuplot
gnuplot plot_T1_all.gnuplot
gnuplot plot_T2_all.gnuplot
gnuplot plot_massf-Ar_all.gnuplot
gnuplot plot_massf-Ar+_all.gnuplot
gnuplot plot_massf-e_all.gnuplot

# generate plots for solution up to 10 mus
gnuplot plot_p_upTo10mus.gnuplot
gnuplot plot_T1_upTo10mus.gnuplot
gnuplot plot_T2_upTo10mus.gnuplot
gnuplot plot_massf-Ar_upTo10mus.gnuplot
gnuplot plot_massf-Ar+_upTo10mus.gnuplot
gnuplot plot_massf-e_upTo10mus.gnuplot


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



