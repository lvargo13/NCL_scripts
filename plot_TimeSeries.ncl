; plots time series of ice volume and ice area
; called by plot_TimeSeries.sh 

Vol = asciiread("Vol_TS_data.sh",-1,"float")
Area = asciiread("Area_TS_data.sh",-1,"float")

year = ispan(1,201,1)

wks   = gsn_open_wks ("pdf","TimeSeries")
plot = new(2,graphic)

resV = True  
resA = True

resV@gsnDraw = False 
resA@gsnDraw = False                 
resV@gsnFrame = False                      
resA@gsnFrame = False  

resV@tiMainString = " "
resV@tiXAxisString = "Year"
resV@tiYAxisString = "Ice Volume (km^3)"
resA@tiMainString = " "
resA@tiXAxisString = "Year"
resA@tiYAxisString = "Ice Area (km^2)"

resV@vpHeightF= 0.4          
resV@vpWidthF = 0.8
resA@vpHeightF= 0.4          
resA@vpWidthF = 0.8

plot(0) = gsn_csm_xy (wks,year,Vol,resV)
plot(1) = gsn_csm_xy (wks,year,Area,resA)

resP = True 
resP@txString = "BG_CISM1 Time Series"
resP@gsnPanelLabelBar = True
gsn_panel(wks,plot,(/2,1/),resP)
