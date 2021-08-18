# -*- coding: utf-8 -*-
"""
Created on Wed Aug 18 16:40:14 2021

@author: marcu
"""

# Use of this blog: https://www.wemcouncil.org/wp/wemc-tech-blog-3-calculating-eu-country-averages-with-era5-and-nuts/
# https://medium.com/@apremgeorge/using-conda-python-environments-with-spyder-ide-and-jupyter-notebooks-in-windows-4e0a905aaac5
# import packages
import iris
import geopandas as gpd
import numpy as np
import matplotlib.pyplot as plt
import cartopy.crs as ccrs
import iris.plot as iplt
import iris.quickplot as qplt
import iris.pandas
import os

#shapefile load in
shapefile_location = "C:/Users/marcu/Documents/PhD/Paper_1/ArcGIS_Work/DPhil/Changing_Landcover/Data/Base/Outlines/Rivers/Catchments/Tamar/47001-Tamar/"
shapefile_name = "47001.shp"

shapefile =shapefile_location+ shapefile_name
shapefile=gpd.read_file(shapefile)



#cube load in 
variable ="precip"
file_location = "C:/Users/marcu/Documents/PhD/Paper_1/ArcGIS_Work/DPhil/Changing_Landcover/Data/Base/Climate/CHESS_Driving_Data/"
file_name = "chess-met_"+variable+"_gb_1km_daily_19711001-19711031.nc"
file = file_location+ file_name
cubelist=iris.load(file)
cube=cubelist[0]
cube=cube.intersection(longitude=(-180, 180))

# function to check whether data is within shapefile - source: http://bit.ly/2pKXnWa

def geom_to_masked_cube(cube, geometry, x_coord, y_coord,
                        mask_excludes=False):
    """
    Convert a shapefile geometry into a mask for a cube's data.

    Args:

    * cube:
        The cube to mask.
    * geometry:
        A geometry from a shapefile to define a mask.
    * x_coord: (str or coord)
        A reference to a coord describing the cube's x-axis.
    * y_coord: (str or coord)
        A reference to a coord describing the cube's y-axis.

    Kwargs:

    * mask_excludes: (bool, default False)
        If False, the mask will exclude the area of the geometry from the
        cube's data. If True, the mask will include *only* the area of the
        geometry in the cube's data.

    .. note::
        This function does *not* preserve lazy cube data.

    """
    # Get horizontal coords for masking purposes.
    lats = cube.coord(y_coord).points
    lons = cube.coord(x_coord).points
    lon2d, lat2d = np.meshgrid(lons,lats)

    # Reshape to 1D for easier iteration.
    lon2 = lon2d.reshape(-1)
    lat2 = lat2d.reshape(-1)

    mask = []
    # Iterate through all horizontal points in cube, and
    # check for containment within the specified geometry.
    for lat, lon in lat2, lon2:
        this_point = gpd.geoseries.Point(lon, lat)
        res = geometry.contains(this_point)
        mask.append(res.values[0])

    mask = np.array(mask).reshape(lon2d.shape)
    if mask_excludes:
        # Invert the mask if we want to include the geometry's area.
        mask = ~mask
    # Make sure the mask is the same shape as the cube.
    dim_map = (cube.coord_dims(y_coord)[0],
               cube.coord_dims(x_coord)[0])
    cube_mask = iris.util.broadcast_to_shape(mask, cube.shape, dim_map)

    # Apply the mask to the cube's data.
    data = cube.data
    masked_data = np.ma.masked_array(data, cube_mask)
    cube.data = masked_data
    return cube

masked_cube = geom_to_masked_cube(cube, shapefile, 'projection_x_coordinate', 'projection_y_coordinate', mask_excludes=True)


#Testing
x_coord = 'projection_x_coordinate'
y_coord = 'projection_y_coordinate'
lats = cube.coord(y_coord).points
lons = cube.coord(x_coord).points
lon2d, lat2d = np.meshgrid(lons,lats)

    # Reshape to 1D for easier iteration.
lon2 = lon2d.reshape(-1)
lat2 = lat2d.reshape(-1)
mask = []
# Iterate through all horizontal points in cube, and
# check for containment within the specified geometry.
    for lat, lon in zip(lat2, lon2):
        this_point = gpd.geoseries.Point(lon, lat)
        res = geometry.contains(this_point)
        mask.append(res.values[0])

    mask = np.array(mask).reshape(lon2d.shape)
    if mask_excludes:
        # Invert the mask if we want to include the geometry's area.
        mask = ~mask
    # Make sure the mask is the same shape as the cube.
    dim_map = (cube.coord_dims(y_coord)[0],
               cube.coord_dims(x_coord)[0])
    cube_mask = iris.util.broadcast_to_shape(mask, cube.shape, dim_map)

    # Apply the mask to the cube's data.
    data = cube.data
    masked_data = np.ma.masked_array(data, cube_mask)
    cube.data = masked_data

