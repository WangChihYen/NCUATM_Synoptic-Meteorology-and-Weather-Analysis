fils = systemfunc ("ls *.obs") ; file paths
;print(fils)
;exit
n=0
nwh = new((/1440*dimsizes(fils), 11/), float) ;開空矩陣
do while(n .lt. dimsizes(fils))

   a = asciiread(fils(n),-1,"float")
   nlines = dimsizes(a)
   wh = reshape(a,(/1440*11,2/)) ;y方向是1440*11 x是2行
;exit
   wh1 = reshape(wh(:,1),(/1440,11/)) ;wh只取第一行 存進wh1 :11變數為一行 1440列

   nwh(1440*n:1440*(n+1)-1,:) = wh1 ;x為11變數 y是1140*7列

   n = n + 1
end do

;計算並畫出 7 天日平均溫度、平均氣壓時序圖
;01+ x   02+ 西元年  03+ 太陽日 04+ 時分 hh:mm   05+ 風速   06+ 風向 07+ 溫度 08+ 相對溼度 09+ 海平面氣壓 10+ 輻射量 11+ 降雨量 

time = ispan(0,6,1)

temp19 = avg(nwh(0:1439,6))
temp20 = avg(nwh(1440:2879,6))
temp21 = avg(nwh(2880:4319,6))
temp22 = avg(nwh(4320:5759,6))
temp23 = avg(nwh(5760:7199,6))
temp24 = avg(nwh(7200:8639,6))
temp25 = avg(nwh(8640:10079,6))

temp = (/temp19,temp20,temp21,temp22,temp23,temp24,temp25/)
print("=============")
print(time)
print(temp)

pressure19 = avg(nwh(0:1439,8))
pressure20 = avg(nwh(1440:2879,8))
pressure21 = avg(nwh(2880:4319,8))
pressure22 = avg(nwh(4320:5759,8))
pressure23 = avg(nwh(5760:7199,8))
pressure24 = avg(nwh(7200:8639,8))
pressure25 = avg(nwh(8640:10079,8))

pressure= (/pressure19,pressure20,pressure21,pressure22,pressure23,pressure24,pressure25/)

print("==============plottttttt================")

 wks   = gsn_open_wks ("png","avg_pressure")                  ; send graphics to PNG file

;---------------------left----------------------------

 resl                  = True                                 ; plot mods desired
 resl@tiMainString     = "average pressure"     ; add title
 resl@tiMainOffsetYF   = 0.05                                 ; title size
 resl@tiMainFontHeightF = 0.04                                ; chang title hight
 resl@gsnMaximize      = True                                 ; plot will be fill the biggest possible space
 resl@vpKeepAspect     = True                                 ; keep aspect
 resl@vpWidthF         = 1.5                                  ; Change the aspect ratio, but
 resl@vpHeightF        = 0.4                                  ; make plot as large as possible.
 ;resl@xyLineColor = "maroon1"                             ; chang the line color
 resl@xyLineColor = "red" 
 resl@xyLineThicknessF = 3                                    ; chang line thickness
 resl@tiYAxisFontColor = resl@xyLineColor                     ; axis font color
 resl@tmXBMode      = "Explicit"                              
 resl@tmXBValues    = (/0,1,2,3,4,5,6,7/)                                                 ; set x value  
 resl@tmXBLabels    = (/"01/19","01/20","01/21","01/22","01/23","01/24","01/25","01/26"/) ; set x labels


 ;plot = gsn_csm_xy2(wks,t,a,b,resl,resr)                       ; plot

 plot = gsn_xy(wks,time,pressure,resl)
 draw(plot)
 exit