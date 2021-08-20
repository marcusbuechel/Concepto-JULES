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
meteo_data=/gws/nopw/j04/hydro_jules/data/uk/driving_data/chess/chess-met/daily

echo "Getting some files for setup now..."

#Get the text catchment shapefile NEEDS ALTERATING TO WORK
cd /work/scratch-pw/mehb/Concepto-JULES/Input/Driving_Data/
wget -r -np -nd https://www.dropbox.com/s/caft9dg74cn02kx/47001.zip?dl=1 -O /work/scratch-pw/$USER/Concepto-JULES/Input/Driving_Data/temp.zip

#Unzip the files
unzip /work/scratch-pw/$USER/Concepto-JULES/Input/Driving_Data/temp.zip >> ${base_save}Concepto-JULES/Logs/Log_Two.txt
rm -r /work/scratch-pw/$USER/Concepto-JULES/Input/Driving_Data/temp.zip >> ${base_save}Concepto-JULES/Logs/Log_Two.txt

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

echo "Creating Catchment NETCDF MASK..."

#Use GDAL to make a mask of the shapefile data
#Notes: https://disc.gsfc.nasa.gov/information/howto?title=How%20to%20Display%20a%20Shapefile-based%20Data%20Subset%20with%20GrADS
#Notes: https://gdal.org/programs/gdal_rasterize.html
gdal_rasterize -burn 1  -of netCDF /work/scratch-pw/$USER/Concepto-JULES/Input/Driving_Data/47001.shp /work/scratch-pw/$USER/Concepto-JULES/Input/Driving_Data/catchment_mask.nc

echo "Sending jobs off to the SLURM batch scheduler... " >> ${base_save}Concepto-JULES/Logs/Log_Two.txt

#NEEDS CHANGING FOR FINAL BUILD
for $var in ${meteo[@]}
do
  sbatch --export=variable=$var,dates=$years,cathment_id=$catchment --job-name=Concepto-JULES /home/users/mehb/Concepto-JULES/SLURM_Meteorological_Averaging.sh
  echo $var " sent to the SLURM Scheduler" >> ${base_save}Concepto-JULES/Logs/Log_Two.txt
done

#Report back what is running for the user
squeue --user=$USER --name=Concepto-JULES >> ${base_save}Concepto-JULES/Logs/Log_Two.txt

echo "All meteorological variables have been sent to the SLURM scheduler"

################################################################################

#Edit the JULES namelist with the needed times
sed -E -e "s/1900/${year1}/g" /work/scratch-pw/$USER/Concepto-JULES/Input/JULES/Namelist/app/jules/rose-app.conf
sed -E -e "s/1901/${year2}/g" /work/scratch-pw/$USER/Concepto-JULES/Input/JULES/Namelist/app/jules/rose-app.conf

echo "Namelist has been altered accordingly" >> ${base_save}Concepto-JULES/Logs/Log_Two.txt

#Average Land Surface Once the meteorological averaging is done
sbatch --array=1-7 --dependency=singleton --job-name=Concepto-JULES /home/users/mehb/Concepto-JULES/SLURM_Land_Surface_Averaging.sh

echo "All land surface variables have been sent to the SLURM scheduler"

#Time of script ending
time2=$(date)

#Save the ending time in the log
echo  "Script finished at: " $time2 >> ${base_save}Concepto-JULES/Logs/Log_Two.txt

echo "...Concepto-JULES Script Two has ended"
