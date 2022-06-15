begin
;================================
;read data
;================================
 f1 = asciiread("160119.txt",(/1440,22/),"float")
 ti = f1(:,7)     ;time
 tp = f1(:,13)    ;temperature
 ap = f1(:,17)    ;atmospheric pressure

 f2 = asciiread("160120.txt",(/1440,22/),"float")
 ti2 = f2(:,7)     ;time
 tp2 = f2(:,13)    ;temperature
 ap2 = f2(:,17)    ;atmospheric pressure

 f3 = asciiread("160121.txt",(/1440,22/),"float")
 ti3 = f3(:,7)     ;time
 tp3 = f3(:,13)    ;temperature
 ap3 = f3(:,17)    ;atmospheric pressure

 f4 = asciiread("160122.txt",(/1440,22/),"float")
 ti4 = f4(:,7)     ;time
 tp4 = f4(:,13)    ;temperature
 ap4 = f4(:,17)    ;atmospheric pressure

 f5 = asciiread("160123.txt",(/1440,22/),"float")
 ti5 = f5(:,7)     ;time
 tp5 = f5(:,13)    ;temperature
 ap5 = f5(:,17)    ;atmospheric pressure
 
 f6 = asciiread("160124.txt",(/1440,22/),"float")
 ti6 = f6(:,7)     ;time
 tp6 = f6(:,13)    ;temperature
 ap6 = f6(:,17)    ;atmospheric pressure

 f7 = asciiread("160125.txt",(/1440,22/),"float")
 ti7 = f7(:,7)     ;time
 tp7 = f7(:,13)    ;temperature
 ap7 = f7(:,17)    ;atmospheric pressure

 avet19 = avg(tp)  ;calculate the average
 avet20 = avg(tp2) 
 avet21 = avg(tp3)
 avet22 = avg(tp4)
 avet23 = avg(tp5)
 avet24 = avg(tp6)
 avet25 = avg(tp7)

 a = (/avet19,avet20,avet21,avet22,avet23,avet24,avet25/) ; creat a matrix (data1tavg)

 print(a)

 avep19 = avg(ap) ;calculate the average
 avep20 = avg(ap2)
 avep21 = avg(ap3)
 avep22 = avg(ap4)
 avep23 = avg(ap5)
 avep24 = avg(ap6)
 avep25 = avg(ap7)

 b = (/avep19,avep20,avep21,avep22,avep23,avep24,avep25/) ; creat b matrix (data2tavg)
 print(b)

 t = ispan(0,6,1)  ; creat t matrix (time)
 print(t)

;=================================
;plot
;=================================

 wks   = gsn_open_wks ("png","avg")                  ; send graphics to PNG file

;---------------------left----------------------------

 resl                  = True                                 ; plot mods desired
 resl@tiMainString     = "average temperature & pressure"     ; add title
 resl@tiMainOffsetYF   = 0.05                                 ; title size
 resl@tiMainFontHeightF = 0.04                                ; chang title hight
 resl@gsnMaximize      = True                                 ; plot will be fill the biggest possible space
 resl@vpKeepAspect     = True                                 ; keep aspect
 resl@vpWidthF         = 1.5                                  ; Change the aspect ratio, but
 resl@vpHeightF        = 0.4                                  ; make plot as large as possible.
 resl@xyLineColor = "rosybrown1"                              ; chang the line color
 resl@xyLineThicknessF = 3                                    ; chang line thickness
 resl@tiYAxisFontColor = resl@xyLineColor                     ; axis font color
 resl@tmXBMode      = "Explicit"                              
 resl@tmXBValues    = (/0,1,2,3,4,5,6,7/)                                                 ; set x value  
 resl@tmXBLabels    = (/"01/19","01/20","01/21","01/22","01/23","01/24","01/25","01/26"/) ; set x labels

;-----------------------right----------------------
 resr = True                                                  ; plot mods desired
 resr@xyLineColor = "bisque4"                                 ; chang the line color
 resr@xyLineThicknessF = 3                                    ; chang line thickness
 resr@tiYAxisFontColor = resr@xyLineColor                     ; axis font color

 ;plot = gsn_csm_xy2(wks,t,a,b,resl,resr)                       ; plot

 plot = gsn_xy(wks,t,a,resl)
 draw(plot)
 exit
;=================================================
;creat labels
;=================================================

 resl                    = True        ; labelbar only resources
 resl@lbAutoManage       = False       ; Necessary to control sizes
 resl@vpWidthF           = 0.2         ; labelbar width
 resl@vpHeightF          = 0.02        ; labelbar height
 resl@vpXF               = 0.29        ; labelbar position in x direction
 resl@vpYF               = 0.66        ; labelbar position in y direction
 resl@lbFillColors       = "rosybrown1"; labelbar colors
 resl@lbMonoFillPattern  = True        ; Solid fill pattern
 resl@lbLabelFontHeightF = 0.015       ; font height. default is small
 resl@lbPerimOn          = False
 labell = gsn_create_labelbar(wks,1,"temperature",resl)   

 resr                    = True        ; labelbar only resources
 resr@lbAutoManage       = False       ; Necessary to control sizes
 resr@vpWidthF           = 0.2         ; labelbar width
 resr@vpHeightF          = 0.02        ; labelbar height
 resr@vpXF               = 0.51        ; labelbar position in x direction
 resr@vpYF               = 0.66        ; labelbar position in y direction
 resr@lbFillColors       = "bisque4"   ; labelbar colors
 resr@lbMonoFillPattern  = True        ; Solid fill pattern
 resr@lbLabelFontHeightF = 0.015       ; font height. default is small
 resr@lbPerimOn          = False
 labelr = gsn_create_labelbar(wks,1,"pressure",resr)

 draw(plot)
 draw(labell)
 draw(labelr)
 frame(wks)

end
