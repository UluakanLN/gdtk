filename=sphere

clean:
	rm -r config flow grid hist solid loads plot *.vtk *.svg *.dat *.eps *.txt
			
prep:
	prep-gas ideal-air.inp ideal-air-gas-model.lua
	e4shared --prep --job=${filename}

run:
	#mpirun -np 8 e4mpi --run --job=${filename} --tindx-start=0 | tee log.txt
	e4shared --run --job=${filename} --tindx-start=0 | tee log.txt
post:
	e4shared --post --job=${filename} --vtk-xml --tindx-plot=all --add-vars="molef"
