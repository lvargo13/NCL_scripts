 
 ; Variables to assign so that CISM2_plots.ncl will run  
 
 
 fili = "IG_CISM2_default.cism.h.0067-01-01-00000.nc"    ; netCDF file being analyzed
 
 lat_lon = "lat_lon.nc"        ; lat lon data file 
 
 file_name = "Plots_CISM2"     ; name of output pdf file 
 
 var  = "uvel"     ; variable to plot
 var2 = "vvel"     ; second variabel
 
 lev = 0       ; level at which to plot (only important for 4-d variables) 
 
 ; a = ( (var^2) + (var2^2) )^0.5
 
 
 loadscript("CISM2_plots.ncl")  ; calls CISM2_plots.ncl
 
