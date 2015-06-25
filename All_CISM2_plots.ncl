;--------------------------------------------------------
; CISM2_plots.ncl
;
; Created 06/10/2015 by Lauren Vargo (lvargo@lanl.gov, lvargo@unm.edu)
;
; Plots: 
; Creates vertical and horizontal cross-sections at specified lat and lon 
; 
; CISM 2.0 (CESM1 4 beta04)

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"


;----------- read in netCDF file

  f  = addfile(fili,"r")
  x1 = f->x1
  y1 = f->y1
  
  d  = addfile(GLdat,"r")                                       
  nt    = 0
  lat2d = d->lat(nt,:,:)   
  lon2d = d->lon(nt,:,:)

  dimgrd= dimsizes(lat2d)
  nlat  = dimgrd(0)        
  mlon  = dimgrd(1)        

  wks = gsn_open_wks("pdf",file_name)


;----------- Modifications for all contour maps
                                              
  res1                      = True               ; plot mods desired 
  res1@gsnDraw              = False
  res1@gsnFrame             = False
  res1@cnFillOn             = True               ; turn on color
  res1@cnFillMode           = "RasterFill"
  res1@cnLinesOn            = False
  res1@gsnLeftString        = ""
  res1@gsnRightString       = ""
  res1@cnFillPalette        = "WhiteBlueGreenYellowRed"
  res1@lbTitleOn          = True                                      ; add a title to the label bar
  res1@lbTitleFontHeightF = 0.015                                      ; change font for the label bar title 
  res1@lbTitlePosition    = "bottom"                                  ; move title to below label bar
  res1@lbLabelFontHeightF = 0.012
  res1@pmLabelBarHeightF    = 0.1                 ; wider than default
  res1@pmLabelBarWidthF     = 0.3                 ; smaller than default
  res1@trGridType            = "TriangularMesh"
  res1@mpProjection          = "Stereographic"
  res1@mpDataBaseVersion     = "mediumres"
  res1@mpFillOn              = False             ; turn off default land map fill
  res1@mpLimitMode           = "Corners"  
  res1@mpLeftCornerLatF      = lat2d(0,0)
  res1@mpLeftCornerLonF      = lon2d(0,0)
  res1@mpRightCornerLatF     = lat2d(nlat-1,mlon-1)
  res1@mpRightCornerLonF     = lon2d(nlat-1,mlon-1)
  res1@mpCenterLonF          = f->mapping@straight_vertical_longitude_from_pole
  res1@mpCenterLatF          = f->mapping@standard_parallel

  resD = True
  resD@gsnDraw              = False
  resD@gsnFrame             = False
  resD@cnFillOn             = True               ; turn on color
  resD@cnFillMode           = "RasterFill"
  resD@cnLinesOn            = False
  resD@gsnLeftString        = ""
  resD@gsnRightString       = ""
  resD@cnFillPalette        = "MPL_bwr"
  resD@lbTitleOn          = True                                      ; add a title to the label bar
  resD@lbTitleFontHeightF = 0.015                                      ; change font for the label bar title 
  resD@lbTitlePosition    = "bottom"                                  ; move title to below label bar
  resD@lbLabelFontHeightF = 0.012
  resD@pmLabelBarHeightF    = 0.1                 ; wider than default
  resD@pmLabelBarWidthF     = 0.3                 ; smaller than default
  resD@trGridType            = "TriangularMesh"
  resD@mpProjection          = "Stereographic"
  resD@mpDataBaseVersion     = "mediumres"
  resD@mpFillOn              = False             ; turn off default land map fill
  resD@mpLimitMode           = "Corners"  
  resD@mpLeftCornerLatF      = lat2d(0,0)
  resD@mpLeftCornerLonF      = lon2d(0,0)
  resD@mpRightCornerLatF     = lat2d(nlat-1,mlon-1)
  resD@mpRightCornerLonF     = lon2d(nlat-1,mlon-1)
  resD@mpCenterLonF          = f->mapping@straight_vertical_longitude_from_pole
  resD@mpCenterLatF          = f->mapping@standard_parallel

  resP                      = True                ; panel resoources
  resP@gsnMaximize          = True

;------------ Contour Plots
    
  ;---- SBM    
     plot1 = new(3,graphic)            ; create the graphic for the first plot with 3 panels
     
     x  := f->acab(nt,:,:)             ; read in the modeled data 
     xGL := d->smb(nt,:,:)             ; read in actual data
     
     if(isatt(x,"scale_factor")) then    ; if statement to apply the scale factor, if applicable
     	xn := x * x@scale_factor
     else
        xn := x
     end if 
     
     maxmod = ceil(max(xn))
     maxmeas = ceil(max(xGL))
     minmod = floor(min(xn))
     minmeas = floor(min(xGL))
     if maxmod .ge. maxmeas
     	maxrange  = maxmod
     else
     	maxrange  = maxmeas
     end if
     if minmod .le. minmeas
     	minrange  = minmod
     else
     	minrange  = minmeas
     end if
     res1@cnLevelSelectionMode = "ManualLevels"
     res1@cnMinLevelValF  = minrange			; set the minimum contour level
     res1@cnMaxLevelValF  = maxrange			; set the maximum contour level
     rng = (maxrange - minrange)/21
     res1@cnLevelSpacingF = rng			; set the interval between contours 
     
     ;getvalues plot1@contour
     ;  "cnLevels" : levels
     ;end getvalues
     ;res1@lbLabelStrings := sprintf("%3.1f",levels)   ; Format the labels
	 
     xn@lat2d = lat2d 
     xn@lon2d = lon2d
     res1@tiMainString   = "Modeled"         ; title of first panel 
     res1@lbTitleString  = " ("+x@units+")"     ; label bar laber for first panel
     plot1(0) = gsn_csm_contour_map(wks,xn,res1)     ; create the first panel plot
          
     xGL@lat2d = lat2d
     xGL@lon2d = lon2d
     res1@tiMainString   = "Measured"
     res1@lbTitleString  = " ("+xGL@units+")" 
     plot1(1) = gsn_csm_contour_map(wks,xGL,res1)
     
     xdif := xn - xGL       ; subtract model from data
     xdif@lat2d = lat2d
     xdif@lon2d = lon2d
     resD@tiMainString   = "Difference (Modeled - Measured)"
     resD@lbTitleString  = " ("+xGL@units+")"
     symMinMaxPlt (xdif,21,False,resD)
     plot1(2) = gsn_csm_contour_map(wks,xdif,resD)
  
     resP@txString   = xGL@long_name    ; title for first set of plots
     gsn_panel(wks,plot1,(/1,3/),resP)   ; create first set of plots
 
  ;---- Temp
     plot2 = new(3,graphic)
     
     x  := f->temp(nt,nt,:,:)
     xGL  := d->surftemp(nt,:,:)
     
     if(isatt(x,"scale_factor")) then
     	xn := x * x@scale_factor
     else
        xn := x
     end if 
     
     maxmod := ceil(max(xn))
     maxmeas := ceil(max(xGL))
     minmod := floor(min(xn))
     minmeas := floor(min(xGL))
     if maxmod .ge. maxmeas
     	maxrange  := maxmod
     else
     	maxrange  := maxmeas
     end if
     if minmod .le. minmeas
     	minrange  := minmod
     else
     	minrange  := minmeas
     end if
     res1@cnLevelSelectionMode := "ManualLevels"
     res1@cnMinLevelValF  := minrange			; set the minimum contour level
     res1@cnMaxLevelValF  := maxrange			; set the maximum contour level
     rng := (maxrange - minrange)/21
     res1@cnLevelSpacingF := rng			; set the interval between contours
  
     xn@lat2d = lat2d
     xn@lon2d = lon2d
     res1@tiMainString   = "Modeled"
     res1@lbTitleString  = " ("+xn@units+")" 
     plot2(0) = gsn_csm_contour_map(wks,xn,res1)
     
     xGL@lat2d = lat2d
     xGL@lon2d = lon2d
     res1@tiMainString   = "Measured "
     res1@lbTitleString  = " ("+x@units+")" 
     plot2(1) = gsn_csm_contour_map(wks,xGL,res1)
     
     xdif := xn - xGL 
     xdif@lat2d = lat2d
     xdif@lon2d = lon2d
     resD@tiMainString   = "Difference (Modeled - Measured)"
     resD@lbTitleString  = " ("+x@units+")"
     symMinMaxPlt (xdif,21,False,resD)
     plot2(2) = gsn_csm_contour_map(wks,xdif,resD)
  
     resP@txString   := xGL@long_name
     gsn_panel(wks,plot2,(/1,3/),resP)

  ;---- Thickness 
     plot3 = new(3,graphic)
     
     x  := f->thk(nt,:,:)
     xGL  := d->thk(nt,:,:)

     if(isatt(x,"scale_factor")) then
     	xn := x * x@scale_factor
     else
        xn := x
     end if 
     
     maxmod := ceil(max(xn))
     maxmeas := ceil(max(xGL))
     minmod := floor(min(xn))
     minmeas := floor(min(xGL))
     if maxmod .ge. maxmeas
     	maxrange  := maxmod
     else
     	maxrange  := maxmeas
     end if
     if minmod .le. minmeas
     	minrange  := minmod
     else
     	minrange  := minmeas
     end if
     res1@cnLevelSelectionMode := "ManualLevels"
     res1@cnMinLevelValF  := minrange			; set the minimum contour level
     res1@cnMaxLevelValF  := maxrange			; set the maximum contour level
     rng := (maxrange - minrange)/21
     res1@cnLevelSpacingF := rng			; set the interval between contours
     
     xn@lat2d = lat2d
     xn@lon2d = lon2d
     res1@tiMainString   = "Modeled"
     res1@lbTitleString  = " ("+x@units+")" 
     plot3(0) = gsn_csm_contour_map(wks,xn,res1)
     
     xGL@lat2d = lat2d
     xGL@lon2d = lon2d
     res1@tiMainString   = "Measured "
     res1@lbTitleString  = " ("+xGL@units+")" 
     plot3(1) = gsn_csm_contour_map(wks,xGL,res1)
     
     xdif := xn - xGL 
     xdif@lat2d = lat2d
     xdif@lon2d = lon2d
     resD@tiMainString   = "Difference (Modeled - Measured)"
     resD@lbTitleString  = " ("+xGL@units+")"
     symMinMaxPlt (xdif,21,False,resD)
     plot3(2) = gsn_csm_contour_map(wks,xdif,resD)
     
     resP@txString   := xGL@long_name
     gsn_panel(wks,plot3,(/1,3/),resP)

  ;---- Topography
      plot4 = new(3,graphic)
     
     x  := f->topg(nt,:,:)
     xGL  := d->topg(nt,:,:)
     
     if(isatt(x,"scale_factor")) then
     	xn := x * x@scale_factor
     else
        xn := x
     end if
     
     maxmod := ceil(max(xn))
     maxmeas := ceil(max(xGL))
     minmod := floor(min(xn))
     minmeas := floor(min(xGL))
     if maxmod .ge. maxmeas
     	maxrange  := maxmod
     else
     	maxrange  := maxmeas
     end if
     if minmod .le. minmeas
     	minrange  := minmod
     else
     	minrange  := minmeas
     end if
     res1@cnLevelSelectionMode := "ManualLevels"
     res1@cnMinLevelValF  := minrange			; set the minimum contour level
     res1@cnMaxLevelValF  := maxrange			; set the maximum contour level
     rng := (maxrange - minrange)/21
     res1@cnLevelSpacingF := rng			; set the interval between contours

     xn@lat2d = lat2d
     xn@lon2d = lon2d
     res1@tiMainString   = "Modeled"
     res1@lbTitleString  = " ("+x@units+")" 
     plot4(0) = gsn_csm_contour_map(wks,xn,res1)
     
     xGL@lat2d = lat2d
     xGL@lon2d = lon2d
     res1@tiMainString   = "Measured "
     res1@lbTitleString  = " ("+xGL@units+")" 
     plot4(1) = gsn_csm_contour_map(wks,xGL,res1)
     
     xdif := xn - xGL 
     xdif@lat2d = lat2d
     xdif@lon2d = lon2d
     resD@tiMainString   = "Difference (Modeled - Measured)"
     resD@lbTitleString  = " ("+xGL@units+")"
     symMinMaxPlt (xdif,21,False,resD)
     plot4(2) = gsn_csm_contour_map(wks,xdif,resD)
  
     resP@txString  := xGL@long_name
     gsn_panel(wks,plot4,(/1,3/),resP)

  ;---- Surface Elevation 
     plot5 = new(3,graphic)
     
     x  := f->usurf(nt,:,:)
     xGL  := d->usrf(nt,:,:)
     
     if(isatt(x,"scale_factor")) then
     	xn := x * x@scale_factor
     else
        xn := x
     end if 
     
     maxmod := ceil(max(xn))
     maxmeas := ceil(max(xGL))
     minmod := floor(min(xn))
     minmeas := floor(min(xGL))
     if maxmod .ge. maxmeas
     	maxrange  := maxmod
     else
     	maxrange  := maxmeas
     end if
     if minmod .le. minmeas
     	minrange  := minmod
     else
     	minrange  := minmeas
     end if
     res1@cnLevelSelectionMode := "ManualLevels"
     res1@cnMinLevelValF  := minrange			; set the minimum contour level
     res1@cnMaxLevelValF  := maxrange			; set the maximum contour level
     rng := (maxrange - minrange)/21
     res1@cnLevelSpacingF := rng			; set the interval between contours

     xn@lat2d = lat2d
     xn@lon2d = lon2d
     res1@tiMainString   = "Modeled"
     res1@lbTitleString  = " ("+x@units+")" 
     plot5(0) = gsn_csm_contour_map(wks,xn,res1)
          
     xGL@lat2d = lat2d
     xGL@lon2d = lon2d
     res1@tiMainString   = "Measured "
     res1@lbTitleString  = " ("+xGL@units+")" 
     plot5(1) = gsn_csm_contour_map(wks,xGL,res1)
          
     xdif := xn - xGL 
     xdif@lat2d = lat2d
     xdif@lon2d = lon2d
     resD@tiMainString   = "Difference (Modeled - Measured)"
     resD@lbTitleString  = " ("+xGL@units+")"
     symMinMaxPlt (xdif,21,False,resD)
     plot5(2) = gsn_csm_contour_map(wks,xdif,resD)
  
     resP@txString   := xGL@long_name
     gsn_panel(wks,plot5,(/1,3/),resP)
     
  ;---- Absolute Velocity (Top Layer)   
     plot6 = new(3,graphic)
     
     xvel  := f->uvel(nt,nt,:,:)
     yvel  := f->vvel(nt,nt,:,:)
     x :=  ((xvel^2) + (yvel^2))^0.5 
     xGL  := d->surfvelmag(nt,0:nlat-2,0:mlon-2)
     
     if(isatt(xvel,"scale_factor")) then
     	xn := x * xvel@scale_factor
     else
        xn := x
     end if 
     
     maxmod := ceil(max(xn))
     maxmeas := ceil(max(xGL))
     if maxmod .ge. maxmeas
     	maxrange  := maxmod
     else
     	maxrange  := maxmeas
     end if
     lnmax = log10(max(maxrange))
     res1@cnLevelSelectionMode = "ExplicitLevels"                        ; set explicit contour levels 
     logspace = (10)^(fspan(0,lnmax,21))       ; logrithmically spaced contours
     res1@cnLevels = (logspace)                             ; set levels 

     xn@lat2d = lat2d
     xn@lon2d = lon2d
     res1@tiMainString   = "Modeled"
     res1@lbTitleString  = " ("+xvel@units+")" 
     plot6(0) = gsn_csm_contour_map(wks,xn,res1)
          
     xGL@lat2d = lat2d
     xGL@lon2d = lon2d
     res1@tiMainString   = "Measured "
     res1@lbTitleString  = " ("+xGL@units+")" 
     plot6(1) = gsn_csm_contour_map(wks,xGL,res1)
          
     xdif := xn - xGL 
     xdif@lat2d = lat2d
     xdif@lon2d = lon2d
     resD@tiMainString   = "Difference (Modeled - Measured)"
     resD@lbTitleString  = " ("+xGL@units+")"
     symMinMaxPlt (xdif,21,False,resD)
     plot6(2) = gsn_csm_contour_map(wks,xdif,resD)
  
     resP@txString   := xGL@long_name
     gsn_panel(wks,plot6,(/1,3/),resP)
