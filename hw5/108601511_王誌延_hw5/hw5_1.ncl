
  diri  = "./"                            ; input directory
  fili  = "fanapid.dat"                   ; DSET 讀2進為黨
  fName = diri+fili                       ; path

  nlat  = 252                             ; YDEF
  mlon  = 252                             ; XDEF
  nlev  = 10                              ; LEV
  ntim  = 1                               ; REC
  vars  = 4                               ; VARS 
  UNDEF = 1.e30                           ; UNDEF
  pressure = 850
  level = 2

  ; create an array to contain data
  x     = new ( (/vars,nlev,nlat,mlon/), float, UNDEF)  ;開矩陣
  setfileoption("bin","ReadByteOrder","BigEndian") ;用啥檔讀他 ctl有說byte的存放方式是顛倒過來的
  ;bin二進位    所以要用BigEndian
  do nt=0,ntim-1                          ; read each record: store in x
     x = fbindirread(fName, nt, (/vars,nlev,nlat,mlon/), "float") ;把2進位讀成這個x的方式 放入x這個陣列裡
     ;長寬252*252 高1000*900
  end do

  u = x(0,:,:,:) ;u是由上數下來第一個變數
  v = x(1,:,:,:)
  w = x(2,:,:,:)
  t = x(3,:,:,:)
  ; printVarSummary(t)
  ; print(t)

  WS = (u^2+v^2)^(0.5)
  
  ;繪圖設定

  lat = fspan(4.,43.,252) ;緯度 252網格點
  lon = fspan(95.,145.,252) ;經度 
  pressure_levels = (/ 1000,900,850,800,700,600,500,400,300,250 /) ;高度從0,1,2開始
  u!2="lon" ;u變量第2維度的資訊
  u!1="lat" ;u變量第1維度的資訊
  u&lon = lon
  u&lat = lat
  u&lon@units ="degree_east"
  u&lat@units ="degree_north"
  u&lev = pressure_levels
  
  copy_VarCoords(u,v)
  copy_VarCoords(u,w)
  copy_VarCoords(u,t)
  copy_VarCoords(u,WS)

;從作業3copy下來

;下面是要找颱風裡4變量的極值和位置
  varsval = 4
  mx = new ( (/varsval,4/), float) ;空矩陣4*4
  n = 0
  do while (n.le.3) ;n<=3
     Data = x(n,:,:,:) ;0
     mx(n,0) = max(Data)
     ; print(mx)
     DMax = max(Data)
     ; print(DMax)
     x1D = ndtooned(Data)     ; only do this once 含有u資訊的一為變量
     indices = ind_resolve(ind(x1D.eq.DMax),dimsizes(Data))  ; locations of max
     mx(n,1:3) = indices
     delete (x1D)
     n = n+1
  end do
  ;print(mx)
 ;--------------------------------------------------------------------
wks = gsn_open_wks ("png", "hw5_1_"+pressure+"mb")        ; send graphics to PNG file

res                      = True                    ; plot mods desired
res@gsnDraw              = False                   ; don't draw yet
res@gsnFrame             = False                   ; don't advance frame yet
res@gsnAddCyclic         = False
res@tiMainString         = ""+pressure+"mb StreamLine & wind speed field" 
res@mpProjection         = "LambertConformal"
res@mpLambertParallel1F  = 10.0
res@mpLambertParallel2F  = 40.0
res@mpLambertMeridianF   = 120.0
res@tfDoNDCOverlay       = True   ;data is not transformed to the projection
res@mpLimitMode          = "Corners"

res@mpLeftCornerLatF     = 17
res@mpLeftCornerLonF     = 114
res@mpRightCornerLatF    = 30
res@mpRightCornerLonF    = 130
res@mpGridAndLimbOn      = True ; turn on lat/lon lines.
res@pmTickMarkDisplayMode   = "Conditional"
res@mpDataBaseVersion      = "MediumRes"        ; better map outlines


mpres = res
mpres@cnLevelSpacingF = 5
mpres@tiMainOn        = False
mpres@cnFillOn        = True                    ; turn on color 
mpres@cnFillPalette   = "grads_rainbow"           ; set color map
mpres@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
mpres@cnLevels  = (/5,10,15,20,25,30,35,40,45,50,55,60/)
mpres@cnLinesOn       = False                   ; turn off contour lines
 ;mpres@cnLineLabelsOn  = False                   ; turn off line labels

plot = gsn_csm_contour_map(wks, WS(level,84:172,96:176), mpres)

res = True

plot2 = gsn_csm_streamline(wks,u(level,84:172,96:176),v(level,84:172,96:176),res)
;plot2= gsn_csm_vector(wks,u(level,84:172,96:176),v(level,84:172,96:176),res_vc)

overlay(plot,plot2)
draw(plot)
frame(wks)
