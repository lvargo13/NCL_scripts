 ; Created by Lauren Vargo 06/11/2015
 
 ;-- Variables to assign so that All_CISM2_plots.ncl will run 

 
 
 fili = "IG_CISM2_default.cism.h.0067-01-01-00000.nc"    ; netCDF file being analyzed
 
 lat_lon = "lat_lon.nc"        ; lat lon data file 
 
 file_name = "Plots_CISM2"     ; name of output pdf file 
 
 ; eventually add cross section locations 
 
 
 
 loadscript("All_CISM2_plots.ncl")  ; calls CISM2_plots.ncl
