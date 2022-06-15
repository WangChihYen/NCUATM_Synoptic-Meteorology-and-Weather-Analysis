
begin
;=======================================
;read data
;=======================================

 f1 = asciiread("160119.txt",(/1440,22/),"float")
 sd = f1(:,5)     ;solor day
 ti = f1(:,7)     ;time
 ws = f1(:,9)     ;wind speed
 wd = f1(:,11)    ;wind direction
 tp = f1(:,13)    ;temperature
 rh = f1(:,15)    ;RH
 ap = f1(:,17)    ;atmospheric pressure
 ra = f1(:,19)    ;radiance
 pr = f1(:,21)    ;precioitation

 f2 = asciiread("160120.txt",(/1440,22/),"float")
 sd2 = f2(:,5)     ;solor day
 ti2 = f2(:,7)     ;time
 ws2 = f2(:,9)     ;wind speed
 wd2 = f2(:,11)    ;wind direction
 tp2 = f2(:,13)    ;temperature
 rh2 = f2(:,15)    ;RH
 ap2 = f2(:,17)    ;atmospheric pressure
 ra2 = f2(:,19)    ;radiance
 pr2 = f2(:,21)    ;precioitation
 
 f3 = asciiread("160121.txt",(/1440,22/),"float")
 sd3 = f3(:,5)     ;solor day
 ti3 = f3(:,7)     ;time
 ws3 = f3(:,9)     ;wind speed
 wd3 = f3(:,11)    ;wind direction
 tp3 = f3(:,13)    ;temperature
 rh3 = f3(:,15)    ;RH
 ap3 = f3(:,17)    ;atmospheric pressure
 ra3 = f3(:,19)    ;radiance
 pr3 = f3(:,21)    ;precioitation

 f4 = asciiread("160122.txt",(/1440,22/),"float")
 sd4 = f4(:,5)     ;solor day
 ti4 = f4(:,7)     ;time
 ws4 = f4(:,9)     ;wind speed
 wd4 = f4(:,11)    ;wind direction
 tp4 = f4(:,13)    ;temperature
 rh4 = f4(:,15)    ;RH
 ap4 = f4(:,17)    ;atmospheric pressure
 ra4 = f4(:,19)    ;radiance
 pr4 = f4(:,21)    ;precioitation

 f5 = asciiread("160123.txt",(/1440,22/),"float")
 sd5 = f5(:,5)     ;solor day
 ti5 = f5(:,7)     ;time
 ws5 = f5(:,9)     ;wind speed
 wd5 = f5(:,11)    ;wind direction
 tp5 = f5(:,13)    ;temperature
 rh5 = f5(:,15)    ;RH
 ap5 = f5(:,17)    ;atmospheric pressure
 ra5 = f5(:,19)    ;radiance
 pr5 = f5(:,21)    ;precioitation

 f6 = asciiread("160124.txt",(/1440,22/),"float")
 sd6 = f6(:,5)     ;solor day
 ti6 = f6(:,7)     ;time
 ws6 = f6(:,9)     ;wind speed
 wd6 = f6(:,11)    ;wind direction
 tp6 = f6(:,13)    ;temperature
 rh6 = f6(:,15)    ;RH
 ap6 = f6(:,17)    ;atmospheric pressure
 ra6 = f6(:,19)    ;radiance
 pr6 = f6(:,21)    ;precioitation

 f7 = asciiread("160125.txt",(/1440,22/),"float")
 sd7 = f7(:,5)     ;solor day
 ti7 = f7(:,7)     ;time
 ws7 = f7(:,9)     ;wind speed
 wd7 = f7(:,11)    ;wind direction
 tp7 = f7(:,13)    ;temperature
 rh7 = f7(:,15)    ;RH
 ap7 = f7(:,17)    ;atmospheric pressure
 ra7 = f7(:,19)    ;radiance
 pr7 = f7(:,21)    ;precioitation


 a = new((/10080/),float)   ; creat a matrix 
 a(0:1439) = tp             ; put tp in a
 a(1440:2879) = tp2
 a(2880:4319) = tp3
 a(4320:5759) = tp4
 a(5760:7199) = tp5
 a(7200:8639) = tp6
 a(8640:10079) = tp7 
 printVarSummary(a)
 
 b = new((/10080/),float)   ; creat b matrix
 b(0:1439) = rh             ; put tp in b
 b(1440:2879) = rh2
 b(2880:4319) = rh3
 b(4320:5759) = rh4
 b(5760:7199) = rh5
 b(7200:8639) = rh6
 b(8640:10079) = rh7
 printVarSummary(b)

 t = ispan(0,10079,1)       ; creat t matrix (time)

;=================================================
;set data
;=================================================


color1 = "palevioletred2"
;color1 = "goldenrod1"
;color1 = "brown3"
;color1 = "darkorange1"
color2 = "olivedrab"
;color2 = "deepskyblue2"
;color2 = "royalblue"
;color2 = "chartreuse4"

item1 = "temperature"
;item1 = "wind speed"
;tem1 = "pressure"
;item1 = "solar radiation"

item2 = "RH"
;item2 = "wind direction"
;item2 = "rainfall"
;item2 = "solar day"

;===========================================
;plot
;===========================================


 wks  = gsn_open_wks ("png","weektr")                ; send graphics to PNG file

;---------------------left----------------------------
print("=============a===================")
print(a)
 resl                  = True                        ; plot mods desired
 resl@tiMainString     = "1 week temperature & RH"   ; add title
 resl@tiMainOffsetYF   = 0.05                        ; title size
 resl@tiMainFontHeightF = 0.04                       ; chang title hight
 resl@gsnMaximize      = True                        ; plot will be fill the biggest possible space
 resl@vpKeepAspect     = True                        ; keep aspect
 resl@vpWidthF         = 1.5                         ; Change the aspect ratio, but
 resl@vpHeightF        = 0.4                         ; make plot as large as possible.
 resl@xyLineColor = color1                           ; chang the line color
 resl@xyLineThicknessF = 3                           ; chang line thickness
 resl@tiYAxisFontColor = resl@xyLineColor            ; axis font color
 resl@trXMaxF                = 10080                 ; axis max
; resl@trYMaxF                = 360                  ; axis max
 resl@tmXBMode      = "Explicit" 
 resl@tmXBValues    = (/0,1440,2880,4320,5760,7200,8640,10079/)                               ; set x value 
 resl@tmXBLabels    = (/"01/19","01/20","01/21","01/22","01/23","01/24","01/25","01/26"/)     ; set x labels

;-----------------------right----------------------
 resr = True                                         ; plot mods desired
 resr@xyLineColor = color2                           ; chang the line color
 resr@xyLineThicknessF = 3                           ; chang line thickness
 resr@tiYAxisFontColor = resr@xyLineColor            ; axis font color
; resr@trYMaxF                = 3.0                  ; axis max
 
;plot = gsn_csm_xy2(wks,t,a,b,resl,resr)              ; plot
plot = gsn_xy(wks,t,a,resl)
draw(plot)

exit
;================================================
;creat labels
;================================================

 resl                    = True        ; labelbar only resources
 resl@lbAutoManage       = False       ; Necessary to control sizes
 resl@vpWidthF           = 0.2         ; labelbar width
 resl@vpHeightF          = 0.02        ; labelbar height
 resl@vpXF               = 0.32        ; labelbar position in x direction
 resl@vpYF               = 0.66        ; labelbar position in y direction
 resl@lbFillColors       = color1      ; labelbar colors
 resl@lbMonoFillPattern  = True        ; Solid fill pattern
 resl@lbLabelFontHeightF = 0.015       ; font height. default is small
 resl@lbPerimOn          = False
 labell = gsn_create_labelbar(wks,1,item1,resl)

 resr                    = True        ; labelbar only resources
 resr@lbAutoManage       = False       ; Necessary to control sizes
 resr@vpWidthF           = 0.2         ; labelbar width
 resr@vpHeightF          = 0.02        ; labelbar height
 resr@vpXF               = 0.52        ; labelbar position in x direction
 resr@vpYF               = 0.66        ; labelbar position in y direction
 resr@lbFillColors       = color2      ; labelbar colors
 resr@lbMonoFillPattern  = True        ; Solid fill pattern
 resr@lbLabelFontHeightF = 0.015       ; font height. default is small
 resr@lbPerimOn          = False
 labelr = gsn_create_labelbar(wks,1,item2,resr)

 draw(plot)
 draw(labell)
 draw(labelr)
 frame(wks)

end
