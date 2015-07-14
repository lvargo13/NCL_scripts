 ; Created by Lauren Vargo 06/11/2015

 filestart = toint(getenv("filestart"))
 fileend = toint(getenv("fileend"))

 file_name="CISM1_DiagnosticPlots" 
 GLdat = "Greenland_5km_v1.1_SacksRev_c110629.nc" 
 d = addfile(GLdat,"r")
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
 	myfilename = "BG_CISM1_parallel_updating.cism.h.0"+sprintf("%1.0f",k)+"-01-01-00000.nc"
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
  
 loadscript("All_CISM_Avg.ncl")  ; calls CISM2_plots.ncl
