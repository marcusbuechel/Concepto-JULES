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
# This is the first part of the bash scripts used to run distributed catchments
# as a single point in JULES. In this script, the folder structure is created
# for the user to create a Concepto-JULES run.

# NOTE: This is meant for running on the JASMIN system and you need to be logged
# onto the cylc.jasmin.ac.uk server.

#Opening speel for the code to run
echo "
   _____                           _
  / ____|                         | |
 | |     ___  _ __   ___ ___ _ __ | |_ ___    ______
 | |    / _ \| '_ \ / __/ _ \ '_ \| __/ _ \  |______|
 | |___| (_) | | | | (_|  __/ |_) | || (_) |
  \_____\___/|_| |_|\___\___| .__/ \__\___/
                            | |
                            |_|

                            _ _    _ _      ______  _____
                           | | |  | | |    |  ____|/ ____|
                           | | |  | | |    | |__  | (___
                       _   | | |  | | |    |  __|  \___  |
                      | |__| | |__| | |____| |____ ____) |
                       \____/ \____/|______|______|_____/

Author: Marcus Buechel

"
echo "Concepto-JULES Script One has begun..."

#Get the initial time for when this script began running
time1=$(date)

#Set the base directory
base_save=/work/scratch-pw/$USER/

#Remove the existing directories if they exist
rm -rf ${base_save}Concepto-JULES/

#Make the directories
mkdir -p ${base_save}Concepto-JULES/Input/Driving_Data
mkdir -p ${base_save}Concepto-JULES/Input/JULES/Namelist
mkdir -p ${base_save}Concepto-JULES/Output/JULES_Data
mkdir ${base_save}Concepto-JULES/Output/Refined_Data
mkdir ${base_save}Concepto-JULES/Logs

#Make the first log file for the work
echo -e "The First Concepto-JULES bash script has begun running... \nfingers crossed it finishes!" >> ${base_save}Concepto-JULES/Logs/Log_One.txt
echo  "Script started at: " $time1 >> ${base_save}Concepto-JULES/Logs/Log_One.txt

#Download the base namelists
cd /work/scratch-pw/$USER/Concepto-JULES/Input/JULES/Namelist/
wget -r -np -nd https://www.dropbox.com/sh/qws4sh5vdflbz7d/AACmMEpS4myfORR6iXpEZWW0a?dl=1 -O /work/scratch-pw/$USER/Concepto-JULES/Input/JULES/Namelist/temp.zip >> ${base_save}Concepto-JULES/Logs/Log_One.txt
unzip ${base_save}Concepto-JULES/Input/JULES/Namelist/temp.zip >> ${base_save}Concepto-JULES/Logs/Log_One.txt
rm -r ${base_save}Concepto-JULES/Input/JULES/Namelist/temp.zip >> ${base_save}Concepto-JULES/Logs/Log_One.txt

#Show final time
time2=$(date)

#Add the final time to the log file
echo  "Script finished at: " $time2 >> ${base_save}Concepto-JULES/Logs/Log_One.txt

echo "...Concepto-JULES Script One has ended"
