 ; Created by Lauren Vargo 06/12/2015
 
 ;-- Variables to assign so that CISM2_plots.ncl will run  
 
 ; (This script is for analyzing one variable, run_CISM2_math.ncl can be used when 
 ; two variables are being read in, in order to compute a third variable being analyzed) 
 
 
 
 fili = "IG_CISM2_default.cism.h.0067-01-01-00000.nc"    ; netCDF file being analyzed
 
 lat_lon = "lat_lon.nc"        ; lat lon data file 
 
 file_name = "Plots_CISM2"     ; name of output pdf file 
 
 var  = "thk"     ; variable to plot

 lev = 0       ; level at which to plot (only important for 4-d variables) 
 
 

 loadscript("CISM2_plots.ncl")  ; calls CISM2_plots.ncl
