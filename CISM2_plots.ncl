;--------------------------------------------------------
; CISM2_plots.ncl
;
; Created 06/10/2015 by Lauren Vargo (lvargo@lanl.gov, lvargo@unm.edu)
;
; Plots absolute velocity (u^2 + v^2) at the top level 
; Creates vertical and horizontal cross-sections at specified lat and lon 
; 
; CISM 2.0 (CESM1 4 beta04)


;----------- read in netCDF file

  diri  = "./"
  fil  = "IG_CISM2_default.cism.h.0067-01-01-00000.nc"                      ; command line
  f     = addfile(diri+fil,"r")

  g   = addfile("lat_lon.nc","r")                                           ; command line  
  nt    = 0
  lat2d = g->lat(nt,:,:)   
  lon2d = g->lon(nt,:,:)

  dimgrd= dimsizes(lat2d)
  nlat  = dimgrd(0)        
  mlon  = dimgrd(1)        


;----------- contour map modifications

  title = "Plots_CISM2"                                                     ; command line
  wks = gsn_open_wks("pdf",title)   

  res                      = True               ; plot mods desired
  res@gsnDraw              = False
  res@gsnFrame             = False 
  res@cnFillOn             = True               ; turn on color
  res@cnFillMode           = "RasterFill"
  res@cnLinesOn            = False
  res@cnLineLabelsOn       = False
  res@lbLabelBarOn         = False              ; turn off individual lb's

  res@trGridType           = "TriangularMesh"
  res@mpProjection          = "Stereographic"
  res@mpDataBaseVersion     = "mediumres"
  res@mpFillOn              = False             ; turn off default land map fill
  res@mpLimitMode           = "Corners"  
  res@mpLeftCornerLatF      = lat2d(0,0)
  res@mpLeftCornerLonF      = lon2d(0,0)
  res@mpRightCornerLatF     = lat2d(nlat-1,mlon-1)
  res@mpRightCornerLonF     = lon2d(nlat-1,mlon-1)
  res@mpCenterLonF          = f->mapping@straight_vertical_longitude_from_pole
  res@mpCenterLatF          = f->mapping@standard_parallel

  res@gsnLeftString         = ""
  res@gsnRightString        = ""
  resP                      = True                ; panel resoources
  resP@gsnMaximize          = True
  resP@gsnPanelLabelBar     = True                ; add common colorbar
  resP@pmLabelBarHeightF    = 0.1                 ; wider than default
  resP@pmLabelBarWidthF     = 0.7                 ; smaller than default
  resP@lbLabelFontHeightF   = 0.0125              ; make label size


;----------- Contour Map 

  var  = "acab"                                                      ; command line
  plots = new(1,graphic)   ; new plots, with one plot per page   

  x  = f->$var$(nt,:,:)
  x@lat2d = lat2d
  x@lon2d = lon2d

  res@cnFillPalette = "WhiteBlueGreenYellowRed"
  res@tfDoNDCOverlay = False 
     
  plots(0) = gsn_csm_contour_map(wks,x,res)

  resP@txString      = x@long_name+" ("+x@units+")" 
  gsn_panel(wks,plots,(/1,2/),resP)
  
  
;---------------------- Cross sections
  
  cross_sec = lon2d(7,36)
  print(cross_sec)
  
  mat = new((/nlat,mlon/),double)
  
  do r = nt, nlat-1
  	do c = nt, mlon-1
		if (lon2d(r,c).eq. cross_sec) then 
			mat(r,c) = x(r,c)
		else
			mat(r,c) = 0
		end if
	end do 
  end do 	
  
  
  maxa = max(mat)
  print(maxa)
