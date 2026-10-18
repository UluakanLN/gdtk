#!/bin/bash
# run.sh

#e4shared-debug --run --job=sphere
mpirun -np 5 e4mpi --run --job=sphere
#e4shared --run --job=sphere --verbosity=1 --max-cpus=5
# e4shared --run --job=sphere 

# restart the simulation from a snapshot
# first write the following command under the simulation directory
# e4-prep-restart --job=my_job --snapshot=1
# this will give you the tindx value to the terminal screen of the last snapshot recorded
# then you can use that value to restart the simulation as below
# e4shared --job=my_job --run --tindx-start=9
# or if you use mpi
# mpirun -np 5 e4mpi --job=my_job --run --tindx-start=5