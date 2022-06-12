 diri  = "./"                  ; input directory
  fili  = "fanapid.dat"         ; DSET
  fName = diri+fili             ; path

  nlat  = 252                             ; YDEF
  mlon  = 252                             ; XDEF
  nlev  = 10                              ; LEV
  ntim  = 1                               ; REC
  vars  = 4                               ; VARS 
  UNDEF = 1.e30                           ; UNDEF  
  ; create an array to contain data
  x     = new ( (/vars,nlev,nlat,mlon/), float, UNDEF)
  setfileoption("bin","ReadByteOrder","BigEndian")
  do nt=0,ntim-1                          ; read each record: store in x
     x = fbindirread(fName, nt, (/vars,nlev,nlat,mlon/), "float")
  end do

  u = x(0,:,:,:)
  v = x(1,:,:,:)
  w = x(2,:,:,:)
  t = x(3,:,:,:)
  ; printVarSummary(t)

  WS = (u^2+v^2)^(0.5)

  lat = fspan(4.,43.,252)
  lon = fspan(95.,145.,252)
  pressure_levels = (/ 1000,900,850,800,700,600,500,400,300,250 /)
  u!2="lon"
  u!1="lat"
  u!0="lev"
  u&lon = lon
  u&lat = lat
  u&lev = pressure_levels
  u&lon@units ="degree_east"
  u&lat@units ="degree_north"
  u&lev@units ="hPa"
  copy_VarCoords(u,v)
  copy_VarCoords(u,w)
  copy_VarCoords(u,t)
  copy_VarCoords(u,WS)
;--------------------plot 1.streamline and wind speed field 2.wind field & vertical velocity ----------------------
do level = 0,nlev-1 
 wks = gsn_open_wks ("png", "hw5 "+ pressure_levels(level)+"hPa"+" Streamline & wind speed field ")        ; send graphics to PNG file
 res                 = True                    ; plot mods desired
 res@gsnDraw         = False                   ; don't draw yet
 res@gsnFrame        = False                   ; don't advance frame yet
 res@gsnAddCyclic    = False

 res@mpProjection = "LambertConformal"
 res@mpLambertParallel1F = 10.0
 res@mpLambertParallel2F = 40.0
 res@mpLambertMeridianF = 120.0
 res@mpLimitMode = "Corners"
 res@mpLeftCornerLatF = 17.
 res@mpLeftCornerLonF = 114.
 res@mpRightCornerLatF= 30.
 res@mpRightCornerLonF= 130.
 res@vcRefMagnitudeF  = 20                   ;set  vector reference value   
 res@vcMinDistanceF   = 0.015                ;change distance of each vector
 res@vcRefLengthF  = 0.01                    ;set vector magnitude
 res@tfDoNDCOverlay = "NDCViewport"            ;True 
 res@stMinDistanceF = 0.01
 
 mpres = res 
 mpres@cnLevelSelectionMode  = "ManualLevels"              
 mpres@cnLevelSpacingF = 5.                  ;for wind speed,the spacing between contour intervals is 5
 mpres@cnMinLevelValF= 5.                    ;for wind speed,the minimum of contour intervals is 5
 mpres@cnMaxLevelValF= 60.                   ;for wind speed,the maximum of contour intervals is 60
 mpres@cnFillOn        = True                    ; turn on color 
 mpres@cnFillPalette   = "grads_rainbow"           ; set color map
 mpres@cnLinesOn       = False                   ; turn off contour lines
 mpres@lbOrientation = "vertical"
 mpres@tiMainOn        = True
 mpres@pmTickMarkDisplayMode = "Always"      ;display latitude and longitude tick
 mpres@tmXTOn = False                        ;turn off top tick
 mpres@tmYROn = False
 mpres@tmYLLabelFontHeightF = 0.015
 mpres@tiMainString    = pressure_levels(level)+"hPa"+" Streamline & wind speed field "
  
 print(level)
 res = True
 ;plot = gsn_csm_contour_map(wks, t(level,:,:), mpres)  
 plot = gsn_csm_contour_map(wks, WS(level,84:172,96:176), mpres)
 ;plot = gsn_csm_contour_map(wks, w(level,84:172,96:176), mpres)

 plot2 = gsn_csm_streamline(wks,u(level,84:172,96:176),v(level,84:172,96:176),res)
 ;plot2 = gsn_csm_vector(wks,u(level,84:172,96:176),v(level,84:172,96:176),res)

 overlay(plot,plot2) 
 draw(plot)
 frame(wks)
end do