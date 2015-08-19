 ; Created by Lauren Vargo 07/29/2015
 ; Compare two CISM output netCDF files

; Read files from bash script
 filestart = toint(getenv("filestart"))
 fileend = toint(getenv("fileend"))
 modelAPreName = getenv("modelAPreName")
 modelAPostName = getenv("modelAPostName")
 modelBPreName = getenv("modelBPreName")
 modelBPostName = getenv("modelBPostName")
 latlon = getenv("latlon")
 FileAname = getenv("FileAname")
 FileBname = getenv("FileBname")

 file_name="CISM_Comparison_plots" 
 
; Lat lon data 
 d = addfile(latlon,"r")
 nt = 0
 lat2d = d->lat(nt,:,:)   
 lon2d = d->lon(nt,:,:)
 dimgrd= dimsizes(lat2d)
 nlat  = dimgrd(0)        
 mlon  = dimgrd(1)  

; Create new (empty) matricies
 smbaccA = new((/nlat,mlon/),double,"No_FillValue")
 tempaccA = new((/nlat,mlon/),double,"No_FillValue")
 thkaccA = new((/nlat,mlon/),double,"No_FillValue")
 topgaccA = new((/nlat,mlon/),double,"No_FillValue")
 usurfaccA = new((/nlat,mlon/),double,"No_FillValue")
 uvelaccA = new((/nlat-1,mlon-1/),double,"No_FillValue")
 vvelaccA = new((/nlat-1,mlon-1/),double,"No_FillValue")
 
 smbaccB = new((/nlat,mlon/),double,"No_FillValue")
 tempaccB = new((/nlat,mlon/),double,"No_FillValue")
 thkaccB = new((/nlat,mlon/),double,"No_FillValue")
 topgaccB = new((/nlat,mlon/),double,"No_FillValue")
 usurfaccB = new((/nlat,mlon/),double,"No_FillValue")
 uvelaccB = new((/nlat-1,mlon-1/),double,"No_FillValue")
 vvelaccB = new((/nlat-1,mlon-1/),double,"No_FillValue")
 
; CISM File A 
 do k = filestart,fileend
 	myfilenameA = modelAPreName+sprinti("%0.4i",k)+modelAPostName
 	fA = addfile(myfilenameA,"r")
	smbaccA(:,:) = smbaccA(:,:) + fA->acab(0,:,:)
	sfacabA = fA->acab
	tempaccA(:,:) = tempaccA(:,:) + fA->tempstag(0,0,:,:)
	sftempA = fA->tempstag
	thkaccA(:,:) = thkaccA(:,:) + fA->thk(0,:,:)
	sfthkA = fA->thk
	topgaccA(:,:) = topgaccA(:,:) + fA->topg(0,:,:)
	sftopgA = fA->topg
	usurfaccA(:,:) = usurfaccA(:,:) + fA->usurf(0,:,:)
	sfusurfA = fA->usurf
	uvelaccA(:,:) = uvelaccA(:,:) + fA->uvel(0,0,:,:)
	sfuvelA = fA->uvel
	vvelaccA(:,:) = vvelaccA(:,:) + fA->vvel(0,0,:,:)
	sfvvelA = fA->vvel
 end do  
 
; CISM File B  
 do k = filestart,fileend
 	myfilenameB = modelBPreName+sprinti("%0.4i",k)+modelBPostName
 	fB = addfile(myfilenameB,"r")
	smbaccB(:,:) = smbaccB(:,:) + fB->acab(0,:,:)
	sfacabB = fB->acab
	tempaccB(:,:) = tempaccB(:,:) + fB->tempstag(0,0,:,:)
	sftempB = fB->tempstag
	thkaccB(:,:) = thkaccB(:,:) + fB->thk(0,:,:)
	sfthkB = fB->thk
	topgaccB(:,:) = topgaccB(:,:) + fB->topg(0,:,:)
	sftopgB = fB->topg
	usurfaccB(:,:) = usurfaccB(:,:) + fB->usurf(0,:,:)
	sfusurfB = fB->usurf
	uvelaccB(:,:) = uvelaccB(:,:) + fB->uvel(0,0,:,:)
	sfuvelB = fB->uvel
	vvelaccB(:,:) = vvelaccB(:,:) + fB->vvel(0,0,:,:)
	sfvvelB = fB->vvel
 end do 
 
 
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

;----------- read in netCDF file
  
 smbA = smbaccA / (fileend - filestart +1)
 tempA = tempaccA / (fileend - filestart +1)
 thkA = thkaccA / (fileend - filestart +1)
 topgA = topgaccA / (fileend - filestart +1)
 usurfA = usurfaccA / (fileend - filestart +1)
 uvelA = uvelaccA / (fileend - filestart +1)
 vvelA = vvelaccA / (fileend - filestart +1)
 VelA = ((uvelA^2) + (vvelA^2))^0.5
 
 smbB = smbaccB / (fileend - filestart +1)
 tempB = tempaccB / (fileend - filestart +1)
 thkB = thkaccB / (fileend - filestart +1)
 topgB = topgaccB / (fileend - filestart +1)
 usurfB = usurfaccB / (fileend - filestart +1)
 uvelB = uvelaccB / (fileend - filestart +1)
 vvelB = vvelaccB / (fileend - filestart +1)
 VelB = ((uvelB^2) + (vvelB^2))^0.5
 
 
 if(isatt(sfacabA,"scale_factor")) then    ; if statement to apply the scale factor, if applicable
     	smbA := smbA * sfacabA@scale_factor
 	smbB := smbB * sfacabB@scale_factor
 end if 
 if(isatt(sftempA,"scale_factor")) then    ; if statement to apply the scale factor, if applicable
     	tempA := tempA * sftempA@scale_factor
 	tempB := tempB * sftempB@scale_factor
 end if 
 if(isatt(sfthkA,"scale_factor")) then    ; if statement to apply the scale factor, if applicable
     	thkA := thkA * sfthkA@scale_factor
 	thkB := thkB * sfthkB@scale_factor
 end if 
 if(isatt(sftopgA,"scale_factor")) then    ; if statement to apply the scale factor, if applicable
     	topgA := topgA * sftopgA@scale_factor
 	topgB := topgB * sftopgB@scale_factor
 end if 
 if(isatt(sfusurfA,"scale_factor")) then    ; if statement to apply the scale factor, if applicable
     	usurfA := usurfA * sfusurfA@scale_factor
 	usurfB := usurfB * sfusurfB@scale_factor
 end if 
 if(isatt(sfvvelA,"scale_factor")) then    ; if statement to apply the scale factor, if applicable
     	VelA := VelA * sfuvelA@scale_factor
 	VelB := VelB * sfuvelB@scale_factor
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
  res1@mpCenterLonF          = fA->mapping@straight_vertical_longitude_from_pole
  res1@mpCenterLatF          = fA->mapping@standard_parallel
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
  resD@mpCenterLonF          = fA->mapping@straight_vertical_longitude_from_pole
  resD@mpCenterLatF          = fA->mapping@standard_parallel
  resD@tiMainFontHeightF     = 0.012

  resP                      = True                ; panel resoources
  resP@gsnMaximize          = True

;------------ Contour Plots
    
  ;---- SBM    
     plot1 = new(3,graphic)            ; create the graphic for the first plot with 3 panels
     
     xA := smbA
     xB := smbB
     
     maxmod = ceil(max(xA))
     maxmeas = ceil(max(xB))
     minmod = floor(min(xA))
     minmeas = floor(min(xB))
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
	 
     xA@lat2d = lat2d 
     xA@lon2d = lon2d
     res1@tiMainString   = (FileAname + " Year"+ sprintf("%3.0f",filestart) + " -" + sprintf("%3.0f",fileend) + " mean")
     res1@lbTitleString  = " ("+sfacabA@units+")"     ; label bar laber for first panel
     plot1(0) = gsn_csm_contour_map(wks,xA,res1)     ; create the first panel plot
          
     xB@lat2d = lat2d
     xB@lon2d = lon2d
     res1@tiMainString   = (FileBname + " Year"+ sprintf("%3.0f",filestart) + " -" + sprintf("%3.0f",fileend) + " mean")
     res1@lbTitleString  = " ("+sfacabB@units+")" 
     plot1(1) = gsn_csm_contour_map(wks,xB,res1)
     
     xdif := xA - xB           		
     xdif@lat2d = lat2d
     xdif@lon2d = lon2d
     resD@tiMainString   = "Difference (File A - File B)"
     resD@lbTitleString  = " ("+sfacabB@units+")"
     symMinMaxPlt (xdif,21,False,resD)
     plot1(2) = gsn_csm_contour_map(wks,xdif,resD)
  
     resP@txString   = sfacabB@long_name    ; title for first set of plots
     gsn_panel(wks,plot1,(/1,3/),resP)   ; create first set of plots
 
  ;---- Temp
     plot2 = new(3,graphic)

     xA := tempA
     xB := tempB 
       
	do r = 0,nlat-1
     		do c = 0,mlon-1
			if ( thkA(r,c) .eq. 0 )
				xA(r,c) = 0
			end if
		end do 
	end do 	
     	do r = 0,nlat-1
     		do c = 0,mlon-1
			if ( thkB(r,c) .eq. 0 )
				xB(r,c) = 0
			end if
		end do 
	end do 
	
     maxmod := ceil(max(xA))
     maxmeas := ceil(max(xB))
     minmod := floor(min(xA))
     minmeas := floor(min(xB))
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
     totalrange := (maxrange - minrange)/2
     res1@cnLevelSelectionMode := "ManualLevels"
     res1@cnMinLevelValF  := minrange			; set the minimum contour level
     res1@cnMaxLevelValF  := maxrange			; set the maximum contour level
     rng := (maxrange - minrange)/totalrange
     res1@cnLevelSpacingF := rng			; set the interval between contours
  
     xA@lat2d = lat2d
     xA@lon2d = lon2d
     res1@tiMainString   = (FileAname + " Year"+ sprintf("%3.0f",filestart) + " -" + sprintf("%3.0f",fileend) + " mean")
     res1@lbTitleString  = " ("+sftempA@units+")" 
     plot2(0) = gsn_csm_contour_map(wks,xA,res1)
     
     xB@lat2d = lat2d
     xB@lon2d = lon2d
     res1@tiMainString   = (FileBname + " Year"+ sprintf("%3.0f",filestart) + " -" + sprintf("%3.0f",fileend) + " mean")
     res1@lbTitleString  = " ("+sftempB@units+")" 
     plot2(1) = gsn_csm_contour_map(wks,xB,res1)
     
     xdif := xA - xB 
     xdif@lat2d = lat2d
     xdif@lon2d = lon2d
     resD@tiMainString   = "Difference (File A - File B)"
     resD@lbTitleString  = " ("+sftempB@units+")"
     symMinMaxPlt (xdif,21,False,resD)
     plot2(2) = gsn_csm_contour_map(wks,xdif,resD)
  
     resP@txString   := "Ice Surface Temperature"
     gsn_panel(wks,plot2,(/1,3/),resP)

  ;---- Thickness 
     plot3 = new(3,graphic)

     xA := thkA
     xB := thkB
     
     maxmod := ceil(max(xA))
     maxmeas := ceil(max(xB))
     minmod := floor(min(xA))
     minmeas := floor(min(xB))
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
     totalrange := (maxrange - minrange)/100
     res1@cnLevelSelectionMode := "ManualLevels"
     res1@cnMinLevelValF  := minrange			; set the minimum contour level
     res1@cnMaxLevelValF  := maxrange			; set the maximum contour level
     rng := (maxrange - minrange)/totalrange
     res1@cnLevelSpacingF := rng			; set the interval between contours
          
     xA@lat2d = lat2d
     xA@lon2d = lon2d
     res1@tiMainString   = (FileAname + " Year"+ sprintf("%3.0f",filestart) + " -" + sprintf("%3.0f",fileend) + " mean")
     res1@lbTitleString  = " ("+sfthkA@units+")" 
     plot3(0) = gsn_csm_contour_map(wks,xA,res1)
     
     xB@lat2d = lat2d
     xB@lon2d = lon2d
     res1@tiMainString   = (FileBname + " Year"+ sprintf("%3.0f",filestart) + " -" + sprintf("%3.0f",fileend) + " mean")
     res1@lbTitleString  = " ("+sfthkB@units+")" 
     plot3(1) = gsn_csm_contour_map(wks,xB,res1)
     
     xdif := xA - xB 
     xdif@lat2d = lat2d
     xdif@lon2d = lon2d
     resD@tiMainString   = "Difference (File A - File B)"
     resD@lbTitleString  = " ("+sfthkB@units+")"
     symMinMaxPlt (xdif,21,False,resD)
     plot3(2) = gsn_csm_contour_map(wks,xdif,resD)
     
     resP@txString   := sfthkB@long_name
     gsn_panel(wks,plot3,(/1,3/),resP)

  ;---- Topography
     plot4 = new(3,graphic)

     xA := topgA
     xB := topgB
     
     do r = 0,nlat-1
     		do c = 0,mlon-1
			if ( topgA(r,c) .gt. 10000 )
				xA(r,c) = 0
			end if
		end do 
	end do 	
     	do r = 0,nlat-1
     		do c = 0,mlon-1
			if ( topgB(r,c) .gt. 10000 )
				xB(r,c) = 0
			end if
		end do 
	end do 
	
     maxmod := ceil(max(xA))
     maxmeas := ceil(max(xB))
     minmod := floor(min(xA))
     minmeas := floor(min(xB))
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
     totalrange := (maxrange - minrange)/200
     res1@cnLevelSelectionMode := "ManualLevels"
     res1@cnMinLevelValF  := minrange			; set the minimum contour level
     res1@cnMaxLevelValF  := maxrange			; set the maximum contour level
     rng := (maxrange - minrange)/totalrange
     res1@cnLevelSpacingF := rng			; set the interval between contours

     xA@lat2d = lat2d
     xA@lon2d = lon2d
     res1@tiMainString   = (FileAname + " Year"+ sprintf("%3.0f",filestart) + " -" + sprintf("%3.0f",fileend) + " mean")
     res1@lbTitleString  = " ("+sftopgA@units+")" 
     plot4(0) = gsn_csm_contour_map(wks,xA,res1)
     
     xB@lat2d = lat2d
     xB@lon2d = lon2d
     res1@tiMainString   = (FileBname + " Year"+ sprintf("%3.0f",filestart) + " -" + sprintf("%3.0f",fileend) + " mean")
     res1@lbTitleString  = " ("+sftopgB@units+")" 
     plot4(1) = gsn_csm_contour_map(wks,xB,res1)
     
     xdif := xA - xB 
     xdif@lat2d = lat2d
     xdif@lon2d = lon2d
     resD@tiMainString   = "Difference (File A - File B)"
     resD@lbTitleString  = " ("+sftopgB@units+")"
     symMinMaxPlt (xdif,21,False,resD)
     plot4(2) = gsn_csm_contour_map(wks,xdif,resD)
  
     resP@txString  := sftopgB@long_name
     gsn_panel(wks,plot4,(/1,3/),resP)

  ;---- Surface Elevation 
     plot5 = new(3,graphic)

     xA := usurfA
     xB := usurfB
     
     do r = 0,nlat-1
     		do c = 0,mlon-1
			if ( usurfA(r,c) .gt. 10000 )
				xA(r,c) = 0
			end if
		end do 
	end do 	
     	do r = 0,nlat-1
     		do c = 0,mlon-1
			if ( usurfB(r,c) .gt. 10000 )
				xB(r,c) = 0
			end if
		end do 
	end do 
	
     maxmod := ceil(max(xA))
     maxmeas := ceil(max(xB))
     minmod := floor(min(xA))
     minmeas := floor(min(xB))
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
     totalrange := (maxrange - minrange)/100
     res1@cnLevelSelectionMode := "ManualLevels"
     res1@cnMinLevelValF  := minrange			; set the minimum contour level
     res1@cnMaxLevelValF  := maxrange			; set the maximum contour level
     rng := (maxrange - minrange)/totalrange
     res1@cnLevelSpacingF := rng			; set the interval between contours

     xA@lat2d = lat2d
     xA@lon2d = lon2d
     res1@tiMainString   = (FileAname + " Year"+ sprintf("%3.0f",filestart) + " -" + sprintf("%3.0f",fileend) + " mean")
     res1@lbTitleString  = " ("+sfusurfA@units+")" 
     plot5(0) = gsn_csm_contour_map(wks,xA,res1)
          
     xB@lat2d = lat2d
     xB@lon2d = lon2d
     res1@tiMainString   = (FileBname + " Year"+ sprintf("%3.0f",filestart) + " -" + sprintf("%3.0f",fileend) + " mean")
     res1@lbTitleString  = " ("+sfusurfB@units+")" 
     plot5(1) = gsn_csm_contour_map(wks,xB,res1)
          
     xdif := xA - xB 
     xdif@lat2d = lat2d
     xdif@lon2d = lon2d
     resD@tiMainString   = "Difference (File A - File B)"
     resD@lbTitleString  = " ("+sfusurfB@units+")"
     symMinMaxPlt (xdif,21,False,resD)
     plot5(2) = gsn_csm_contour_map(wks,xdif,resD)
  
     resP@txString   := sfusurfB@long_name
     gsn_panel(wks,plot5,(/1,3/),resP)
     
  ;---- Absolute Velocity (Top Layer)   
     plot6 = new(3,graphic)
 
     xA := VelA
     xB := VelB
     
     maxmod := ceil(max(xA))
     maxmeas := ceil(max(xB))
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
     
     xA@lat2d = lat2d
     xA@lon2d = lon2d
     res1@tiMainString   = (FileAname + " Year"+ sprintf("%3.0f",filestart) + " -" + sprintf("%3.0f",fileend) + " mean")
     res1@lbTitleString  = " ("+sfvvelA@units+")" 
     plot6(0) = gsn_csm_contour_map(wks,xA,res1)
          
     xB@lat2d = lat2d
     xB@lon2d = lon2d
     res1@tiMainString   = (FileBname + " Year"+ sprintf("%3.0f",filestart) + " -" + sprintf("%3.0f",fileend) + " mean")
     res1@lbTitleString  = " ("+sfvvelB@units+")" 
     plot6(1) = gsn_csm_contour_map(wks,xB,res1)
          
     xdif := xA - xB
     resD@cnLevelSelectionMode = "ExplicitLevels"                        ; set explicit contour levels 
     logspace := ((/-10000,-1000,-100,-10,-1,0,1,10,100,1000,10000/))
     resD@cnLevels = (logspace) 
     xdif@lat2d = lat2d
     xdif@lon2d = lon2d
     resD@tiMainString   = "Difference (File A - File B)"
     resD@lbTitleString  = " ("+sfvvelB@units+")"
     plot6(2) = gsn_csm_contour_map(wks,xdif,resD)
  
     resP@txString   := "Ice Velocity"
     gsn_panel(wks,plot6,(/1,3/),resP)
