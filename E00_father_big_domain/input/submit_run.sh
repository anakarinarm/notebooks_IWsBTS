#!/bin/bash
#PBS -N E00_canyon_0
#PBS -q default
#PBS -l nodes=4:ppn=5
##PBS -j oe
#PBS -o E00_canyon_0.log 
#PBS -e E00_canyon_0.err
cd $PBS_O_WORKDIR

sort -u $PBS_NODEFILE > nodes.file

module load intel/MPI2018
module load spack
module load netcdf-fortran-4.4.4-intel-18.0.1-zhe2pvi
module load netcdf-c-4.7.0-intel-18.0.1-vtkbioo

mpirun -np 20 ./mitgcmuv > runlog.txt

# mpiexec -ppn $PBS_NUM_PPN -n $PBS_NP ./mitgcmuv >| runlog.out

module load anaconda-python-3.5

/home/mitre/MITgcm/utils/python/MITgcmutils/scripts/gluemncbig -o stateGlob.nc mnc_test_*/state.*.nc
/home/mitre/MITgcm/utils/python/MITgcmutils/scripts/gluemncbig -o gridGlob.nc mnc_test_*/grid.*.nc

# /home/mitre/MITgcm/utils/python/MITgcmutils/scripts/gluemncbig -o uvelGlob.nc -v 'U' mnc_test_000*/state.*.nc

module load spack
module load nco-5.0.1-gcc-5.5.0-fo7pnxb
module load intel/cdf-bundle2017
ncks -O -4 -L 4  stateGlob.nc stateGlob_15.nc
ncks -O -4 -L 4  gridGlob.nc gridGlob_15.nc
