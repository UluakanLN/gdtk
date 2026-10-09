filename=sphere

clean:
	rm -r config flow grid hist solid loads plot *.vtk *.svg *.dat *.eps *.log
			
prep:
	prep-gas air-11sp-gas-model.inp air-11sp-gas-model.lua
	prep-chem air-11sp-gas-model.lua GuptaEtAl-air-reactions-2T.lua air-11sp-reactions.lua
	prep-kinetics air-11sp-gas-model.lua air-11sp-energy-exchange.inp air-11sp-energy-exchange.lua
	e4shared --prep --job=${filename}

run:
	e4shared --run --job=${filename} --tindx-start=0 | tee log.txt
	#mpirun -np 8 e4mpi --run --job=${filename} --tindx-start=0 | tee log.txt

post:
	e4shared --post --job=${filename} --vtk-xml --tindx-plot=all --add-vars="molef"
