 ; Created by Lauren Vargo 06/11/2015
 
 ;-- Variables to assign so that All_CISM2_plots.ncl will run 

 
 
 fili = "BG_CISM1_parallel_updating.cism.h.0093-01-01-00000.nc"    ; model run
 
 GLdat = "Greenland_5km_v1.1_SacksRev_c110629.nc"    ; Greenland data
 
 file_name = "Plots_CISM1"     ; name of output pdf file  
 
 
 loadscript("All_CISM2_plots.ncl")  ; calls CISM2_plots.ncl
