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
;print(wh)
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
;print(nwh(:,3))
print("==============plottttttt================")

 wks   = gsn_open_wks ("png","0124_rain")                ; send graphics to PNG file

 res1                  = True                          ; plot mods desired
 res1@tiMainString     = "01/24 rain"      ; add title
 res1@tiMainOffsetYF   = 0.05                          ; title size
 res1@tiMainFontHeightF = 0.04                         ; chang title hight
 res1@gsnMaximize      = True                          ; plot will be fill the biggest possible space
 res1@vpKeepAspect     = True                          ; keep aspect
 res1@vpWidthF         = 1.5                           ; Change the aspect ratio, but 
 res1@vpHeightF        = 0.4                           ; make plot as large as possible.
 ;res1@xyLineColor      = "maroon1"                      ; chang the line color
 ;res1@xyLineColor      ="seagreen4"
 ;res1@xyLineColor      = "gold1"
 ;res1@xyLineColor      ="blue"
 ;res1@xyLineColor      = "red"
 res1@xyLineColor      = "blue"
 res1@xyLineThicknessF = 3                             ; chang line thickness
 res1@tiYAxisFontColor = resl@xyLineColor              ; axis font color
 res1@tmXBMode      = "Explicit" 
 res1@tmXBValues    = (/00,300,600,900,1200,1500,1800,2100,2400/)                           ; set x value 
 res1@tmXBLabels    = (/"00:00","03:00","06:00","09:00","12:00","15:00","18:00","21:00","24:00"/)  ; sei x labels

 ;plot = gsn_csm_xy2(wks,nwh(0:1440,3),data1,data2,resl,resr)      ;plot
 ;plot = gsn_csm_xy2(wks,nwh(0:1439,3),nwh(0:1439,4),nwh(0:1439,5) ,res1,res2) 
 plot = gsn_xy(wks,nwh(7200:8639,3),nwh(7200:8639,10),res1)
 ;plot2 = gsn_xy(wks,nwh(0:1439,3),nwh(0:1439,7),res1) ;rh


 draw(plot)  
 ;draw(plot2)                                              
; draw(labell)
 ;draw(labelr)
 ;frame(wks)