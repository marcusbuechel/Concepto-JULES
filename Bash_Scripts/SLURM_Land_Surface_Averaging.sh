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
# This code is to average catchment land surface variables using the SLURM batch
# scheduler

#SBATCH --ntasks=1 					# just one task
#SBATCH --time=0-00:15:00 			# enough time for the job to complete
#SBATCH --partition=short-serial

#Input file locations and names. NOTE: Nornally in multiple file directories and so will have to change in future
file_location=('/home/users/mehb/input_files/' '/home/users/mehb/input_files/' '/home/users/mehb/input_files/' '/home/users/mehb/input_files/' '/home/users/mehb/input_files/' '/home/users/mehb/input_files/' '/home/users/mehb/input_files')
file_name=('chess_landcover_2000.nc' 'chess_soilparams_hwsd_vg_sclayer.nc' 'chess_landfrac.nc' 'uk_ihdtm_topography+topoindex_1km.nc' 'chess_monthly_lai.nc' 'chess_riverparams.nc' 'chess_soilparams_hwsd_vg.nc')

#Location to save the files to
save_space=/work/scratch-pw/$USER/Concepto-JULES/Input/Driving_Data/

#Get the index position for the array
offset=$SLURM_ARRAY_TASK_ID
index=$(($offset-1))

#Load in the JASPY module
module load jaspy

#Average to catchment mask
cdo -div -fldmean ${file_location[$index]}${file_name[$index]} /work/scratch-pw/$USER/Concepto-JULES/Input/Driving_Data/catchment_mask.nc ${save_space}${file_name[$index]}
