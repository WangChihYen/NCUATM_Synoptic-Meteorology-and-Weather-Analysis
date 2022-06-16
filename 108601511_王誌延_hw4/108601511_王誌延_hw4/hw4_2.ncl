fils = systemfunc ("ls *.obs") ; file paths
;print(fils) ;讀所有obs檔
;exit
n=0
nwh = new((/1440*dimsizes(fils), 11/), float) ;開空矩陣
do while(n .lt. dimsizes(fils))

   a = asciiread(fils(n),-1,"float")
   nlines = dimsizes(a) ;看有幾行
   wh = reshape(a,(/1440*11,2/)) ;y方向是1440分鐘*11個變數  x是2行
   ;一天有1440筆分鐘資料 
;print("=================")
;exit
   wh1 = reshape(wh(:,1),(/1440,11/)) ;wh只取第一行(變數值) 存進wh1 :x向11變數行 y向1440列

   nwh(1440*n:1440*(n+1)-1,:) = wh1 ;x為11變數 y是1140*7天列

   n = n + 1
end do
;print("nwh2879")
;print(nwh(2879,:)) ;列+行 第2天到第3天
;print("==================") 
;print("nwh2880") ;第2天到第3天
;print(nwh(2880,:))
;print(nwh(0:1440,3))


;畫出 1/24 各項變數時序圖 
;01+ x   02+ 西元年  03+ 太陽日 04+ 時分 hh:mm   05+ 風速   06+ 風向 07+ 溫度 08+ 相對溼度 09+ 海平面氣壓 10+ 輻射量 11+ 降雨量 
;24日 時分 nwh(0:1440,3)

print("==============plottttttt================")


 time = ispan(0,10079,1)

 wks  = gsn_open_wks ("png","week_rain")                ; send graphics to PNG file


 res                  = True                        ; plot mods desired
 res@tiMainString     = "week rain"   ; add title
 res@tiMainOffsetYF   = 0.05                        ; title size
 res@tiMainFontHeightF = 0.04                       ; chang title hight
 res@gsnMaximize      = True                        ; plot will be fill the biggest possible space
 res@vpKeepAspect     = True                        ; keep aspect
 res@vpWidthF         = 1.5                         ; Change the aspect ratio, but
 res@vpHeightF        = 0.4                         ; make plot as large as possible.
 
 ;res@xyLineColor      = "maroon1"                      ; chang the line color
 ;res@xyLineColor      ="seagreen4"
 ;res@xyLineColor      = "gold1"
 ;res@xyLineColor      ="blue"
 ;res@xyLineColor      = "red"
 res@xyLineColor      = "blue"
 
 res@xyLineThicknessF = 3                           ; chang line thickness
 res@tiYAxisFontColor = res@xyLineColor            ; axis font color
 res@trXMaxF                = 10080                 ; axis max
 res@tmXBMode      = "Explicit" 
 res@tmXBValues    = (/0,1440,2880,4320,5760,7200,8640,10079/)                               ; set x value 
 res@tmXBLabels    = (/"01/19","01/20","01/21","01/22","01/23","01/24","01/25","01/26"/)     ; set x labels


 plot = gsn_xy(wks,time,nwh(:,10),res)
 draw(plot)