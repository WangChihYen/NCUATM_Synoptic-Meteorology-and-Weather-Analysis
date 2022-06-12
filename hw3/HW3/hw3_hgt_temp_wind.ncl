  lines  = asciiread("012400.txt",-1,"string") ;一維變量
  nlines = dimsizes(lines)
;  print(nlines)

  mlon  = 121 ;90~180 0.75
  nlat  = 61 ;15~60 0.75
  levs  = 5 ;300,500,700,850,1000
  vars  = 4 ;H,U,V,T
  var   = new ( (/vars,levs,nlat,mlon/), float)

  pressure_levels = (/ 300,500,700,850,1000 /)

  nl    = 0    ; line counter 從0開始讀
  nvar = 0
  nlev = 0
  do while(nl.lt.nlines)
;---Read the first character of this line

    first = str_get_cols(lines(nl),0,0) ;把後面字串 起始行的0 ~ 終點站0
    
;---If it's a "%", then increment to next line.
    if(first.eq."D") then  ;換變數的第一個字都是D
      nl = nl + 1           ; increment line counter
      continue
    else
    
;---Otherwise, get the number of rows and read the data.
      nrows = 739 ;toint(lines(nl))
      if(nvar .gt. vars-1)then
         nvar = 0
         nlev = nlev + 1 ;第二行的*****不要
      end if
      nl = nl + 1           ; increment line counter
      ;print("==================================================")
      ;print("Reading " + nrows + " rows of data.")
;
; Clean up the strings so there's only one space between
; each string, and no extra space at beginning or end.
; This allows us to use str_split_csv to parse this
; chunk of data. str_split_csv expects a single character
; delimiter (a space in this case).
;
      lines(nl:nl+nrows-1) = str_sub_str(lines(nl:nl+nrows-1),"    "," ") ;因為從0開始所以-1 把四個空格取代為一個空格
      lines(nl:nl+nrows-1) = str_sub_str(lines(nl:nl+nrows-1),"   "," ")
      lines(nl:nl+nrows-1) = str_sub_str(lines(nl:nl+nrows-1),"  "," ")
      lines(nl:nl+nrows-1) = str_strip(lines(nl:nl+nrows-1)) ;把頭尾空格取代掉

;---Parse the data into a 2D integer array
      x = tofloat(str_split_csv(lines(nl:nl+nrows-1)," ",0)) ;用空個的分隔符號切開 , 0代表要怎麼處理空格的 共有四種處理方式
      nl = nl + nrows ;要加739讓他變成下一個變量

; . . .Do something here with 'x', like write it to a file. . .
      x1D =  ndtooned(x) ;把n維轉1維存到x裡
      ;print(x1D(0:121*61-1))
      ;print(nvar+" "+nlev)
      var(nvar,nlev,:,:) = reshape(x1D(0:mlon*nlat-1),(/nlat,mlon/)) ;整形成我們想要的形
      ;print(x1D(0)+"  "+x1D(mlon*nlat-1))   
      nvar = nvar + 1
    end if
  end do

lat = fspan(15,60,nlat)
lon = fspan(90,180,mlon)
H = var(0,:,:,:) ;第一層
H!0="lev"
H!1="lat"
H!2="lon"
H&lat=lat
H&lon=lon
H&lat@units="degrees_north"
H&lon@units="degrees_east"
U = var(1,:,:,:) ;第二層
V = var(2,:,:,:) ;第三層
T = var(3,:,:,:)

lat = fspan(15,60,61)
lon = fspan(90,180,121)

H!2 = 'lan'
H!1 = 'lat'
H&lon = lon
H&lat = lat
H&lon@unit = 'degree_east'
H&lat = 'degree_north'

copy_VarCoords(H,U)
copy_VarCoords(H,V)
copy_VarCoords(H,T)








do level = 0,levs-1
 ;wks = gsn_open_wks ("x11", "hw3_"+pressure_levels(level)+"hPa")        ; send graphics to PNG file 預覽
 ;wks代表掀開個視窗給他畫圖
 wks = gsn_open_wks ("png", "hw3_"+pressure_levels(level)+"hPa")        ; send graphics to PNG file 要輸出的檔案

 res                 = True                    ; plot mods desired
 res@tiMainString    = pressure_levels(level)+"hPa"+" hgt,temp,wind"
 res@gsnDraw         = False                   ; don't draw yet
 res@gsnFrame        = False                   ; don't advance frame yet
 res@gsnAddCyclic    = False

 mpres = res
 mpres@cnLevelSpacingF = 5
 mpres@tiMainOn        = False
 mpres@cnFillOn        = True                    ; turn on color 
 mpres@cnFillPalette   = "gui_default"           ; set color map
 mpres@cnLinesOn       = False                   ; turn off contour lines
 ;mpres@cnLineLabelsOn  = False                   ; tuen off line labels

 mpres@mpLimitMode     = "LatLon"     ; required
 mpres@mpMinLatF       =  15.         ; min lat
 mpres@mpMaxLatF       =  60.         ; max lat
 mpres@mpMinLonF       =  90.        ; min lon
 mpres@mpMaxLonF       = 180.        ; max lon
 
 plot = gsn_csm_contour_map(wks, T(4,:,:), mpres)
 ;4: 300~500~700~900~1000 從0開始數
 
 zres = res
 zres@cnFillOn         = False
 ;zres@cnLineLabelPerimOn = False
 zres@cnLineLabelBackgroundColor = -1
 zres@cnInfoLabelOn    = False
 zres@lbLabelBarOn     = False                   ; will draw a panel label bar instead
 zres@cnLineColor      = "white"
 zres@cnLineThicknessF = 3.0
 if (pressure_levels(level) .le. 500)then
   zres@cnLevelSpacingF = 60
 else
   zres@cnLevelSpacingF = 30
 end if 

 plot2 = gsn_csm_contour(wks, H(4,:,:), zres);代表對等高線做描述
 
 vecres = res
 vecres@vcGlyphStyle              = "WindBarb"     ; select wind barbs
 vecres@vcRefLengthF              = 0.008           ; define length of vec ref
 vecres@vcRefAnnoOn               = False          ; turn off ref wind barb
 vecres@vcMinDistanceF            = 0.012          ; thin out windbarbs
 vecres@vcWindBarbLineThicknessF  = 3.             ; set the wind barb thickness
 vecres@trYReverse                = True           ; reverse the Y-axis
 vecres@vcWindBarbColor           = (/111,111,111/)/255.

 vector = gsn_csm_vector(wks,U(4,:,:),V(4,:,:),vecres)
 
 overlay(plot,plot2)
 overlay(plot,vector)
 draw(plot)
 frame(wks)

end do

;畫好第一張圖