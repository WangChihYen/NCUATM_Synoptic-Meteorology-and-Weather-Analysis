fils = systemfunc ("ls *.obs") ; file paths
;print(fils)
;exit
n=0
nwh = new((/1440*dimsizes(fils), 11/), float) ;�}�ůx�}
do while(n .lt. dimsizes(fils))

   a = asciiread(fils(n),-1,"float")
   nlines = dimsizes(a)
   wh = reshape(a,(/1440*11,2/)) ;y��V�O1440*11 x�O2��
print(wh)
;exit
   wh1 = reshape(wh(:,1),(/1440,11/)) ;wh�u���Ĥ@�� �s�iwh1 :11�ܼƬ��@�� 1440�C

   nwh(1440*n:1440*(n+1)-1,:) = wh1 ;x��11�ܼ� y�O1140*7�C

   n = n + 1
end do
print("nwh2879")
print(nwh(2879,:)) ;�C+��
print("==================")
print("nwh2880")
;print(nwh(2880,:))
exit

;���U�Ӱ��C�ѮɧǹϪ�ø��
;�o�O�ڼg��