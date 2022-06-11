;===========================================================
; read data
;===========================================================

 diri = "./"                            ; input directory
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
; printVarSummary(u)
; print(w)

;===========================================================
; a method but it didn't work in the end
;===========================================================

; z_t = (/1000,900,850,800,700,600,500,400,300,250/)
; lat = fspan(4.,43.,252)
; lon = fspan(95.,145.,252)
;   u!0 ="z_t"
;   u!2="lon"
;   u!1="lat"
;   t!0 ="z_t"
;   t&z_t = z_t
;   u&z_t = z_t
;   u&lon = lon
;   u&lat = lat
;   u&lon@units ="degree_east"
;   u&lat@units ="degree_north"
;   copy_VarCoords(u,v)
;   copy_VarCoords(u,w)
;   copy_VarCoords(u,t)
;   t!0 ="z_t"
;printVarSummary(v)


; latx = 23
; leftlat  =  17.0
; rightlat =  30.0
; leftlon  =  122
; rightlon =  122
; npts     =  100                    ; number of points in resulting transect

;-------------------------------------------------
; dist     = gc_latlon(leftlat,leftlon,rightlat,rightlon,npts,2)
; points   = ispan(0,npts-1,1)*1.0 
; printVarSummary(dist)


; trans   = linint2_points(t&lon,t&lat,t,True,dist@gclon,dist@gclat,2)
; copy_VarAtts(t,trans)          ; copy attributes

; trans!0      = "z_t"           ; create named dimension and assign
; trans&z_t    = t&z_t           ; coordinate variable for 0th dimension only

; printVarSummary(trans)
;--------------------------------------------------
; trans1   = linint2_points(u&lon,u&lat,t,True,dist@gclon,dist@gclat,2)
; copy_VarAtts(u,trans1)          ; copy attributes

; trans1!0      = "z_t"           ; create named dimension and assign
; trans1&z_t    = t&z_t           ; coordinate variable for 0th dimension o
; printVarSummary(trans1)


 lat = fspan(4.,43.,252)
 lon = fspan(95.,145.,252)
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

;====================================================================
; max & min
;====================================================================

 varsval = 4
 mx = new ( (/varsval,4/), float)
 n = 0
 do while (n.le.3)
 Data = x(n,:,:,:)
 mx(n,0) = max(Data)
 ; print(mx)
 DMax = max(Data)
 ; print(DMax)
 x1D = ndtooned(Data)     ; only do this once
 indices = ind_resolve(ind(x1D.eq.DMax),dimsizes(Data))  ; locations of max
 mx(n,1:3) = indices
 delete (x1D)
 n = n+1
 end do
 print(mx)


;======================================================
; plot
;======================================================

wks = gsn_open_wks ("png", "hw5-2-2")        ; send graphics to PNG file

 res                     = True          ; plot mods desired
 res@tmXBMode            = "Explicit"    ; explicitly label x-axis
; res@tmXBValues          = (/points(0),points(npts-1)/) ; points to label
; label values
; res@tmXBLabels          = (/leftlat +", "+leftlon,rightlat+", "+rightlon/)

 res@cnFillOn            = True                  ; turn on color
 res@cnFillPalette       = "grads_rainbow"       ; HgtHeightLabelOn = Falseset color map
 res@cnLevelSelectionMode = "ExplicitLevels"     ; set explicit contour levels
 res@cnLevels  = (/0,1,2,3,4,5,6,7,8,9,10/)
 res@cnLinesOn           = False                 ; turn off countour lines
 res@pmLabelBarOrthogonalPosF = -0.05            ; move label bar closer to plot
 
 res@gsnMaximize         = True                     ; plot will be fill the biggest possible space
 res@vpKeepAspect        = True                     ; keep aspect
 res@vpWidthF            = 1                        ; Change the aspect ratio, but 
 res@vpHeightF           = 0.7                      ; make plot as large as possible.
 res@tiMainString        = "meridional wind & temperature bias vertical profile"   ; add title
 res@tiMainFontHeightF= 0.035

 ; res@tiXAxisString       = "lat/lon along transect"
 ; res@trYReverse          = True         ; reverse y axis
 ; res@trXReverse          = True         ; reverse x axis (neg longitudes)
 ; res@cnLevelSpacingF     = 1.0          ; set contour spacing
 ; res@pmTickMarkDisplayMode = "Conditional"
 res@tmYLMode="Explicit"
 res@trXMinF = lat(17)            ; Set minimum X-axis value.
 res@trXMaxF = lat(30)            ; Set maximum X-axis value.
 res@tmYLValues=(/0,1,2,3,4,5,6,7,8,9/)
 res@tmYLLabels=(/1000,900,850,800,700,600,500,400,300,250/)+"mb"
 ;res@tmXBValues= (/85,96.96,103.42,109.88,116.34,122.8,129.26,135.72,142.18,148.64,155.1,161.56,165,168/)
 ;res@tmXBValues=(/0,20,40,60,80,100,120,140,160,180,200,220,240,260/)
 ;res@tmXBLabels=(/17,18,19,20,21,22,23,24,25,26,27,28,29,30/)+"N"
 res@tmYLLabelFontHeightF    = 0.02    ;set the size of y-Axis words
 res@tmXBLabelFontHeightF    = 0.02     ;set the size of x-Axis words


; plot = gsn_csm_contour(wks,trans,res)  ; create plot
  plot=gsn_csm_contour(wks,t(:,127,96:176),res)

;==================================================================

 zres = True
 zres@cnFillOn         = False
 zres@cnLineLabelBackgroundColor = -1
 zres@cnInfoLabelOn    = False
 zres@cnLineColor      = "Black"
 zres@cnLineThicknessF = 5.0
 zres@cnLineLabelsOn   = True
 zres@cnMinLevelValF       =  -40.                  ; set min contour level
 zres@cnMaxLevelValF       =   40.                  ; set max contour level
 zres@cnLevelSpacingF  = 10
 zres@gsnMaximize      = True                          ; plot will be fill
 zres@vpKeepAspect     = True                          ; keep aspect
 zres@vpWidthF         = 1                             ; Change the aspect
 zres@vpHeightF        = 0.8 
 zres@tmXBMode         = "Explicit"
 zres@trXMinF     = lat(17)     ; set minimum X-axis value
 zres@trXMaxF     = lat(30)     ; set maximum X-axis value
 
 plot2 = gsn_csm_contour(wks,v(:,127,96:176), zres)
 
 overlay (plot,plot2)
 draw(plot)
 frame(wks)




; show transect on a map
;********************************
; mres              = True                ; plot mods desired
; mres@gsnFrame     = False               ; don't turn page yet
; mres@gsnDraw      = False               ; don't draw yet
; mres@tiMainString = "Transect Location" ; title
; map = gsn_csm_map(wks,mres)         ; create map

; add polyline to map
; pres                  = True           ; polyline mods desired
; pres@gsLineColor      = "red"          ; color of lines
; pres@gsLineThicknessF = 2.0            ; line thickness   
; id = gsn_add_polyline(wks,map,(/leftlon,rightlon/),(/leftlat,rightlat/),pres)
; draw(map)    ; draws map and polyline






