 ;======================================================================
; File name: x_section.ncl
;
; Created 05/29/2015 by Lauren Vargo (lvargo@lanl.gov or lvargo@unm.edu)
;
; Plots a cross section of the accumulation/ ablation rate (surface mass 
; balance) in order to see the 'checkerboard pattern' problem
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
	latit = 268                     ; latitude index at which to cut the horizontal cross section
	var = f->acab(0,:,:)            ; read in the variable to be analyzed
	
	plot_type = "ps"                   ; Output file type (can be "x11", "ps", or "pdf")
	file_name = "SMB_xsection_year67"   ; Name the file 
	
;------- Plots------------------------------
	
	lat   = f->y1		      ; turn latitude into a variable 
	lon   = f->x1                 ; turn longitude into a variable
	vars = var(latit,:)           ; read in the variable being analyzed at the latitude selected
	wks = gsn_open_wks(plot_type,file_name)             

     ;------- Plot Cross Section

	res = True                                      ; plot modifications desired
	res@tiMainString = "Accumulation & Ablation Rates (SMB) (m/yr)"  ; title
	res@gsnLeftString =  " "                        ; turn off metadata subtitle
	res@gsnRightString =  " "                       ; turn off metadata subtitle
	res@tiYAxisString = "SMB (m/yr)"                ; Y axis label
	res@tiXAxisString =  "Longitude"                ; X axis label
  	res@gsnFrame = False                            ; don't advance frame
	res@vpXF            = 0.2         
  	res@vpYF            = 0.92
	res@vpWidthF        = 0.7	    
	res@vpHeightF       = 0.23 

	plot = gsn_csm_xy(wks,lon,vars,res) 
	
     ;------- Plot map of Cross Section 

	sres = True               ; plot modifications desired
	sres@gsnFrame = False     ; don't advance frame	
	sres@cnFillOn = True                                          ; turn on contour color
	sres@cnLinesOn = False                                         ; turn off black lines between contour lines
	sres@cnFillPalette = "NCV_blu_red"                                 ; selecting a custom colormap
	sres@lbBoxLinesOn = False                                        ; turn off black lines on label bar
	no_cont = 60                                    ; number of contours desired 
	symMinMaxPlt (var,no_cont,False,sres)            ; uses contours data to be symmetric about 0 
	sres@gsnLeftString        =  " "                                          ; turn off metadata subtitle
	sres@gsnRightString       =  " "                                          ; turn off metadata subtitle
	sres@tiYAxisString        =  " "                                          ; turn off axis label
	sres@vpXF              = 0.35   
	sres@vpYF              = 0.55     
  	sres@vpWidthF          = 0.35
  	sres@vpHeightF         = 0.4
		
	plot2= gsn_csm_contour(wks,var,sres) 					

	lnid = gsn_add_polyline(wks,plot2,lon,latit,sres)
	draw(plot)
	frame(wks)

end
   
