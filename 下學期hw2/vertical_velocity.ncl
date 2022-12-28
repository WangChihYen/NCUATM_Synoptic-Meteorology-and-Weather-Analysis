fName =     "./output.bin"
  
nlat  = 25                            ; y網格
mlon  = 49                             ; x網格
nlev  = 5                              ; 垂直層 300 500 700 850 1000
ntim  = 1
vars  = 4                               ; 變數 
UNDEF = 1.e30                           ; 沒定義的就這數值代替
;每1.875度有一筆資料
  
; create an array to contain data
x     = new ( (/vars,nlev,nlat,mlon/), float)
x = fbindirread(fName, 0 ,(/vars,nlev,nlat,mlon/), "float")
setfileoption("bin","ReadByteOrder","BigEndian")
  
h = x(0,:,:,:)
u = x(1,:,:,:)
v = x(2,:,:,:)
t = x(3,:,:,:)
;資料有讀到
  
lat = fspan(15.,60.,25)
lon = fspan(90.,180.,49)
;rec(dimsizes(lon) ) ;lat 和lon都是一維矩陣
;print(lon)
;經緯矩陣 網格一格差1.875度
 
;div = new ( (/5,25,49/),float) ;創三維矩陣 5*25*49
;printVarSummary(div)

pressure_level = (/ 1000,850,700,500,300 /) ;一維矩陣5*1
level = 0 ;1000mb start 

;--------算最高層垂直速度(用以計算epsilon)----------------------
w_new = 0
do while(level.le.4)
  
  ;div  = u/dx + v/dy  
  phi = 90-60
  do while(phi.le.90-15)
    dy = 6378000*1.875*3.14/180
    dx = dy* cos(phi*3.14/180)
    div_x = center_finite_diff_n (x(1,level,:,:),dx,False,0,0)
    div_y = center_finite_diff_n (x(2,level,:,:),dy,False,0,0)
    div =  div_x + div_y
    phi := phi + 1.875 ; :=是可以讓等式左邊用等式右邊的參數
  end do
  
  if (level.eq.0) then
    w_1 = div * (1010- ( pressure_level(level) + pressure_level(level+1) )/2 ) 
  else if  (level.eq.4) then    
    w_5 = div * ( ( pressure_level(level-1) + pressure_level(level) )/2 - 100  ) 
  else  
  ;非level=0且非4的
    w = div * ( ( pressure_level(level-1) + pressure_level(level) )/2 - ( pressure_level(level) + pressure_level(level+1) )/2  ) 
    w_new :=  w_new + w 
  end if
  end if
  
  level := level +1
end do

w_5 := w_1 + w_new + w_5
;print(w_5)

;--------算epsilon----------------------
epsilon = (w_5 - 0 ) / (1010-10)
;print(epsilon)
;--------修正輻散量--------------------
pressure_level = (/ 1000,850,700,500,300 /) ;一維矩陣5*1
level = 0 ;1000mb start 
do while(level.le.4)
  
  ;div  = u/dx + v/dy  
  phi = 90-60
  do while(phi.le.90-15)
    dy = 6378000*1.875*3.14/180
    dx = dy* cos(phi*3.14/180)
    div_x = center_finite_diff_n (x(1,level,:,:),dx,False,0,0)
    div_y = center_finite_diff_n (x(2,level,:,:),dy,False,0,0)
    div =  div_x + div_y
    phi := phi + 1.875 ; :=是可以讓等式左邊用等式右邊的參數
  end do
  div := div - epsilon  ;修正該層輻散量
  
;-----------運用修正完的輻散量計算各層的垂直速度
;-------------n代表new
  if (level.eq.0) then
    w_n1 = div * 85

  else if (level.eq.1) then
    w_n2  = div * 150 + w_n1

  else if (level.eq.2) then
    w_n3  = div * 175 + w_n2 + w_n1

  else if (level.eq.3) then
    w_n4  = div * 200 +w_n3+ w_n2 + w_n1

  else
    w_n5  = div * 300 +w_n4+ w_n3+ w_n2 + w_n1

  end if
  end if
  end if
  end if
  
  level := level +1
end do
;print(w_n5)

;----------------插入垂直座標 設一個新的三圍矩陣[6*49*25]去裝各層的omega 
;地表w_0也要計算為0
ww =new((/6,25,49/),float)  ;高*緯*經

do ll =0,nlev
  do jj =0, mlon-1
    do ii = 0,nlat-1
    
    
      if(ll.eq.0) then
        ww(ll,ii,jj)= 0.
      else if (ll.eq.1) then
        ww(ll,ii,jj) = w_n1(ii,jj)
      else if (ll.eq.2) then
        ww(ll,ii,jj) = w_n2(ii,jj)
      else if (ll.eq.3) then
        ww(ll,ii,jj) = w_n3(ii,jj)  
      else if (ll.eq.4) then
        ww(ll,ii,jj) = w_n4(ii,jj) 
      else
        ww(ll,ii,jj)=w_n5(ii,jj)
        
      end if
      end if
      end if
      end if
      end if
    end do
  end do
end do

;printVarSummary(ww)
;print(ww)

;------------------- 套入座標 -------------------------------------------------  
lat = fspan(15.,60.,25)
lon = fspan(90.,180.,49)
levels = (/ 1010,925,775,600,400,100 /)
ww!2="lon"
ww!1="lat"
ww!0="lev"
ww&lon = lon
ww&lat = lat
ww&lev = levels
ww&lon@units ="degree_east"
ww&lat@units ="degree_north"
ww&lev@units ="hPa"

;--------------畫圖----------
wks = gsn_open_wks ("png", "120E vertical velocity")
res = True
res@tiMainString    = "120E vertical velocity"
res@gsnDraw         = True
res@gsnFrame        = False
res@gsnAddCyclic    = False
res@cnFillOn        = True
res@cnLinesOn       = False
res@cnFillPalette   = "BlueRed"
res@cnLevelSelectionMode  = "ManualLevels"
res@cnLevelSpacingF = 0.01
res@cnMinLevelValF= -0.08
res@cnMaxLevelValF= 0.08

plot=gsn_csm_pres_hgt(wks,ww(:,:,{120}),res)
draw(plot)
frame(wks)