fils = systemfunc ("ls *.obs") ; file paths
;print(fils) ;Ū�Ҧ�obs��
;exit
n=0
nwh = new((/1440*dimsizes(fils), 11/), float) ;�}�ůx�}
do while(n .lt. dimsizes(fils))

   a = asciiread(fils(n),-1,"float")
   nlines = dimsizes(a) ;�ݦ��X��
   wh = reshape(a,(/1440*11,2/)) ;y��V�O1440����*11���ܼ�  x�O2��
   ;�@�Ѧ�1440��������� 
;print("=================")
;exit
   wh1 = reshape(wh(:,1),(/1440,11/)) ;wh�u���Ĥ@��(�ܼƭ�) �s�iwh1 :x�V11�ܼƦ� y�V1440�C

   nwh(1440*n:1440*(n+1)-1,:) = wh1 ;x��11�ܼ� y�O1140*7�ѦC

   n = n + 1
end do
;print("nwh2879")
;print(nwh(2879,:)) ;�C+�� ��2�Ѩ��3��
;print("==================") 
;print("nwh2880") ;��2�Ѩ��3��
;print(nwh(2880,:))
;print(nwh(0:1440,3))


;�e�X 1/24 �U���ܼƮɧǹ� 
;01+ x   02+ �褸�~  03+ �Ӷ��� 04+ �ɤ� hh:mm   05+ ���t   06+ ���V 07+ �ū� 08+ �۹�ë� 09+ ���������� 10+ ��g�q 11+ ���B�q 
;24�� �ɤ� nwh(0:1440,3)

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