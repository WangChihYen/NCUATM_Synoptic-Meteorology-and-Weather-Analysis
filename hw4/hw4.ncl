fils = systemfunc ("ls *.obs") ; file paths
;print(fils)
;exit
n=0
nwh = new((/1440*dimsizes(fils), 11/), float) ;開空矩陣
do while(n .lt. dimsizes(fils))

   a = asciiread(fils(n),-1,"float")
   nlines = dimsizes(a)
   wh = reshape(a,(/1440*11,2/)) ;y方向是1440*11 x是2行
print(wh)
;exit
   wh1 = reshape(wh(:,1),(/1440,11/)) ;wh只取第一行 存進wh1 :11變數為一行 1440列

   nwh(1440*n:1440*(n+1)-1,:) = wh1 ;x為11變數 y是1140*7列

   n = n + 1
end do
print("nwh2879")
print(nwh(2879,:)) ;列+行
print("==================")
print("nwh2880")
;print(nwh(2880,:))
exit

;接下來做七天時序圖的繪圖
;這是我寫的