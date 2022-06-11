
  diri  = "./"                            ; input directory
  fili  = "fanapid.dat"                   ; DSET
  fName = diri+fili                       ; path

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
 ; print(t)
  ;print(u)
  WS = (u^2+v^2)^(0.5)
  lat = fspan(4.,43.,252)
  lon = fspan(95.,145.,252)
  values=ispan(17,30,1)
  u!2="lon"
  u!1="lat"
  u&lon = lon
  u&lat = lat
  u&lon@units ="degree_east"
  u&lat@units ="degree_north"
  copy_VarCoords(u,v)
  copy_VarCoords(u,w)
  copy_VarCoords(u,t)
  copy_VarCoords(u,WS)

  varsval = 4
  mx = new ( (/varsval,4/), float)
  n = 0
  do while (n.le.3)
     Data = x(n,:,:,:)
     mx(n,0) = min(Data)
     ; print(mx)
     DMax = min(Data)
     ; print(DMax)
     x1D = ndtooned(Data)     ; only do this once
     indices = ind_resolve(ind(x1D.eq.DMax),dimsizes(Data))  ; locations of max
     mx(n,1:3) = indices
     delete (x1D)
     n = n+1
  end do
  print(mx)
;--------------------------------------------------------------------------------
  print("Tmin on 1000 mb="+ min(t(0,:,:)) +" Tmax on 1000mb="+ max(t(0,:,:)))
  
;--------------------------------------------------------------------------------
wks = gsn_open_wks ("png", "hw5-2-1")        ; send graphics to PNG file

res                      = True                    ; plot mods desired
res@gsnDraw              = False                   ; don't draw yet
res@gsnFrame             = False                   ; don't advance frame yet
res@gsnAddCyclic         = False
res@tiMainString         = "Meridional wind & temperature bias vertical profile" 
;res@mpDataBaseVersion      = "MediumRes"        ; better map outlines
res@cnLineLabelsOn= True
res@cnMinLevelValF       =  -40.                 ; set min contour level
res@cnMaxLevelValF       =   40.                  ; set max contour level
res@cnLevelSpacingF      =   5                  ; set contour spacing
res@tmXBMode               = "Explicit"
res@trXMinF = lat(17)         ; Set minimum X-axis value.
res@trXMaxF = lat(30)            ; Set maximum X-axis value.
res@vpHeightF              = 0.6                   ; change aspect ratio of plot
res@vpWidthF               = 0.6
res@cnLineThicknessF = 5.0
res@cnLineLabelBackgroundColor = -1

mpres = res
mpres@cnFillOn        = True                    ; turn on color 
mpres@cnFillPalette   = "grads_rainbow"           ; set color map
mpres@cnLevelSelectionMode = "ExplicitLevels"   ; set explicit contour levels
mpres@cnLevels  = (/0,1,2,3,4,5,6,7,8,9,10/)
mpres@cnLinesOn       = False                   ; turn off contour lines
mpres@tmXBMode               = "Explicit"

mpres@trXMinF = lat(17)         ; Set minimum X-axis value.
mpres@trXMaxF = lat(30)            ; Set maximum X-axis value.
mpres@tmYLMode="Explicit"
mpres@tmYLValues=(/0,1,2,3,4,5,6,7,8,9/)
mpres@tmYLLabels=(/1000,900,850,800,700,600,500,400,300,250/)+"mb"
;mpres@tmXBValues             = (/84,90.46,96.96,103.42,109.88,116.34,122.8,129.26,135.72,142.18,148.64,155.1,161.56,168.02/)
;mpres@tmXBLabels             = (/17,18,19,20,21,22,23,24,25,26,27,28,29,30/)+"N"
;mpres@cnLineLabelsOn  = False                   ; turn off line labels


plot=gsn_csm_contour(wks,t(:,85:168,137),mpres)
 res = True

plot2=gsn_csm_contour(wks,v(:,87:168,137),res)
 overlay(plot,plot2)
 draw(plot)
 frame(wks)
