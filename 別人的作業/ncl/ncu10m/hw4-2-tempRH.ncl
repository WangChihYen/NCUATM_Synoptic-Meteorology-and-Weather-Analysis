


   fasc = "*obs"   ; a unique identifier for files
   FASC = "weekdata.asc"    ; output file name

   ; Use UNIX "cat" to concatenate the files into one file.
   system ("cat "+fasc+" > "+FASC)

   ;**************************

   ;readdata
   data  = asciiread("weekdata.asc",-1,"float")
   ;print(data)
   ncol  = 22                               ; # of columns
   npts  = dimsizes(data)/ncol             ; # of points

   stationdata = onedtond(data,(/npts,ncol/)) ; npts x ncol

   stn    = stationdata(:,1)     ; station numbers
   year   = stationdata(:,3)
   day    = stationdata(:,5)
   hhmm   = stationdata(:,7)
   winspd = stationdata(:,9)
   windir = stationdata(:,11)
   temp   = stationdata(:,13)
   rh     = stationdata(:,15)
   slp    = stationdata(:,17)
   rad    = stationdata(:,19)
   rr     = stationdata(:,21)
   ;***************************
   ;specify parameters
   dt=fspan(0,0.9999,1440)
   timefra=new((/1440*7/),"float")
   do j=0,6,1
      do i= 0,1439,1
         timefra(j*1440+i)=day(j*1440+i)+dt(i)
      end do
   end do
   ;print(timefra)
   time="0119 To 25"
   par1="Temp"
   par2="RH"
   color1="maroon1"
   color2="seagreen4"
   labels=(/par1,par2/)
   axismax1=20.
   axismin1=0.
   axismax2=100.
   axismin2=50.
   Laxisstring="degree"
   Raxisstring="%"
   ;***************************
   ; plot parameters
   ;***************************
   wks = gsn_open_wks("png","hw4-2"+par1+"&"+par2)                    ; send graphics to PNG file 

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
   resL@tmXBValues             = (/19,20,21,22,23,24,25,26/)
   resL@tmXBLabels             = (/"01/19","01/20","01/21","01/22","01/23","01/24","01/25","01/26"/)

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
   resR@tmXBValues             = (/19,20,21,22,23,24,25,26/)
   resR@tmXBLabels             = (/"01/19","01/20","01/21","01/22","01/23","01/24","01/25","01/26"/)
   plot = gsn_csm_xy2(wks,timefra,temp,rh,resL,resR)
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
