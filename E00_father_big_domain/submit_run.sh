#!/bin/bash
#PBS -N E00_canyon
#PBS -q memALTA 
#PBS -l nodes=1:ppn=1
##PBS -j oe
#PBS -o E00_canyon.log 
#PBS -e E00_canyon.err
cd $PBS_O_WORKDIR

sort -u $PBS_NODEFILE > nodes.file

module load intel/MPI2018
module load spack
module load netcdf-fortran-4.4.4-intel-18.0.1-zhe2pvi
module load netcdf-c-4.7.0-intel-18.0.1-vtkbioo

## CAMBIAR LOS PROCESADORES AQUI! 
mpirun -np 1 ./mitgcmuv >| runlog.out

# mpiexec -ppn $PBS_NUM_PPN -n $PBS_NP ./mitgcmuv >| runlog.out

# module load anaconda-python-3.5
# /home/mitre/MITgcm/utils/python/MITgcmutils/scripts/gluemncbig -o stateGlob.nc mnc_test_000*/state.*.nc
# /home/mitre/MITgcm/utils/python/MITgcmutils/scripts/gluemncbig -o uvelGlob.nc -v 'U' mnc_test_000*/state.*.nc
