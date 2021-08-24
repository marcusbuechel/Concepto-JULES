# -*- coding: utf-8 -*-
"""
Created on Fri Aug 20 16:46:28 2021

@author: marcu
"""

#Reproject shapefile

import sys
import os
import geopandas


path= sys.argv[1]
file_in= '47001.shp'
file_out='Basin.shp'
data = geopandas.read_file(path+file_in)
# change CRS to epsg 4326
data = data.to_crs(epsg=4277)
# write shp file
data.to_file(path+file_out)
