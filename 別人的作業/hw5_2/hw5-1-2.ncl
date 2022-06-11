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
; printVarSummary(w)
; print(w)

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

;=====================================================================
; plot
;=====================================================================

wks = gsn_open_wks ("png", "hw5-1-2-300")        ; send graphics to PNG file

 res                 = True                    ; plot mods desired
 res@gsnDraw         = False                   ; don't draw yet
 res@gsnFrame        = False                   ; don't advance frame yet
 res@gsnAddCyclic    = False

 res@mpProjection = "LambertConformal"         ; use Lambert projection 
 res@mpGeophysicalLineColor = "Black"          ; Line Color
 res@mpGeophysicalLineThicknessF = 3           ; Line Thickness
 res@mpLambertParallel1F = 10.0
 res@mpLambertParallel2F = 40.0
 res@mpLambertMeridianF = 120.0
 res@mpLimitMode = "Corners"
 res@mpLeftCornerLatF = 17
 res@mpLeftCornerLonF = 114
 res@mpRightCornerLatF= 30
 res@mpRightCornerLonF= 130
 res@tfDoNDCOverlay = "NDCViewport"            ;True 
 res@pmTickMarkDisplayMode = "Conditional"     ; turn on lat/lon lines.

 vres                            = res
 vres@vcGlyphStyle               = "LineArrow"
 vres@vcLineArrowThicknessF      = 5
 vres@vcMinDistanceF             = 0.01
 vres@vcRefLengthF               = 0.02
 vres@vpUseSegments              = True
 vres@vpXF                       = 1         ; labelbar position in x direction 
 vres@vpYF                       = 3         ; labelbar position in y direction3
 vres@vpKeepAspect               = True
 vres@mpGridAndLimbOn            = True      ; turn on lat/lon lines.
 vres@mpDataBaseVersion          = "MediumRes"    ; better map outlines
 vres@vpHeightF                  = 0.5            ; change aspect ratio of plot
 vres@vpWidthF                    = 0.5


 mpres = res
 mpres@cnLevelSpacingF = 5
 mpres@cnFillOn        = True                      ; turn on color 
 mpres@cnFillPalette   = "grads_rainbow"           ; set color map
 mpres@cnLinesOn       = False                     ; turn off contour lines
 mpres@cnLevelSelectionMode = "ExplicitLevels"     ; set explicit contour levels
 mpres@cnLevels  = (/-1.5,-1,-0.5,0,0.5,1,1.5,2,2.5/)
 mpres@tiMainString    = "300mb Wind field & Vertical velocity" ; title
 mpres@tiMainFontHeightF= 0.02


 plot = gsn_csm_contour_map(wks, w(8,84:172,96:176), mpres)

 res = True

 vector = gsn_csm_vector(wks,u(8,84:172,96:176),v(8,84:172,96:176),vres)
 
 overlay (plot,vector)
 draw(plot)
 frame(wks)






