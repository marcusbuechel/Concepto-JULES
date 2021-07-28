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
file_name <- paste0("chess-met_",variable,"_gb_1km_daily_19610101-19610131.nc")
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
ext <- extract(brick, shapefile, fun = "mean")
head(ext)
plot(ext)
ext <- as.data.frame(ext)
data <-t(ext[1,])
data <- cbind(dates, data)
head(data)
