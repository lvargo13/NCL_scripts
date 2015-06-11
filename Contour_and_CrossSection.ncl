 ;======================================================================
; File name: Contour_and_CrossSection.ncl
;
; Created 06/09/2015 by Lauren Vargo (lvargo@lanl.gov, lvargo@unm.edu)
;
; Plots absolute velocity (u^2 + v^2) average at all levels 
; Creates vertical and horizontal cross-sections at specified lat and lon 
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

;------------ Read in netCDF file 

	f = addfile("IG_CISM2_default.cism.h.0067-01-01-00000.nc","r")
	u = f->uvel(0,:,:,:)    ; [time] [levels] [lat] [lon] 
	v = f->vvel(0,:,:,:)    ; [time] [levels] [lat] [lon] 
	
	uAvg   = dim_avg_n(u,0)                 ; average velocity at all levels
	vAvg   = dim_avg_n(v,0)                 ; average velocity at all levels
	VelAvg = ((uAvg^2) + (vAvg^2))^0.5      ; calculate absolute velocity         
	
	g   = addfile("lat_lon.nc","r")         ; read in lat and lon data 
	lat = g->lat(0,0:699,0)
	lon = g->lon(0,0,0:374)
	 
	plot_type = "pdf"                        ; Output file type (can be "x11", "ps", or "pdf")
	file_name = "AbsoluteVelocity"           ; Name the file 
	
	wks = gsn_open_wks(plot_type,file_name)             


;------------ Data for cross section plots 
	
	lon_index = 200                               ; longitude index at which to cut the cross section
	lon_var   = VelAvg(:,lon_index)               ; select all latitude values at the selected lon index
	lon_title = lon(lon_index)                    ; the longitude of the cross section 
	
	lat_index1 = 450                              ; latitude index at which to cut the cross section
	lat_var1   = VelAvg(lat_index1,:)             ; select all lon values at the selected latitude index
	lat_title1 = lat(lat_index1)                  ; the latitude of the cross section
	
	lat_index2 = 308                              ; latitude index at which to cut the  cross section 
	lat_var2   = VelAvg(lat_index2,:)             ; select all lon values at the selected latitude index
	lat_title2 = lat(lat_index2)                  ; the latitude of the cross section
	
	
;------------ Plot 1- Contour

	res                      = True                                    ; plot modifications desired	
	res@gsnDraw              = False                                   ; do not draw the plot yet
  	res@gsnFrame             = False                                   ; do not advance the frame yet
	res@tiMainString         = "Absolute Velocity"                     ; title
	res@gsnLeftString        =  " "                                    ; turn off metadata subtitle
	res@gsnRightString       =  " "                                    ; turn off metadata subtitle
	res@tiYAxisString        =  " "                                    ; turn off axis label 
	
	res@lbTitleOn          = True                                      ; add a title to the label bar
	res@lbTitleString      = "Log~B~10~N~ absolute velocity (m/yr)"    ; label bar title       
	res@lbTitleFontHeightF = 0.02                                      ; change font for the label bar title 
	res@lbTitlePosition    = "bottom"                                  ; move title to below label bar
	res@gsnMaximize        = True
	res@cnFillOn           = True                                      ; turn on contour color
	res@cnLinesOn          = False                                     ; turn off black lines between contour lines
	res@cnFillPalette      = "WhiteBlueGreenYellowRed"                 ; selecting a custom colormap
	res@lbBoxLinesOn       = False                                     ; turn off black lines on label bar  
                  		      
			      
    ;--Contours are set here (in a log scale) 										

	res@cnLevelSelectionMode = "ExplicitLevels"                        ; set explicit contour levels 
	logspace                 = fspan((log10(1)),(log10(100)),20)       ; logrithmically spaced contours
	res@cnLevels             = (logspace)                              ; set levels 
	
    ;--Contour plot (including cross section lines) 
		
   	plot1 = gsn_csm_contour(wks,VelAvg,res)          ; plot command 
   
   	txres = True
   	txres@txFontHeightF = 0.02                      ; change font size for cross section labels 
   	xsec1 = gsn_add_polyline(wks,plot1,(/(lon_index),(lon_index)/),(/15,685/),txres)    ; cross section line
   	xsec2 = gsn_add_polyline(wks,plot1,(/10,365/),(/(lat_index1),(lat_index1)/),txres)  ; cross section line
   	xsec3 = gsn_add_polyline(wks,plot1,(/10,365/),(/(lat_index2),(lat_index2)/),txres)  ; cross section line
   
    ; Labels for the cross section lines   
   	a = gsn_add_text(wks,plot1,"a",lon_index,15,txres)
   	aprime = gsn_add_text(wks,plot1,"a'",lon_index,685,txres)
   	b = gsn_add_text(wks,plot1,"b",10,lat_index1,txres)
   	bprime = gsn_add_text(wks,plot1,"b'",365,lat_index1,txres)
   	c = gsn_add_text(wks,plot1,"c",10,lat_index2,txres)
   	cprime = gsn_add_text(wks,plot1,"c'",365,lat_index2,txres)
   
   	draw(plot1)      ; draw the plot
   	frame(wks)       ; advance the frame for the next plots 
   
;------------ Plot 2- Vertical Cross Section

	x1res                = True                        ; plot modifications desired
	x1res@tiMainString   = "a - a'"                    ; title
	x1res@gsnRightString =  " "                        ; turn off metadata subtitle
	x1res@tiYAxisString  = "Velocity (m/yr)"           ; Y axis label
	x1res@tiXAxisString  = "Latitude (~S~o~N~N)"       ; X axis label
	x1res@vpWidthF       = 0.7			   ; change the width:height ratio
	x1res@vpHeightF      = 0.3                         ; change the width:height ratio
	x1res@gsnLeftString  = ("Longitude: " + sprintf("%5.1f",lon_title) +"~S~o~N~W" )  ;labels the latitude

    plot2 = gsn_csm_xy(wks,lat,lon_var,x1res)       ; plot command


;------------ Plot 3- Horizontal Cross Section 1

	x2res                = True                        ; plot modifications desired
	x2res@tiMainString   = "b - b'"                    ; title
	x2res@gsnRightString =  " "                        ; turn off metadata subtitle
	x2res@tiYAxisString  = "Velocity (m/yr)"           ; Y axis label
	x2res@tiXAxisString  = "Longitude (~S~o~N~W)"      ; X axis label
	x2res@vpWidthF       = 0.7			   ; change the width:height ratio
	x2res@vpHeightF      = 0.3                         ; change the width:height ratio
	x2res@gsnLeftString  =  ("Latitude: " + sprintf("%5.1f",lat_title1) +"~S~o~N~N" )  ;labels the longitude

     plot3 = gsn_csm_xy(wks,lon,lat_var1,x2res)       ; plot command 


;------------ Plot 4- Horizontal Cross Section 2

	x3res                = True                        ; plot modifications desired
	x3res@tiMainString   = "c - c'"                    ; title
	x3res@gsnRightString =  " "                        ; turn off metadata subtitle
	x3res@tiYAxisString  = "Velocity (m/yr)"           ; Y axis label
	x3res@tiXAxisString  = "Longitude (~S~o~N~W)"      ; X axis label
	x3res@vpWidthF       = 0.7			   ; change the width:height ratio
	x3res@vpHeightF      = 0.3                         ; change the width:height ratio
	x3res@gsnLeftString  =  ("Latitude: " + sprintf("%5.1f",lat_title2) +"~S~o~N~N" )   ; labels the latitude

     plot4 = gsn_csm_xy(wks,lon,lat_var2,x3res)      ; plot command


end
