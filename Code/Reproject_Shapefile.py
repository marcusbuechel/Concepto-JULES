# -*- coding: utf-8 -*-
"""
Created on Fri Aug 20 16:46:28 2021

@author: marcu
"""

#Reproject shapefile

from osgeo import ogr, osr
import os
import geopandas


path= 'C:/Users/marcu/Documents/PhD/Paper_1/ArcGIS_Work/DPhil/Changing_Landcover/Data/Base/Outlines/Rivers/Catchments/Tamar/47001-Tamar/'
file_in= '47001.shp'
file_out='reproj_47001.shp'
data = geopandas.read_file(path+file_in)
# change CRS to epsg 4326
data = data.to_crs(epsg=4277)
# write shp file
data.to_file(path+file_out)
