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
;-----------------------------------------------------------------------------
  wks = gsn_open_wks ("png", "hw5 "+" zonal wind & temperature bias  ")
 ; wks = gsn_open_wks ("png", "hw5 "+" meridional  wind & temperature bias  ")
 ; wks = gsn_open_wks ("png", "hw5 "+" vertical velocity ")

  res = True
  res@gsnDraw         = False                   ; don't draw yet
  res@gsnFrame        = False                   ; don't advance frame yet
  res@gsnAddCyclic    = False
  res@cnLevelSpacingF = 10.0
 ; res@cnLevelSpacingF = 0.5

  plot1 = gsn_csm_pres_hgt(wks, u(:,{17:30},{121.8}),res)
 ; plot1 = gsn_csm_pres_hgt(wks, v(:,{23.5},{114:130}),res)
  tres = True 
  tres@tiMainString    = "zonal wind & temperature bias "
 ; tres@tiMainString    = "meridional wind & temperature bias "
 ; tres@tiMainString    = "vertical velocity"
  tres@gsnDraw         = False
  tres@gsnFrame        = False
  tres@gsnAddCyclic    = False
  tres@cnFillOn        = True
  tres@cnFillPalette   = "grads_rainbow"
  tres@cnLinesOn       = False
  tres@cnLevelSelectionMode  = "ManualLevels"
  tres@cnLevelSpacingF = 0.5
  tres@cnMinLevelValF= 0.
  tres@cnMaxLevelValF= 10.
  plot_bottom = gsn_csm_pres_hgt(wks, t(:,{17:30},{121.8}),tres)
  ;plot_bottom = gsn_csm_pres_hgt(wks, t(:,{23.5},{114:130}),tres)
  plot_bottom1 = gsn_csm_pres_hgt(wks, w(:,{23.5},{114:130}),tres)
  overlay(plot_bottom,plot1)           ; set color map  
  draw(plot_bottom)
  frame(wks)  