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

#Set the base directory
base_save=/work/scratch-pw/$USER/Concepto-JULES/

#Set the meteorological data file
meteo_data=/group_workspaces/jasmin2/jules_bd/data/CHESS_v1.2/met_uncompressed/ 
