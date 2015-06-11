 
;======================================================================
; File name: integrated_abs_vel.ncl
;
; Created 06/08/2015 by Lauren Vargo (lvargo@lanl.gov or lvargo@unm.edu)
;
; Plots absolute velocity (u^2 + v^2) average at all levels from CISM 2.0 
; (CESM1 4 beta04)
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
	u = f->uvel(0,:,:,:)    ; [time] [levels] [lat] [lon] 
	v = f->vvel(0,:,:,:)    ; [time] [levels] [lat] [lon] 
	
	uAvg = dim_avg_n(u,0)   ; average velocity at all levels
	vAvg = dim_avg_n(v,0)   ; average velocity at all levels
	
	avel = ((uAvg^2) + (vAvg^2))^0.5    ; calculate absolute velocity 
        var = avel         
	
	g = addfile("lat_lon.nc","r")       ; read in lat and lon data 
	lat = g->lat(0,:,:)
	lon = g->lon(0,:,:)
       
	
;------------ Plot all (or more than one) level

	plot_type = "pdf"                        ; Output file type (can be "x11", "ps", or "pdf")
	file_name = "AbsoluteVelocity"           ; Name the file 
	
	wks = gsn_open_wks(plot_type,file_name)             

	res                      = True                                    ; plot modifications desired	
	res@tiMainString         = "Absolute Velocity"                     ; title
	res@gsnLeftString        =  " "                                    ; turn off metadata subtitle
	res@gsnRightString       =  " "                                    ; turn off metadata subtitle
	res@tiYAxisString        =  " "                                    ; turn off axis label 
	
	res@cnFillOn             = True                                    ; turn on contour color
	res@cnLinesOn            = False                                   ; turn off black lines between contour lines
	res@cnFillPalette        = "WhiteBlueGreenYellowRed"               ; selecting a custom colormap
	res@lbBoxLinesOn         =  False                                  ; turn off black lines on label bar

	res@lbTitleOn = True                                               ; so that we can add a title to the label bar
	res@lbTitleString = " Log~B~10~N~ absolute velocity (m/yr) "       ; label bar title       
	res@lbTitleFontHeightF = 0.02                                      ; change font for the label bar title 
	res@lbTitlePosition = "bottom"                                     ; move title to below label bar
	
    ;--Contours are set here (in a log scale) 										

	res@cnLevelSelectionMode = "ExplicitLevels"        ; set explicit contour levels 
	logspace = fspan((log10(1)),(log10(100)),50)       ; calculates logrithmically spaced contours 
	res@cnLevels = (logspace)                          ; set levels 
		
	;res@gsnMaximize = True                            ; use full page

   	plot = gsn_csm_contour(wks,var,res)                ; plot command 

end
