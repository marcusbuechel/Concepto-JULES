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
meteo_data=/group_workspaces/jasmin2/jules_bd/data/CHESS_v1.2/met_uncompressed/
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

#https://code.mpimet.mpg.de/boards/1/topics/7767
#Merge all the files into one
ncrcat ${files_to_combine} ${save_space}${variable_name}_complete.nc
