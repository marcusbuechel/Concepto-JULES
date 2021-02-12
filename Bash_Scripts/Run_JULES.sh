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
# This is the third part of the Concepto-JULES suite of code. This is a simple
# script to run JULES using the created input from the previou scripts.

# NOTE: This is meant for running on the JASMIN system and you need to be logged
# onto the cylc.jasmin.ac.uk server.

echo -e "Concepto-JULES Script Three has begun- the great simulation!"

#Get the initial time for when this script began running
time1=$(date)

#Create the log for this script
echo -e "The Third Concepto-JULES bash script has begun running... \nfingers crossed it finishes!" >> ${base_save}Concepto-JULES/Logs/Log_Three.txt
echo  "Script started at: " ${time1} >> ${base_save}Concepto-JULES/Logs/Log_Three.txt

#Connect to the correct server if this has not been done already
ssh -AX $USER@cylc1.jasmin.ac.uk

#Change directory to the correct namelist location
cd ${base_save}Concepto-JULES/Input/JULES/Namelist

#Run the command for running JULES
rose suite-run >> ${base_save}Concepto-JULES/Logs/Log_Three.txt

echo "The simulation of Concepto-JULES has begun..."

time2=$(date)

#Save the ending time in the log
echo  "Script finished at: " $time2 >> ${base_save}Concepto-JULES/Logs/Log_Three.txt

echo "...Concepto-JULES Script Three has ended"
