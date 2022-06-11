
begin
;=========================================
;read data
;=========================================

 lines = asciiread("160124.txt",(/1440,22/),"float")
 sd = lines(:,5)     ;solor day 
 ti = lines(:,7)     ;time
 ws = lines(:,9)     ;wind speed
 wd = lines(:,11)    ;wind direction
 tp = lines(:,13)    ;temperature
 rh = lines(:,15)    ;RH
 ap = lines(:,17)    ;atmospheric pressure
 sa = lines(:,19)    ;radiance
 pr = lines(:,21)    ;precioitation

;==========================================
;data 
;==========================================

color1 = "palevioletred2"
;color1 = "goldenrod1"
;color1 = "brown3"
;color1 = "darkorange1"
color2 = "olivedrab"
;color2 = "deepskyblue2"
;color2 = "royalblue"

item1 = "temperature"
;item1 = "wind speed"
;item1 = "pressure"
;item1 = "solar radiation"
item2 = "RH"
;item2 = "wind direction"
;item2 = "rainfall"

data1 = tp
;data1 = ws
;data1 = ap
;data1 = sa

data2 = rh
;data2 = wd
;data2 = pr
;data2 = sd

;===============================
;plot
;================================

 wks   = gsn_open_wks ("png","0124tr")                ; send graphics to PNG file

;---------------------left----------------------------

 resl                  = True                          ; plot mods desired
 resl@tiMainString     = "01/24 temperature & RH"      ; add title
 resl@tiMainOffsetYF   = 0.05                          ; title size
 resl@tiMainFontHeightF = 0.04                         ; chang title hight
 resl@gsnMaximize      = True                          ; plot will be fill the biggest possible space
 resl@vpKeepAspect     = True                          ; keep aspect
 resl@vpWidthF         = 1.5                           ; Change the aspect ratio, but 
 resl@vpHeightF        = 0.4                           ; make plot as large as possible.
 resl@xyLineColor      = color1                        ; chang the line color
 resl@xyLineThicknessF = 3                             ; chang line thickness
 resl@tiYAxisFontColor = resl@xyLineColor              ; axis font color
 resl@tmXBMode      = "Explicit" 
 resl@tmXBValues    = (/00,400,800,1200,1600,2000,2400/)                           ; set x value 
 resl@tmXBLabels    = (/"00:00","04:00","08:00","12:00","16:00","20:00","24:00"/)  ; sei x labels

;-----------------------right----------------------

 resr = True                                           ; plot mods desired
 resr@xyLineColor = color2                             ; chang the line color
 resr@xyLineThicknessF = 3                             ; chang line thickness
 resr@tiYAxisFontColor = resr@xyLineColor              ; axis font color
; resr@trYMaxF          = 3.0                           ; ayis max


 plot = gsn_csm_xy2(wks,ti,data1,data2,resl,resr)      ;plot

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
 labell = gsn_create_labelbar(wks,1,item1,resl)    ;plot labelbar left

 resr                    = True        ; labelbar only resources
 resr@lbAutoManage       = False       ; Necessary to control sizes
 resr@vpWidthF           = 0.2         ; labelbar width
 resr@vpHeightF          = 0.02        ; labelbar height
 resr@vpXF               = 0.53        ; labelbar position in x direction
 resr@vpYF               = 0.66        ; labelbar position in y direction
 resr@lbFillColors       = color2      ; labelbar colors
 resr@lbMonoFillPattern  = True        ; Solid fill pattern
 resr@lbLabelFontHeightF = 0.015       ; font height. default is small
 resr@lbPerimOn          = False
 labelr = gsn_create_labelbar(wks,1,item2,resr)    ;plot labelbar left

 draw(plot)                                                
 draw(labell)
 draw(labelr)
 frame(wks)

end
