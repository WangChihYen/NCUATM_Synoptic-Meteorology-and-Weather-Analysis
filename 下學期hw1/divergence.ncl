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
 

pressure_level = (/ 1000,850,700,500,300 /)
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

  ;---------------------------------------
  
  wks = gsn_open_wks ("png",  pressure_level(level)+"mb_divergence")        ; send graphics to PNG file

  res                      = True                    ; plot mods desired
  res@gsnDraw              = False                   ; don't draw yet
  res@gsnFrame             = False                   ; don't advance frame yet
  res@gsnAddCyclic         = False
  res@tiMainString         = pressure_level(level)+"mb_divergence"
  res@mpProjection         = "LambertConformal"
  res@mpLambertParallel1F  = 10.0
  res@mpLambertParallel2F  = 40.0
  res@mpLambertMeridianF   = 120.0
  res@tfDoNDCOverlay       = True   ;data is not transformed to the projection
  res@mpLimitMode          = "Corners"

  res@mpLeftCornerLatF     = 15
  res@mpLeftCornerLonF     = 90
  res@mpRightCornerLatF    = 60
  res@mpRightCornerLonF    = 180
  res@mpGridAndLimbOn      = True ; turn on lat/lon lines.
  res@pmTickMarkDisplayMode   = "Conditional"
  res@mpDataBaseVersion      = "MediumRes"        ; better map outlines

  mpres = res
  mpres@cnLevelSpacingF = 5
  mpres@tiMainString         = pressure_level(level)+"mb_divergence"
  mpres@tiMainOn        = True
  mpres@cnFillOn        = True                    ; turn on color 
  mpres@cnFillPalette   = "BlueRed"          ; set color map
  ;mpres@cnFillPalette   = "gui_default"
  mpres@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
  ;mpres@cnLevels  = (/-5e-7,-1e-7,-5e-6,-1e-6,-5e-5,-1e-5, 0 ,1e-5,5e-5, 1e-6,5e-6, 1e-7,5e-7/) ;colorbar range
  mpres@cnLinesOn       = False                   ; turn off contour lines
  ;mpres@cnLineLabelsOn  = False                   ; turn off line labels

  plot = gsn_csm_contour_map(wks, div, mpres)

  res = True
  draw(plot)
  frame(wks)
  level := level +1
end do