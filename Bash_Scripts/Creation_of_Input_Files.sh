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
# This is the second part of the bash scripts used to run distributed catchments
# as a single point in JULES. In this script, the input files required to run
# Concepto-JULES are created.

# NOTE: This is meant for running on the JASMIN system and you need to be logged
# onto the cylc.jasmin.ac.uk server.

echo -e "Concepto-JULES Script Two has begun, this may take some time as it
requires access to the short-serial queue.\nHopefully this will be as fast as
possible!"

#Get the initial time for when this script began running
time1=$(date)

#Create the log for this script
echo -e "The Second Concepto-JULES bash script has begun running... \nfingers crossed it finishes!" >> ${base_save}Concepto-JULES/Logs/Log_Two.txt
echo  "Script started at: " ${time1} >> ${base_save}Concepto-JULES/Logs/Log_Two.txt

#Set the base directory
base_save=/work/scratch-pw/$USER/Concepto-JULES/

#Set the meteorological data file
meteo_data=/group_workspaces/jasmin2/jules_bd/data/CHESS_v1.2/met_uncompressed/

echo "Getting some files for setup now..."

#Get the text catchment shapefile
wget -r -np -nd -P /work/scratch-pw/mehb/Concepto-JULES/Input/Driving_Data/ https://github.com/marcusbuechel/Concepto-JULES/blob/main/Test_Data/Tamar/47001.zip >> ${base_save}Concepto-JULES/Logs/Log_Two.txt

#Unzip the files
unzip /work/scratch-pw/mehb/Concepto-JULES/Input/Driving_Data/47001.zip -d /work/scratch-pw/mehb/Concepto-JULES/Input/Driving_Data/ >> ${base_save}Concepto-JULES/Logs/Log_Two.txt

#Load in the module JASPY on JASMIN to make the catchment averaged files
module load jaspy

#Input variables
year1=2000 >> ${base_save}Concepto-JULES/Logs/Log_Two.txt
year2=2001 >> ${base_save}Concepto-JULES/Logs/Log_Two.txt
years=($(seq $year1 $year2))
echo "Years to plot are: " >> ${base_save}Concepto-JULES/Logs/Log_Two.txt
for year in ${years[@]}
do
  echo "Year selected for enquiry: " $year >> ${base_save}Concepto-JULES/Logs/Log_Two.txt
done
catchment="47001" >> ${base_save}Concepto-JULES/Logs/Log_Two.txt

#Meteo variables to run JULES
meteo=(rsds rlds precip tas sfcWind huss dtr psurf)
echo "Meteo data to reduce: " >> ${base_save}Concepto-JULES/Logs/Log_Two.txt
for var in ${meteo[@]}
do
  echo $var >> ${base_save}Concepto-JULES/Logs/Log_Two.txt
done

echo "Base variables have been input..."
