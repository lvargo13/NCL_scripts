 ;======================================================================
; File name: horz_x_section.ncl
;
; Created 05/29/2015 by Lauren Vargo (lvargo@lanl.gov or lvargo@unm.edu)
;
; Plots a horizontal (change over latitude cross section of the accumulation/ 
; ablation rate (surface mass balance) in order to see the 'checkerboard pattern' problem
;
; CISM 2.0 (CESM1 4 beta04)
;
;======================================================================
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

;======================================================================
   
begin 

;---- Read in netCDF file - This is where the user can customize what is being plotted 

	f = addfile("IG_CISM2_default.cism.h.0067-01-01-00000.nc","r")   ; netCDF file to read in
	latit = 267                     ; latitude index at which to cut the horizontal cross section
	var = f->acab(0,:,:)            ; read in the variable to be analyzed
	
	plot_type = "x11"                   ; Output file type (can be "x11", "ps", or "pdf")
	file_name = "SMB_xsection_year67"   ; Name the file 
	
;------- Plots------------------------------
	
	lat   = f->y1		      ; turn latitude into a variable 
	lon   = f->x1                 ; turn longitude into a variable
	vars = var(latit,:)           ; read in the variable being analyzed at the latitude selected
	wks = gsn_open_wks(plot_type,file_name)             

	res = True                                      ; plot modifications desired
	res@tiMainString = "Accumulation & Ablation Rates (SMB)"  ; title
	res@gsnLeftString =  ("Latitude: " + lat(latit))   ; Labels the latitude previously selected
	res@gsnRightString =  " "                       ; turn off metadata subtitle
	res@tiYAxisString = "SMB (m/yr)"                ; Y axis label
	res@tiXAxisString =  "Longitude"                ; X axis label
	res@vpWidthF = 1				; change the width:height ratio
	res@vpHeightF = 0.4
	res@gsnMaximize = True				; fit plot to page
	plot = gsn_csm_xy(wks,lon,vars,res) 		; plot

end
