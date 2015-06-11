 
;======================================================================
; File name: acab_cism_2.ncl
;
; Created 05/28/2015 by Lauren Vargo (lvargo@lanl.gov or lvargo@unm.edu)
;
; Plots the accumulation/ ablation rate (surface mass balance) over 
; Greenland from CISM 2.0 (CESM1 4 beta04) 50 year run
;
; Plot 1: Final timestep of the 50 year run
;
;======================================================================
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

;======================================================================
   
begin 

;---- Read in netCDF file 

	f = addfile("IG_CISM2_default.cism.h.0052-01-01-00000.nc","r")
	acab = f->acab(0,:,:)
	var = acab

	;lat  = f->y1(:)   
	;lon  = f->x1(:)    
	;dimlat = dimsizes(lat)
  	;dimlon = dimsizes(lon)        
  	;nlat   = dimlat(0)
	;nlon   = dimlon(0)        

;------- Plot 1 (SMB at the final timestep)

	plot_type = "x11"                                                        ; Output file type (can be "x11", "ps", or "pdf")
	file_name = "SMB_year51"                                                 ; Name the file 
	
	wks = gsn_open_wks(plot_type,file_name)             

	res                      = True                                          ; plot modifications desired
	
	res@tiMainString         = "Accumulation & Ablation Rates (SMB) (m/yr)"  ; title
	res@gsnLeftString        =  " "                                          ; turn off metadata subtitle
	res@gsnRightString       =  " "                                          ; turn off metadata subtitle
	res@tiYAxisString        =  " "                                          ; turn off axis label 
	
	;res@trGridType           = "TriangularMesh"
  	;res@mpProjection         = "Stereographic"
  	;res@mpDataBaseVersion    = "mediumres"		                 ; can be "lowres", "mediumres", or "highres"
  	;res@mpFillOn             = False                                         ; turn off default land map fill
	
	;res@mpLimitMode           = "Corners"  
  	;res@mpLeftCornerLatF      = lon(0)
  	;res@mpLeftCornerLonF      = lat(0)
  	;res@mpRightCornerLatF     = lat(nlat-1)
  	;res@mpRightCornerLonF     = lon(nlon-1)
  	;res@mpCenterLonF          = f->mapping@straight_vertical_longitude_from_pole
  	;res@mpCenterLatF          = f->mapping@standard_parallel

	res@cnFillOn             = True                                          ; turn on contour color
	res@cnLinesOn            = False                                         ; turn off black lines between contour lines
	res@cnFillPalette        = "NCV_blu_red"                                 ; selecting a custom colormap
	res@lbBoxLinesOn         =  False                                        ; turn off black lines on label bar

    ;--NCL calculates contour levels 
	;no_cont = 80                                    ; number of contours desired 
	;symMinMaxPlt (var,no_cont,False,res)            ; uses min & max variable values to calculate contour 
							; interval symmetric about 0
    ;--Contours can be set manually here 										
	res@cnLevelSelectionMode = "ManualLevels"	; manually set the contour levels	
  	res@cnMinLevelValF       = -0.4		; set the minimum contour level
  	res@cnMaxLevelValF       = 0.4			; set the maximum contour level
  	res@cnLevelSpacingF      = 0.02		; set the interval between contours
	 
	;res@tfDoNDCOverlay  = False
       
	res@gsnMaximize = True      ; use full page
       
	;plot = gsn_csm_contour_map(wks,acab,res)       
	plot = gsn_csm_contour(wks,acab,res) 

end
   
