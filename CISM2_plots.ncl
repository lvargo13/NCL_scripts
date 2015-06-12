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


;----------- contour map modifications
                                              
  wks = gsn_open_wks("pdf",file_name)   

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

  plots = new(1,graphic)   ; new plots, with one plot per page   
  
  var  := f->$var$
  
  ;-- if statment to determine whether variable is 3d or 4d 
  if ( (dimsizes(dimsizes(var))) .eq. 3 ) then
  	var := var(nt,:,:)
  else if ( (dimsizes(dimsizes(var))) .eq. 4 ) then
  	var := var(nt,lev,:,:)
  else
  	print("Error with indexing")
  end if
  end if 
     
  var@lat2d = lat2d
  var@lon2d = lon2d

  res@cnFillPalette = "WhiteBlueGreenYellowRed"
  res@tfDoNDCOverlay = False 
     
  plots(0) = gsn_csm_contour_map(wks,var,res)

  resP@txString      = var@long_name+" ("+var@units+")" 
  gsn_panel(wks,plots,(/1,2/),resP)
  
  
;---------------------- Cross sections
  
 ; mat = new((/nlat,mlon/),double)
  
 ; do r = nt, nlat-1
 ; 	do c = nt, mlon-1 
;		if ( lon2d(r,c) .eq. (lon2d(7,36)) ) then 
;			mat(r,c) = x(r,c)
;		else
;			mat(r,c) = 0
;		end if
;	end do 
;  end do 	
;  
;  print(lon2d(7,36))
;  maxa = max(mat)
;  mina = min(mat)
;  print(mina)
;  print(maxa) 
