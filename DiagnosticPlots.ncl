 ; Created by Lauren Vargo 06/11/2015

 filestart = toint(getenv("filestart"))
 fileend = toint(getenv("fileend"))
 dataF = getenv("dataF")
 modelPreName = getenv("modelPreName")
 modelPostName = getenv("modelPostName")
 
 file_name="CISM1_DiagnosticPlots" 
 d = addfile(dataF,"r")
 nt = 0
 lat2d = d->lat(nt,:,:)   
 lon2d = d->lon(nt,:,:)
 dimgrd= dimsizes(lat2d)
 nlat  = dimgrd(0)        
 mlon  = dimgrd(1)  

 smbacc = new((/nlat,mlon/),double,"No_FillValue")
 tempacc = new((/nlat,mlon/),double,"No_FillValue")
 thkacc = new((/nlat,mlon/),double,"No_FillValue")
 topgacc = new((/nlat,mlon/),double,"No_FillValue")
 usurfacc = new((/nlat,mlon/),double,"No_FillValue")
 uvelacc = new((/nlat-1,mlon-1/),double,"No_FillValue")
 vvelacc = new((/nlat-1,mlon-1/),double,"No_FillValue")
 
 do k = filestart,fileend
 	myfilename = modelPreName+sprinti("%0.4i",k)+modelPostName
 	f = addfile(myfilename,"r")
	smbacc(:,:) = smbacc(:,:) + f->acab(0,:,:)
	sfacab = f->acab
	tempacc(:,:) = tempacc(:,:) + f->temp(0,0,:,:)
	sftemp = f->temp
	thkacc(:,:) = thkacc(:,:) + f->thk(0,:,:)
	sfthk = f->thk
	topgacc(:,:) = topgacc(:,:) + f->topg(0,:,:)
	sftopg = f->topg
	usurfacc(:,:) = usurfacc(:,:) + f->usurf(0,:,:)
	sfusurf = f->usurf
	uvelacc(:,:) = uvelacc(:,:) + f->uvel(0,0,:,:)
	sfuvel = f->uvel
	vvelacc(:,:) = vvelacc(:,:) + f->vvel(0,0,:,:)
	sfvvel = f->vvel
 end do  
  

load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

;----------- read in netCDF file
  
 smb = smbacc / (fileend - filestart +1)
 temp = tempacc / (fileend - filestart +1)
 thk = thkacc / (fileend - filestart +1)
 topg = topgacc / (fileend - filestart +1)
 usurf = usurfacc / (fileend - filestart +1)
 uvel = uvelacc / (fileend - filestart +1)
 vvel = vvelacc / (fileend - filestart +1)
 Vel = ((uvel^2) + (vvel^2))^0.5
 
 if(isatt(sfacab,"scale_factor")) then    ; if statement to apply the scale factor, if applicable
     	smb := smb * sfacab@scale_factor
 end if 
 if(isatt(sftemp,"scale_factor")) then    ; if statement to apply the scale factor, if applicable
     	temp := temp * sftemp@scale_factor
 end if 
 if(isatt(sfthk,"scale_factor")) then    ; if statement to apply the scale factor, if applicable
     	thk := thk * sfthk@scale_factor
 end if 
 if(isatt(sftopg,"scale_factor")) then    ; if statement to apply the scale factor, if applicable
     	topg := topg * sftopg@scale_factor
 end if 
 if(isatt(sfusurf,"scale_factor")) then    ; if statement to apply the scale factor, if applicable
     	usurf := usurf * sfusurf@scale_factor
 end if 
 if(isatt(sfvvel,"scale_factor")) then    ; if statement to apply the scale factor, if applicable
     	Vel := Vel * sfuvel@scale_factor
 end if       

  wks = gsn_open_wks("pdf",file_name)


;----------- Modifications for all contour maps
                                              
  res1                       = True               ; plot mods desired 
  res1@gsnDraw               = False              ; wait to draw the plot until all panels are plotted
  res1@gsnFrame              = False              ; wait to draw the plot until all panels are plotted
  res1@cnFillOn              = True               ; turn on color
  res1@cnFillMode            = "RasterFill"        
  res1@cnLinesOn             = False              ; no black lines between contours
  res1@gsnLeftString         = ""                 ; no subtitle
  res1@gsnRightString        = ""                 ; no subtitle
  res1@cnFillPalette         = "WhiteBlueGreenYellowRed"                 ; select the colormap
  res1@lbTitleOn             = True                                      ; add a title to the label bar
  res1@lbTitleFontHeightF    = 0.015                                     ; change font for the label bar title 
  res1@lbTitlePosition       = "bottom"                                  ; move title to below label bar
  res1@lbLabelFontHeightF    = 0.012               ; font smaller than default
  res1@pmLabelBarHeightF     = 0.1                 ; wider than default
  res1@pmLabelBarWidthF      = 0.3                 ; smaller than default
  res1@trGridType            = "TriangularMesh"
  res1@mpProjection          = "Stereographic"
  res1@mpDataBaseVersion     = "mediumres"
  res1@mpFillOn              = False               ; turn off default land map fill
  res1@mpLimitMode           = "Corners"  
  res1@mpLeftCornerLatF      = lat2d(0,0)
  res1@mpLeftCornerLonF      = lon2d(0,0)
  res1@mpRightCornerLatF     = lat2d(nlat-1,mlon-1)
  res1@mpRightCornerLonF     = lon2d(nlat-1,mlon-1)
  res1@mpCenterLonF          = f->mapping@straight_vertical_longitude_from_pole
  res1@mpCenterLatF          = f->mapping@standard_parallel
  res1@tiMainFontHeightF     = 0.012

  resD = True
  resD@gsnDraw               = False
  resD@gsnFrame              = False
  resD@cnFillOn              = True               ; turn on color
  resD@cnFillMode            = "RasterFill"
  resD@cnLinesOn             = False
  resD@gsnLeftString         = ""
  resD@gsnRightString        = ""
  resD@cnFillPalette         = "MPL_bwr"
  resD@lbTitleOn             = True                                      ; add a title to the label bar
  resD@lbTitleFontHeightF    = 0.015                                      ; change font for the label bar title 
  resD@lbTitlePosition       = "bottom"                                  ; move title to below label bar
  resD@lbLabelFontHeightF    = 0.012
  resD@pmLabelBarHeightF     = 0.1                 ; wider than default
  resD@pmLabelBarWidthF      = 0.3                 ; smaller than default
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
  resD@tiMainFontHeightF     = 0.012

  resP                      = True                ; panel resoources
  resP@gsnMaximize          = True

;------------ Contour Plots
    
  ;---- SBM    
     plot1 = new(3,graphic)            ; create the graphic for the first plot with 3 panels
     
     xGL := d->smb(nt,:,:)             ; read in actual data
     xn := smb
     
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
     totalrange = (maxrange - minrange)*2
     res1@cnLevelSelectionMode = "ManualLevels"
     res1@cnMinLevelValF  = minrange			; set the minimum contour level
     res1@cnMaxLevelValF  = maxrange			; set the maximum contour level
     rng = (maxrange - minrange)/totalrange
     res1@cnLevelSpacingF = rng			; set the interval between contours 
	 
     xn@lat2d = lat2d 
     xn@lon2d = lon2d
     res1@tiMainString   = "CISM mean: Year"+ sprintf("%3.0f",filestart) + " -" + sprintf("%3.0f",fileend)
     res1@lbTitleString  = " ("+sfacab@units+")"     ; label bar laber for first panel
     plot1(0) = gsn_csm_contour_map(wks,xn,res1)     ; create the first panel plot
          
     xGL@lat2d = lat2d
     xGL@lon2d = lon2d
     res1@tiMainString   = "1958-2007 Climatology"
     res1@lbTitleString  = " ("+xGL@units+")" 
     plot1(1) = gsn_csm_contour_map(wks,xGL,res1)
     
     xdif := xn - xGL       ; subtract model from data
     xdif@lat2d = lat2d
     xdif@lon2d = lon2d
     resD@tiMainString   = "Difference (CISM - Data)"
     resD@lbTitleString  = " ("+xGL@units+")"
     symMinMaxPlt (xdif,21,False,resD)
     plot1(2) = gsn_csm_contour_map(wks,xdif,resD)
  
     resP@txString   = xGL@long_name    ; title for first set of plots
     gsn_panel(wks,plot1,(/1,3/),resP)   ; create first set of plots
 
  ;---- Temp
     plot2 = new(3,graphic)

     xGL  := d->surftemp(nt,:,:)
     xn := temp
       
	do r = 0,nlat-1
     		do c = 0,mlon-1
			if ( thk(r,c) .eq. 0 )
				xGL(r,c) = 0
			end if
		end do 
	end do 	
     
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
     totalrange = (maxrange - minrange)/2
     res1@cnLevelSelectionMode := "ManualLevels"
     res1@cnMinLevelValF  := minrange			; set the minimum contour level
     res1@cnMaxLevelValF  := maxrange			; set the maximum contour level
     rng := (maxrange - minrange)/totalrange
     res1@cnLevelSpacingF := rng			; set the interval between contours
  
     xn@lat2d = lat2d
     xn@lon2d = lon2d
     res1@tiMainString   = "CISM mean: Year"+ sprintf("%3.0f",filestart) + " -" + sprintf("%3.0f",fileend)
     res1@lbTitleString  = " ("+sftemp@units+")" 
     plot2(0) = gsn_csm_contour_map(wks,xn,res1)
     
     xGL@lat2d = lat2d
     xGL@lon2d = lon2d
     res1@tiMainString   = "Present day " + xGL@long_name
     res1@lbTitleString  = " ("+sftemp@units+")" 
     plot2(1) = gsn_csm_contour_map(wks,xGL,res1)
     
     xdif := xn - xGL 
     xdif@lat2d = lat2d
     xdif@lon2d = lon2d
     resD@tiMainString   = "Difference (CISM - Data)"
     resD@lbTitleString  = " ("+sftemp@units+")"
     symMinMaxPlt (xdif,21,False,resD)
     plot2(2) = gsn_csm_contour_map(wks,xdif,resD)
  
     resP@txString   := xGL@long_name
     gsn_panel(wks,plot2,(/1,3/),resP)

  ;---- Thickness 
     plot3 = new(3,graphic)

     xGL  := d->thk(nt,:,:)
     xn:= thk
     
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
     totalrange = (maxrange - minrange)/100
     res1@cnLevelSelectionMode := "ManualLevels"
     res1@cnMinLevelValF  := minrange			; set the minimum contour level
     res1@cnMaxLevelValF  := maxrange			; set the maximum contour level
     rng := (maxrange - minrange)/totalrange
     res1@cnLevelSpacingF := rng			; set the interval between contours
          
     xn@lat2d = lat2d
     xn@lon2d = lon2d
     res1@tiMainString   = "CISM mean: Year"+ sprintf("%3.0f",filestart) + " -" + sprintf("%3.0f",fileend)
     res1@lbTitleString  = " ("+sfthk@units+")" 
     plot3(0) = gsn_csm_contour_map(wks,xn,res1)
     
     xGL@lat2d = lat2d
     xGL@lon2d = lon2d
     res1@tiMainString   = "Present day " + xGL@long_name
     res1@lbTitleString  = " ("+xGL@units+")" 
     plot3(1) = gsn_csm_contour_map(wks,xGL,res1)
     
     xdif := xn - xGL 
     xdif@lat2d = lat2d
     xdif@lon2d = lon2d
     resD@tiMainString   = "Difference (CISM - Data)"
     resD@lbTitleString  = " ("+xGL@units+")"
     symMinMaxPlt (xdif,21,False,resD)
     plot3(2) = gsn_csm_contour_map(wks,xdif,resD)
     
     resP@txString   := xGL@long_name
     gsn_panel(wks,plot3,(/1,3/),resP)

  ;---- Topography
     plot4 = new(3,graphic)

     xGL  := d->topg(nt,:,:)
     xn := topg
     
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
     totalrange = (maxrange - minrange)/200
     res1@cnLevelSelectionMode := "ManualLevels"
     res1@cnMinLevelValF  := minrange			; set the minimum contour level
     res1@cnMaxLevelValF  := maxrange			; set the maximum contour level
     rng := (maxrange - minrange)/totalrange
     res1@cnLevelSpacingF := rng			; set the interval between contours

     xn@lat2d = lat2d
     xn@lon2d = lon2d
     res1@tiMainString   = "CISM mean: Year"+ sprintf("%3.0f",filestart) + " -" + sprintf("%3.0f",fileend)
     res1@lbTitleString  = " ("+sftopg@units+")" 
     plot4(0) = gsn_csm_contour_map(wks,xn,res1)
     
     xGL@lat2d = lat2d
     xGL@lon2d = lon2d
     res1@tiMainString   = "Present day " + xGL@long_name
     res1@lbTitleString  = " ("+xGL@units+")" 
     plot4(1) = gsn_csm_contour_map(wks,xGL,res1)
     
     xdif := xn - xGL 
     xdif@lat2d = lat2d
     xdif@lon2d = lon2d
     resD@tiMainString   = "Difference (CISM - Data)"
     resD@lbTitleString  = " ("+xGL@units+")"
     symMinMaxPlt (xdif,21,False,resD)
     plot4(2) = gsn_csm_contour_map(wks,xdif,resD)
  
     resP@txString  := xGL@long_name
     gsn_panel(wks,plot4,(/1,3/),resP)

  ;---- Surface Elevation 
     plot5 = new(3,graphic)

     xGL  := d->usrf(nt,:,:)
     xn := usurf
     
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
     totalrange = (maxrange - minrange)/100
     res1@cnLevelSelectionMode := "ManualLevels"
     res1@cnMinLevelValF  := minrange			; set the minimum contour level
     res1@cnMaxLevelValF  := maxrange			; set the maximum contour level
     rng := (maxrange - minrange)/totalrange
     res1@cnLevelSpacingF := rng			; set the interval between contours

     xn@lat2d = lat2d
     xn@lon2d = lon2d
     res1@tiMainString   = "CISM mean: Year"+ sprintf("%3.0f",filestart) + " -" + sprintf("%3.0f",fileend)
     res1@lbTitleString  = " ("+sfusurf@units+")" 
     plot5(0) = gsn_csm_contour_map(wks,xn,res1)
          
     xGL@lat2d = lat2d
     xGL@lon2d = lon2d
     res1@tiMainString   = "Present day " + xGL@long_name
     res1@lbTitleString  = " ("+xGL@units+")" 
     plot5(1) = gsn_csm_contour_map(wks,xGL,res1)
          
     xdif := xn - xGL 
     xdif@lat2d = lat2d
     xdif@lon2d = lon2d
     resD@tiMainString   = "Difference (CISM - Data)"
     resD@lbTitleString  = " ("+xGL@units+")"
     symMinMaxPlt (xdif,21,False,resD)
     plot5(2) = gsn_csm_contour_map(wks,xdif,resD)
  
     resP@txString   := xGL@long_name
     gsn_panel(wks,plot5,(/1,3/),resP)
     
  ;---- Absolute Velocity (Top Layer)   
     plot6 = new(3,graphic)
 
     g = addfile("Joughin-GIS-InSAR-Vels-2015-1km.nc","r")
     vx = g->vx(nt,:,:)   
     vy = g->vy(nt,:,:)
     Velm := ((vx^2) + (vy^2))^0.5
     xi = ispan(1,1501,1)
     yi = ispan(1,2801,1)
     klon = ispan(1,300,1)
     klat = ispan(1,560,1)
     Velmeas = linint2 (xi,yi,Velm,False,klon,klat,0)
     
     	do r = 0,559
     		do c = 0,299
			if ( Velmeas(r,c) .gt. 20000 )
				Velmeas(r,c) = 20000
			end if
		end do 
	end do 	
     
     xGL  := d->surfvelmag(nt,0:nlat-2,0:mlon-2)
     xGLfine := Velmeas
     xn := Vel
     
     maxmod := ceil(max(xn))
     maxmeas := ceil(max(xGLfine))
     if maxmod .ge. maxmeas
     	maxrange  := maxmod
     else
     	maxrange  := maxmeas
     end if
     lnmax = log10(max(maxrange))
     res1@cnLevelSelectionMode = "ExplicitLevels"                        ; set explicit contour levels 
     ;logspace = (10)^(fspan(0,lnmax,21))       ; logrithmically spaced contours
     logspace = ((/1,10,100,1000,10000/))
     res1@cnLevels = (logspace)                             ; set levels 
     
     xn@lat2d = lat2d
     xn@lon2d = lon2d
     res1@tiMainString   = "CISM mean: Year"+ sprintf("%3.0f",filestart) + " -" + sprintf("%3.0f",fileend)
     res1@lbTitleString  = " ("+sfvvel@units+")" 
     plot6(0) = gsn_csm_contour_map(wks,xn,res1)
          
     xGLfine@lat2d = lat2d
     xGLfine@lon2d = lon2d
     res1@tiMainString   = "Present day " + xGL@long_name
     res1@lbTitleString  = " ("+xGL@units+")" 
     plot6(1) = gsn_csm_contour_map(wks,xGLfine,res1)
          
     xdif := xn - xGLfine
     resD@cnLevelSelectionMode = "ExplicitLevels"                        ; set explicit contour levels 
     logspace := ((/-10000,-1000,-100,-10,-1,0,1,10,100,1000,10000/))
     resD@cnLevels = (logspace) 
     xdif@lat2d = lat2d
     xdif@lon2d = lon2d
     resD@tiMainString   = "Difference (CISM - Data)"
     resD@lbTitleString  = " ("+xGL@units+")"
     plot6(2) = gsn_csm_contour_map(wks,xdif,resD)
  
     resP@txString   := xGL@long_name
     gsn_panel(wks,plot6,(/1,3/),resP)
