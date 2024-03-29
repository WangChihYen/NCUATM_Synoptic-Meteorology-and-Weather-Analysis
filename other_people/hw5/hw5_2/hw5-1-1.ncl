;===========================================================
; read data
;===========================================================

diri = "./"                             ; input directory
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
 printVarSummary(t)
; print(t)

 WS = (u^2+v^2)^(0.5)
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
;printVarSummary(u)

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
 ;printVarSummary(mx)
 ;print(mx)

;=====================================================================
; plot
;=====================================================================

 wks = gsn_open_wks ("png", "hw5-1-1_850")        ; send graphics to PNG file

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
 res@cnLevelSelectionMode = "ExplicitLevels"    ; set explicit contour levels
 res@cnLevels  = (/5,10,15,20,25,30,35,40,45,50,55,60/)
 
 res@tfDoNDCOverlay = "NDCViewport"             ; True
 res@mpGridAndLimbOn = True                     ; turn on lat/lon lines.
 res@mpGridLatSpacingF = 1                      ; change latitude line spacing
 res@mpGridLonSpacingF = 2                      ; change longitude line spacing
 res@pmTickMarkDisplayMode = "Conditional"      ; show lat and lon coordinate

 mpres = res
 mpres@cnLevelSpacingF = 5
 mpres@cnFillOn        = True                    ; turn on color 
 mpres@cnFillPalette   = "grads_rainbow"         ; set color map
 mpres@cnLinesOn       = False                   ; turn off contour lines
 mpres@tiMainString    = "850mb Streamline & Wind speed field" ; title
 mpres@tiMainFontHeightF= 0.02                 


 plot = gsn_csm_contour_map(wks, WS(2,84:172,96:176), mpres)

 res = True

 plot2 = gsn_csm_streamline(wks,u(2,84:172,96:176),v(2,84:172,96:176),res)

 overlay(plot,plot2)
 draw(plot)
 frame(wks)






