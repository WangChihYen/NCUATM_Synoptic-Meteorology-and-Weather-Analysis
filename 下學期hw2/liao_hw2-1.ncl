 diri  = "./"                  ; input directory
  fili  = "output.bin"         ; DSET
  fName = diri+fili             ; path

  nlat  = 25                             ; YDEF
  mlon  = 49                             ; XDEF
  nlev  = 5                              ; LEV
  ntim  = 1                               ; REC
  vars  = 4                               ; VARS 
  UNDEF = 1.e30                           ; UNDEF  
  lonprofile=16                           ;剖面圖的經度 120E
  
  x = fbindirread(fName, 0, (/vars,nlev,nlat,mlon/), "float")

  hh = x(0,:,:,:)
  uu = x(1,:,:,:)
  vv = x(2,:,:,:)
  tt = x(3,:,:,:)
;-------------設定------------------------------------------------------------------
  d2r=3.14159/180.
  omega=7.292*(10^(-5))
  dy=6378000*1.875*3.14/180
  ang_b=15.
  txx=new((/5,25,49/),float)  ;溫度的x方向微分
  tyy=new((/5,25,49/),float)  ;溫度的y方向微分
  uxx=new((/5,25,49/),float)  ;u的x方向微分
  vxx=new((/5,25,49/),float)  ;v的x方向微分
  vyy=new((/5,25,49/),float)  ;v的y方向微分
  uyy=new((/5,25,49/),float)  ;u的y方向微分
  vo=new((/5,25,49/),float)   ;相對窩度
  vaxx=new((/5,25,49/),float) ;絕對窩度的x方向微分
  vayy=new((/5,25,49/),float) ;絕對窩度的y方向微分
  hta=new((/5,25,49/),float)  ;水平溫度平流
  div=new((/5,25,49/),float)  ;散度
  vaa=new((/5,25,49/),float)  ;絕對窩度平流
  dp =new((/5/),float)  ; 高度變化
  ww =new((/6,25,49/),float)  ;垂直速度
  error =new((/25,49/),float)    ;輻散場誤差
  aa =new((/25,49/),float)    ;輻散場誤差
  divnew=new((/5,25,49/),float)  ;散度
  ; printVarSummary(t(ll))
;------------- 計算溫度的x方向微分、u的x方向微分、v的x方向微分----------------------
  do ll=0,nlev-1 
  do ii=0,nlat-1
  do jj=0,mlon-1
    if(jj.eq.0) then
      txx(ll,ii,jj)=(tt(ll,ii,jj+1)-tt(ll,ii,jj))/dy
      uxx(ll,ii,jj)=(uu(ll,ii,jj+1)-uu(ll,ii,jj))/dy
      vxx(ll,ii,jj)=(vv(ll,ii,jj+1)-vv(ll,ii,jj))/dy
    else if(jj.eq.(mlon-1)) then
      txx(ll,ii,jj)=(tt(ll,ii,jj)-tt(ll,ii,jj-1))/dy
      uxx(ll,ii,jj)=(uu(ll,ii,jj)-uu(ll,ii,jj-1))/dy
      vxx(ll,ii,jj)=(vv(ll,ii,jj)-vv(ll,ii,jj-1))/dy
    else 
      txx(ll,ii,jj)=(tt(ll,ii,jj+1)-tt(ll,ii,jj-1))/(2*dy)
      uxx(ll,ii,jj)=(uu(ll,ii,jj+1)-uu(ll,ii,jj-1))/(2*dy)
      vxx(ll,ii,jj)=(vv(ll,ii,jj+1)-vv(ll,ii,jj-1))/(2*dy)
    end if
    end if
  end do
  end do
;------------- 計算溫度的y方向微分、u的y方向微分、v的y方向微分----------------------
  do jj=0,mlon-1
  do ii=0,nlat-1
    dx=dy*cos((ang_b+ii)*d2r)
    if(ii.eq.0) then
      tyy(ll,ii,jj)=(tt(ll,ii+1,jj)-tt(ll,ii,jj))/dx
      uyy(ll,ii,jj)=(uu(ll,ii+1,jj)-uu(ll,ii,jj))/dx
      vyy(ll,ii,jj)=(vv(ll,ii+1,jj)-vv(ll,ii,jj))/dx
    else if(ii.eq.(nlat-1)) then
      tyy(ll,ii,jj)=(tt(ll,ii,jj)-tt(ll,ii-1,jj))/dx
      uyy(ll,ii,jj)=(uu(ll,ii,jj)-uu(ll,ii-1,jj))/dx
      vyy(ll,ii,jj)=(vv(ll,ii,jj)-vv(ll,ii-1,jj))/dx
    else
      tyy(ll,ii,jj)=(tt(ll,ii+1,jj)-tt(ll,ii-1,jj))/(2*dx)
      uyy(ll,ii,jj)=(uu(ll,ii+1,jj)-uu(ll,ii-1,jj))/(2*dx)
      vyy(ll,ii,jj)=(vv(ll,ii+1,jj)-vv(ll,ii-1,jj))/(2*dx)
    end if
    end if
  end do
  end do
;------------- 計算相對渦度---------------------------------------------------------
  do jj=0,mlon-1
  do ii=0,nlat-1
    vo(ll,ii,jj)=vxx(ll,ii,jj)-uyy(ll,ii,jj)
  end do
  end do
;------------- 計算絕對窩度的x方向微分----------------------------------------------
  do ii=0,nlat-1
    ff=2*omega*sin((ang_b+ii)*d2r)
  do jj=0,mlon-1
    if(jj.eq.0) then
      vaxx(ll,ii,jj)=((vo(ll,ii,jj+1)+2*omega*sin((ang_b+ii)*d2r))-(vo(ll,ii,jj)+2*omega*sin((ang_b+ii)*d2r)))/dy
    else if(jj.eq.(mlon-1)) then
      vaxx(ll,ii,jj)=((vo(ll,ii,jj)+2*omega*sin((ang_b+ii)*d2r))-(vo(ll,ii,jj-1)+2*omega*sin((ang_b+ii)*d2r)))/dy
    else
      vaxx(ll,ii,jj)=((vo(ll,ii,jj+1)+2*omega*sin((ang_b+ii)*d2r))-(vo(ll,ii,jj-1)+2*omega*sin((ang_b+ii)*d2r)))/(2*dy)
    end if
    end if
  end do
  end do
;------------- 計算絕對窩度的y方向微分----------------------------------------------  
  do jj=0,mlon-1
  do ii=0,nlat-1
    ff=2*omega*sin((ang_b+ii)*d2r)
    dx=dy*cos((ang_b+ii)*d2r)
    if(ii.eq.0) then
      vayy(ll,ii,jj)=((vo(ll,ii+1,jj)+2*omega*sin((ang_b+ii+1)*d2r))-(vo(ll,ii,jj)+2*omega*sin((ang_b+ii)*d2r)))/dx
    else if(ii.eq.(nlat-1)) then
      vayy(ll,ii,jj)=((vo(ll,ii,jj)+2*omega*sin((ang_b+ii)*d2r))-(vo(ll,ii-1,jj)+2*omega*sin((ang_b+ii-1)*d2r)))/dx
    else
      vayy(ll,ii,jj)=((vo(ll,ii+1,jj)+2*omega*sin((ang_b+ii+1)*d2r))-(vo(ll,ii-1,jj)+2*omega*sin((ang_b+ii-1)*d2r)))/(2*dx)
    end if
    end if
  end do
  end do
;-------------- 計算各項變數 --------------------------------------------------------
  do jj=0,mlon-1
  do ii=0,nlat-1
    hta(ll,ii,jj)=(-uu(ll,ii,jj)*txx(ll,ii,jj)-vv(ll,ii,jj)*tyy(ll,ii,jj))
    div(ll,ii,jj)=uxx(ll,ii,jj)+vyy(ll,ii,jj)
    vaa(ll,ii,jj)=-uu(ll,ii,jj)*vaxx(ll,ii,jj)-vv(ll,ii,jj)*vayy(ll,ii,jj)
  end do
  end do
  end do
;-------------- 垂直速度計算 --------------------------------------------------------
  pressure_levels = (/ 1000,850,700,500,300 /)
  ps=1010
  pt=100
  do jj=0,mlon-1
  do ii=0,nlat-1
    aa(ii,jj)=0.
  end do
  end do
  
  dp= (/ 85,150.,175.,200.,300. /)
  do ll=0,nlev
  do jj=0,mlon-1
  do ii=0,nlat-1
    if(ll.eq.0) then
      ww(ll,ii,jj) = 0.
    else
      aa(ii,jj)=aa(ii,jj)+(div(ll-1,ii,jj)*dp(ll-1))
      ww(ll,ii,jj) = aa(ii,jj)
    end if
  end do
  end do
  end do
;-------------- 算w(5)計算 --------------------------------------------------------
  do jj=0,mlon-1
  do ii=0,nlat-1
    print("===============================================")
    print(ww(5,ii,jj))
    print("===============================================")
    error(ii,jj)= ww(5,ii,jj)/(1010-100)
  end do 
  end do
  
  do ll=0,nlev-1
  do jj=0,mlon-1
  do ii=0,nlat-1
    divnew(ll,ii,jj)=(div(ll,ii,jj)-error(ii,jj))
  end do
  end do
  end do
  
  print(divnew)
  
  do jj=0,mlon-1
  do ii=0,nlat-1
    aa(ii,jj)=0.
  end do
  end do
  
  do ll=0,nlev
  do jj=0,mlon-1
  do ii=0,nlat-1
    if(ll.eq.0) then
      ww(ll,ii,jj)= 0.
    else
      aa(ii,jj)=(aa(ii,jj)+(divnew(ll-1,ii,jj)*dp(ll-1)))
      ww(ll,ii,jj)=aa(ii,jj)
    end if
  end do
  end do
  end do
  
  print(ww)
  ;print(ww(:,:,15))
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

;--------------------plot 1.streamline and wind speed field 2.wind field & vertical velocity ----------------------
wks = gsn_open_wks ("png", "liao_hw2 Vertical Velocity Profile ")
res = True 
res@tiMainString    = "vertical velocity"
res@gsnDraw         = True
res@gsnFrame        = False
res@gsnAddCyclic    = False
res@cnFillOn        = True
res@cnLinesOn       = False
res@cnLevelSelectionMode  = "ManualLevels"
res@cnLevelSpacingF = 0.001
res@cnMinLevelValF= -0.005
res@cnMaxLevelValF= 0.005

plot=gsn_csm_pres_hgt(wks,ww(:,:,{120}),res)
draw(plot)
frame(wks)