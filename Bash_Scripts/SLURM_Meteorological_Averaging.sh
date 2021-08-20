#!/bin/bash
################################################################################
#   _____                           _
#  / ____|                         | |
# | |     ___  _ __   ___ ___ _ __ | |_ ___    ______
# | |    / _ \| '_ \ / __/ _ \ '_ \| __/ _ \  |______|
# | |___| (_) | | | | (_|  __/ |_) | || (_) |
#  \_____\___/|_| |_|\___\___| .__/ \__\___/
#                            | |
#                            |_|
#        _ _    _ _      ______  _____
#       | | |  | | |    |  ____|/ ____|
#       | | |  | | |    | |__  | (___
#   _   | | |  | | |    |  __|  \___ \
#  | |__| | |__| | |____| |____ ____) |
#   \____/ \____/|______|______|_____/
#
################################################################################
# Author: Marcus Buechel
# Contact: marcus.buechel@ouce.ox.ac.uk

# Description
# This code is to average catchment variables using the SLURM batch scheduler

#SBATCH --ntasks=1 					# just one task
#SBATCH --time=0-00:15:00 			# enough time for the job to complete
#SBATCH --partition=short-serial

#Load in the module JASPY on JASMIN to make the catchment averaged files
module load jaspy

#Set the meteorological data file
meteo_data=/gws/nopw/j04/hydro_jules/data/uk/driving_data/chess/chess-met/daily
cd $meteo_data

#Where to save the outputs to
save_space=/work/scratch-pw/$USER/Concepto-JULES/Input/Driving_Data/

#Variable name
variable_name=chess_${variable}_

#Chain of text for combining files
files_to_combine=""
for year in ${years[@]}
do
  files_to_combine+="${variable_name}${year}* "
done

#Notes: https://code.mpimet.mpg.de/boards/1/topics/7767
#Merge all the files together by one file
ncrcat ${files_to_combine} ${save_space}${variable_name}_complete.nc

#Divide by mask and then find the zonal average for the catchment area
cdo -div -fldmean ${save_space}${variable_name}_complete.nc /work/scratch-pw/$USER/Concepto-JULES/Input/Driving_Data/catchment_mask.nc /work/scratch-pw/$USER/Concepto-JULES/Input/Driving_Data/${variable_name}_complete.nc.nc
