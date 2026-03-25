#!/bin/bash

prep-gas ideal-air.inp ideal-air-gas-model.lua

e4shared --prep --job=MHD-Blunt-Nose
if [ "$?" -ne "0" ] ; then
    echo "e4prep-withB ended abnormally."
fi

e4shared --run --job=MHD-Blunt-Nose --verbosity=1 --max-cpus=2
if [ "$?" -ne "0" ] ; then
    echo "e4main-withB ended abnormally."
fi

e4shared --post --job=MHD-Blunt-Nose --tindx-plot=all --vtk-xml
if [ "$?" -ne "0" ] ; then
    echo "e4post-withB ended abnormally."
fi
