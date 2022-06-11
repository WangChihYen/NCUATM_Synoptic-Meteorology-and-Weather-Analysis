
   ;readdata
   data  = asciiread("160124.obs",-1,"float")
   ncol  = 22                               ; # of columns
   npts  = dimsizes(data)/ncol             ; # of points

   stationdata = onedtond(data,(/npts,ncol/)) ; npts x ncol

   stn    = stationdata(:,1)     ; station numbers
   year   = stationdata(:,3)
   day    = stationdata(:,5)
   hhmm   = stationdata(:,7)
   ws     = stationdata(:,9)
   wd     = stationdata(:,11)
   temp   = stationdata(:,13)
   rh     = stationdata(:,15)
   slp    = stationdata(:,17)
   rad    = stationdata(:,19)
   rr     = stationdata(:,21)
   ;***************************
   ;specify parameters
   time="20160124"
   par1="WD"
   par2="WS"
   color1="blue"
   color2="gold1"
   labels=(/par1,par2/)
   axismax1=360.
   axismin1=0.
   axismax2=10.
   axismin2=0.
   Laxisstring="degree"
   Raxisstring="m/s"
   ;***************************
   ; plot parameters
   ;***************************
   wks = gsn_open_wks("png","hw4-1"+par1+"&"+par2)                    ; send graphics to PNG file 

   resL                        = True 
   resL@gsnDraw                = False                   ; don't draw yet
   resL@gsnFrame               = False                   ; don't advance frame yet
   resL@xyLineThicknesses      = 4.                   ; thicker line
   resL@tiYAxisString          = Laxisstring        ; axis string
   resL@xyLineColors           = color1
   resL@trYMinF                = axismin1                  ;axis min
   resL@trYMaxF                = axismax1                  ;axis max
   resL@vpHeightF              = 0.3                    ; change aspect ratio of plot
   resL@vpWidthF               = 0.6
   resL@tmXBMode               = "Explicit"
   resL@tmXBValues             = (/00,400,800,1200,1600,2000,2400/)
   resL@tmXBLabels             = (/"00:00","04:00","08:00","12:00","16:00","20:00","24:00"/)


   ; resources for "right" variable
   resR                        = True                      
   resR@xyLineThicknesses      = 4                    ; thicker line
   resR@tiYAxisString          = Raxisstring                 ; axis string
   resR@trYMaxF                = axismax2                 ; axis max
   resR@trYMinF                = axismin2                  ; axis min
   resR@tiMainString           = time+" "+par1+"&"+par2    ; title
   resR@xyLineColors           = color2               ; line color
   resR@vpHeightF              = 0.3                    ; change aspect ratio of plot
   resR@vpWidthF               = 0.6
   resR@tmXBMode               = "Explicit"
   resR@tmXBValues             = (/00,400,800,1200,1600,2000,2400/)
   resR@tmXBLabels             = (/"00:00","04:00","08:00","12:00","16:00","20:00","24:00"/)
   plot = gsn_csm_xy2(wks,hhmm,wd,ws,resL,resR)
   ;set up label bar
      
   lbres                    = True          ; labelbar only resources
   lbres@lbAutoManage       = False         ; Necessary to control sizes
   lbres@vpWidthF           = 0.15          ; labelbar width
   lbres@vpHeightF          = 0.10          ; labelbar height
   lbres@vpXF               = 0.73         ; labelbar position in x direction 
   lbres@vpYF               = 0.9         ; labelbar position in y direction
   lbres@lbBoxMajorExtentF  = 0.15        ; puts space between color boxes
   lbres@lbFillColors       = (/color1,color2/)   ; labelbar colors        
   lbres@lbMonoFillPattern  = True          ; Solid fill pattern
   lbres@lbLabelFontHeightF = 0.01         ; font height. default is small
   lbres@lbPerimOn          = False

   ; Create labels

   lbid = gsn_create_labelbar(wks,2,labels,lbres)
   draw(plot)                                                
   draw(lbid)
   frame(wks)
