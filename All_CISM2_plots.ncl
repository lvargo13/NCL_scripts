;--------------------------------------------------------
; CISM2_plots.ncl
;
; Created 06/10/2015 by Lauren Vargo (lvargo@lanl.gov, lvargo@unm.edu)
;
; Plots: 
; Creates vertical and horizontal cross-sections at specified lat and lon 
; 
; CISM 2.0 (CESM1 4 beta04)


;----------- read in netCDF file

  f  = addfile(fili,"r")
  x1 = f->x1
  y1 = f->y1

  g     = addfile(lat_lon,"r")                                           
  nt    = 0
  lat2d = g->lat(nt,:,:)   
  lon2d = g->lon(nt,:,:)

  dimgrd= dimsizes(lat2d)
  nlat  = dimgrd(0)        
  mlon  = dimgrd(1)        

  wks = gsn_open_wks("pdf",file_name)


;----------- Modifications for all contour maps
                                              
  res1                      = True               ; plot mods desired 
  res1@cnFillOn             = True               ; turn on color
  res1@cnFillMode           = "RasterFill"
  res1@cnLinesOn            = False
  res1@gsnLeftString        = ""
  res1@gsnRightString       = ""
  res1@gsnMaximize          = True
  res1@cnFillPalette        = "WhiteBlueGreenYellowRed"
  
  res1@lbTitleOn          = True                                      ; add a title to the label bar
  res1@lbTitleFontHeightF = 0.015                                      ; change font for the label bar title 
  res1@lbTitlePosition    = "bottom"                                  ; move title to below label bar
  res1@gsnMaximize        = True
  res1@lbLabelFontHeightF = 0.012
  res1@pmLabelBarHeightF    = 0.1                 ; wider than default
  res1@pmLabelBarWidthF     = 0.6                 ; smaller than default

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


;------------ Contour Plots
     
     x  := f->acab(nt,:,:)
     x@lat2d = lat2d
     x@lon2d = lon2d
     res1@tiMainString   = x@long_name
     res1@lbTitleString  = x@long_name+" ("+x@units+")" 
     plot1 = gsn_csm_contour_map(wks,x,res1)
 
 
     x  := f->artm(nt,:,:)
     x@lat2d := lat2d
     x@lon2d := lon2d
     res1@tiMainString   := x@long_name
     res1@lbTitleString  := x@long_name+" ("+x@units+")" 
     plot2 = gsn_csm_contour_map(wks,x,res1)

   
     x  := f->thk(nt,:,:)
     x@lat2d := lat2d
     x@lon2d := lon2d
     res1@tiMainString   := x@long_name
     res1@lbTitleString  := x@long_name+" ("+x@units+")" 
     plot3 = gsn_csm_contour_map(wks,x,res1)


     x  := f->topg(nt,:,:)
     x@lat2d := lat2d
     x@lon2d := lon2d
     res1@tiMainString   := x@long_name
     res1@lbTitleString  := x@long_name+" ("+x@units+")" 
     plot4 = gsn_csm_contour_map(wks,x,res1)

   
     x  := f->usurf(nt,:,:)
     x@lat2d := lat2d
     x@lon2d := lon2d
     res1@tiMainString   := x@long_name
     res1@lbTitleString  := x@long_name+" ("+x@units+")" 
     plot5 = gsn_csm_contour_map(wks,x,res1)
     
      
     x  := f->bmlt(nt,:,:)
     x@lat2d := lat2d
     x@lon2d := lon2d
     res1@tiMainString   := x@long_name
     res1@lbTitleString  :="Log~B~10~N~ "+x@long_name+" ("+x@units+")"
     res1@cnLevelSelectionMode := "ExplicitLevels"                        ; set explicit contour levels 
     logspace := fspan((log10(1)),(log10(max(x))),30)       ; logrithmically spaced contours
     res1@cnLevels := (logspace)                              ; set levels  
     plot6 = gsn_csm_contour_map(wks,x,res1)
     
     
     x  := f->uvel(nt,nt,:,:)
     y  := f->vvel(nt,nt,:,:)
     Vel :=  ((x^2) + (y^2))^0.5 
     Vel@lat2d := lat2d
     Vel@lon2d := lon2d
     res1@tiMainString   := ("Absolute Velocity (Top Layer)")
     res1@lbTitleString  := ("Log~B~10~N~ Absolute Velocity")+" ("+x@units+")" 
     res1@cnLevelSelectionMode := "ExplicitLevels"                        ; set explicit contour levels 
     logspace := fspan((log10(1)),(log10(max(Vel))),30)       ; logrithmically spaced contours
     res1@cnLevels := (logspace)                              ; set levels 
     plot7 = gsn_csm_contour_map(wks,Vel,res1)


     x  := f->uvel
     y  := f->vvel
     dimvel = dimsizes(x)
     nlev  = dimvel(1)      
     x  := f->uvel(nt,nlev-1,:,:)
     y  := f->vvel(nt,nlev-1,:,:)
     Vel := ((x^2) + (y^2))^0.5
     Vel@lat2d := lat2d
     Vel@lon2d := lon2d
     res1@tiMainString   := ("Absolute Velocity (Bottom Layer)")
     res1@lbTitleString  := ("Log~B~10~N~ Absolute Velocity")+" ("+x@units+")" 
     res1@cnLevelSelectionMode := "ExplicitLevels"                        ; set explicit contour levels 
     logspace := fspan((log10(1)),(log10(max(Vel))),30)       ; logrithmically spaced contours
     res1@cnLevels := (logspace)                              ; set levels 
     plot8 = gsn_csm_contour_map(wks,Vel,res1)
