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

# Description This R script is used to average the variables in a shapefile area
# to run with Concepto-JULES.This is built on the CHESS dataset and will need to
# be adapted for other driving data. It is built upon:
# https://github.com/hydrosoc/rhydro_EGU18/blob/master/netCDF.pdf

# NOTE: This is meant for running on the JASMIN system and you need to be logged
# onto the cylc.jasmin.ac.uk server.


# Load in the libraries ---------------------------------------------------

require(ncdf4)
require(readr)
require(dplyr)
require(tidyr)
require(rgdal)
require(raster)
require(lubridate)
require(ggplot2)
require(sp)
require(rgeos)

# Load in the data --------------------------------------------------------

variable <- "precip"
file_location <- "C:/Users/marcu/Documents/PhD/Paper_1/ArcGIS_Work/DPhil/Changing_Landcover/Data/Base/Climate/CHESS_Driving_Data/"
file_name <- paste0("chess-met_",variable,"_gb_1km_daily_19711101-19711131.nc")
file <- paste0(file_location, file_name)

#Open the file
nc <- nc_open(file, auto_GMT = TRUE)

#print(nc) #For error solving

# Extract the dimension information ---------------------------------------

lon <- ncvar_get(nc, "x")
lat <- ncvar_get(nc, "y")
time <- ncvar_get(nc, "time")
data <- ncvar_get(nc, variable)

# Sort time units ---------------------------------------------------------

start_date <- ymd("1961-01-01") # Needs to be changed according to dataset. Code for this is below.

#timeunits <- ncatt_get(nc, "time", "units")
#timeunits$value 

dates <- start_date + days(time)

# Combine the data --------------------------------------------------------

assign(paste0(variable,"_data"), as.matrix(data,ncol = 1))

df <- cbind(expand.grid(lon,lat,dates), get(paste0(variable,"_data")))

names(df) <- c("lon","lat","date",variable)

# Conversion of variable to per day from seconds ! MAY NEED CHANGING !
df[,4] <- df[,4]*86400


# Average to the one catchment --------------------------------------------

shapefile_location <- "C:/Users/marcu/Documents/PhD/Paper_1/ArcGIS_Work/DPhil/Changing_Landcover/Data/Base/Outlines/Rivers/Catchments/Tamar/47001-Tamar"
shapefile_name <- "47001"

shapefile <- readOGR(shapefile_location, shapefile_name)

raster::extract()

brick <- brick(file)
ext <- extract(brick, shapefile, weights = TRUE, fun = mean)
head(ext)
data <- as.data.frame(t(ext))
data <- cbind(as.data.frame(dates), data)
data[,2] <- data[,2]*86400
plot(data)


#NEED TO CHANGE TO EXTRACT ALL VARIABLES

land_cover <- brick("C:/Users/marcu/Documents/PhD/Paper_1/ArcGIS_Work/DPhil/Changing_Landcover/Data/Base/JULES/Ancillary/chess_landcover_2000.nc")
land_cover_avg <- extract(land_cover, shapefile, fun = mean)

river <- brick("C:/Users/marcu/Documents/PhD/Paper_1/ArcGIS_Work/DPhil/Changing_Landcover/Data/Base/JULES/Ancillary/chess_riverparams.nc")
river_avg <- extract(river, shapefile, fun = mean)

#May need to bring in for different variables
land_frac <- brick("C:/Users/marcu/Documents/PhD/Paper_1/ArcGIS_Work/DPhil/Changing_Landcover/Data/Base/JULES/Ancillary/chess_landfrac.nc", varnames = c("lat","lon"))
frac_avg <- extract(land_frac, shapefile, fun = mean)

pdm <- brick("C:/Users/marcu/Documents/PhD/Paper_1/ArcGIS_Work/DPhil/Changing_Landcover/Data/Base/JULES/Ancillary/uk_ihdtm_topography+topoindex_1km.nc")
pdm_avg <- extract(pdm, shapefile, fun = mean)

soil <- brick("C:/Users/marcu/Documents/PhD/Paper_1/ArcGIS_Work/DPhil/Changing_Landcover/Data/Base/JULES/Ancillary/chess_soilparams_hwsd_vg.nc", nl = 9)
soil_avg <- extract(soil, nl = 9, shapefile, fun = mean)
