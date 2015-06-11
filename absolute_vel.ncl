 
;======================================================================
; File name: absolute_vel.ncl
;
; Created 06/03/2015 by Lauren Vargo (lvargo@lanl.gov or lvargo@unm.edu)
;
; Plots the absolute velocity (u^2 + v^2) from CISM 2.0 (CESM1 4 beta04)
;
;======================================================================
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"

;======================================================================
   
begin 

;------------ Read in netCDF file 

	f = addfile("IG_CISM2_default.cism.h.0067-01-01-00000.nc","r")
	u = f->uvel(0,0,:,:)    ; [time] [levels] [lat] [lon] 
	v = f->vvel(0,0,:,:)    ; [time] [levels] [lat] [lon] 
	avel = ((u^2) + (v^2))^0.5    ; calculate absolute velocity 
        var = avel
	
;------------ Plot all (or more than one) level

	plot_type = "x11"                        ; Output file type (can be "x11", "ps", or "pdf")
	file_name = "AbsoluteVelocity_year67"    ; Name the file 
	
	wks = gsn_open_wks(plot_type,file_name)             

	res                      = True                                          ; plot modifications desired
	
	res@tiMainString         = "Absolute Velocity (m/yr)"  ; title
	res@gsnLeftString        =  " "                                          ; turn off metadata subtitle
	res@gsnRightString       =  " "                                          ; turn off metadata subtitle
	res@tiYAxisString        =  " "                                          ; turn off axis label 

	res@cnFillOn             = True                                          ; turn on contour color
	res@cnLinesOn            = False                                         ; turn off black lines between contour lines
	res@cnFillPalette        = "WhiteBlueGreenYellowRed"                                 ; selecting a custom colormap
	res@lbBoxLinesOn         =  False                                        ; turn off black lines on label bar


    ;--Contours are set here (in a log scale) 										

	res@cnLevelSelectionMode = "ExplicitLevels"     ; set explicit contour levels 
    	x = fspan(0,5,20)                    ; contour range (first value, last value, number of contours)
	levels = x*log(exp(x))/10
	res@cnLevels = levels                  ; set levels 
	;res@lbLabelStrings =  (/"0","2","4","6","8","10"/) 
	res@lbTitleOn = True  ; so that we can add a title to the label bar
	
	res@lbTitleString = " Log~B~10~N~ absolute velocity (m/yr) "
	res@lbTitleFontHeightF = 0.02    ; change font for the label bar title 
	res@lbTitlePosition = "bottom"
		
	res@gsnMaximize = True      ; use full page
       
	plot = gsn_csm_contour(wks,var,res) 

end
   
