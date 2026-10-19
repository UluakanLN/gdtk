filename=sphere

clean:
	rm -r config flow grid hist solid loads plot *.vtk *.svg *.dat *.eps *.txt
			
prep:
	prep-gas air-11sp-gas-model.inp air-11sp-2T.gas
	prep-chem air-11sp-2T.gas GuptaEtAl-air-2T.lua air-11sp-20r-2T.chem
	prep-kinetics air-11sp-2T.gas air-11sp-20r-2T.chem air-VT-energy-exchange.lua air-VT.exch
	e4shared --prep --job=${filename}

run:
	mpirun -np 8 e4mpi --run --job=${filename} --tindx-start=0 | tee log.txt
	#e4shared --run --job=${filename} --tindx-start=0 | tee log.txt
post:
	e4shared --post --job=${filename} --vtk-xml --tindx-plot=all --add-vars="molef"
