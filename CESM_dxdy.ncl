;======================================================================
; File name: CESM_dxdy.ncl
;
; Created 06/16/2015 by Lauren Vargo
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

	lat_index = 300

	f1a = addfile("IG_CISM2_default.cism.h.0002-01-01-00000.nc","r")     ; Read in first year elev
	usurf1 = f1a->usurf(0,lat_index,:)
		
	f2a = addfile("IG_CISM2_default.cism.h.0067-01-01-00000.nc","r")     ; Read in last year elev  
	usurf2 = f2a->usurf(0,lat_index,:)
	
	dmgrd = dimsizes(usurf1)
	
	dz_usurf1 = usurf1(1:dmgrd-1) - usurf1(0:dmgrd-2)
	dz_usurf2 = usurf2(1:dmgrd-1) - usurf2(0:dmgrd-2)
	dx = 4000
	dzdx_usurf1 = dz_usurf1 / dx
	dzdx_usurf2 = dz_usurf2 / dx
	
	g   = addfile("lat_lon.nc","r")         ; read in lat and lon data 
	lat = g->lat(0,:,175)
	lon = g->lon(0,lat_index,:)
	print(lat(lat_index))

	
;---- First Plot

	title = "CESM_dxdy"      ; file name
	type = "pdf"                 ; plot type (can be "x11", "pdf", or "ps")
	wks   = gsn_open_wks (type,title)  
	
	res = True
	res@gsnDraw      = False                        ; don't draw yet
  	res@gsnFrame     = False                        ; don't advance frame yet
	res@tiMainString      = "Surface Slope Gradient"      ; title
	res@gsnLeftString = ("Latitude:"+sprintf("%5.0f",lat(lat_index))+"~S~o~N~N" ) ;label longitude
	res@gsnRightString =  " "                        ; turn off metadata subtitle
	res@tiYAxisString  = "Slope"           ; Y axis label
	res@tiXAxisString  = "Longitude (~S~o~N~W)"      ; X axis label
	res@vpWidthF       = 0.7			   ; change the width:height ratio
	res@vpHeightF      = 0.45                         ; change the width:height ratio
	res@xyLineColor = "Black"
	res@xyLineThicknesses = 3
	
	plot1  = gsn_csm_xy (wks,lon,dzdx_usurf2,res) ; create plot
	
;---- Second Plot
	res@xyLineThicknesses = 2
	res@xyLineColor      = "Red"                   ; color of second line	
        plot2  = gsn_csm_xy (wks,lon,dzdx_usurf1,res) ; create plot
	overlay(plot1,plot2)
	
;---- Legend

  lgres                    = True
  lgres@lgDashIndexes = (/0, 0/)
  lgres@lgLineColors      = (/"Black","Red"/)
  lgres@lgLabelFontHeightF = .08            ; set the legend label font thickness
  lgres@vpWidthF           = 0.15           ; width of legend (NDC)
  lgres@vpHeightF          = 0.1            ; height of legend (NDC)
  lgres@lgPerimColor       = "black"       ; draw the box perimeter 
  lgres@lgPerimThicknessF  = 2.0            ; thicken the box perimeter
  lbid = gsn_create_legend(wks,2,(/"  Year 66","  Year 1"/),lgres)         ; create legend

  amres = True
  amres@amParallelPosF   = 0.43		    ; move legend to the right
  amres@amOrthogonalPosF = 0.78             ; move the legend down
  annoid1 = gsn_add_annotation(plot2,lbid,amres)   ; add legend to plot
		
	draw(plot1)
	frame(wks)
end	  
