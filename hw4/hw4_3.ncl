fils = systemfunc ("ls *.obs") ; file paths
;print(fils)
;exit
n=0
nwh = new((/1440*dimsizes(fils), 11/), float) ;�}�ůx�}
do while(n .lt. dimsizes(fils))

   a = asciiread(fils(n),-1,"float")
   nlines = dimsizes(a)
   wh = reshape(a,(/1440*11,2/)) ;y��V�O1440*11 x�O2��
;exit
   wh1 = reshape(wh(:,1),(/1440,11/)) ;wh�u���Ĥ@�� �s�iwh1 :11�ܼƬ��@�� 1440�C

   nwh(1440*n:1440*(n+1)-1,:) = wh1 ;x��11�ܼ� y�O1140*7�C

   n = n + 1
end do

;�p��õe�X 7 �Ѥ饭���ūסB���������ɧǹ�
;01+ x   02+ �褸�~  03+ �Ӷ��� 04+ �ɤ� hh:mm   05+ ���t   06+ ���V 07+ �ū� 08+ �۹�ë� 09+ ���������� 10+ ��g�q 11+ ���B�q 

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