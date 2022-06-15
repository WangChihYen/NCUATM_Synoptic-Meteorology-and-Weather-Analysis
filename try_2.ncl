  lines  = asciiread("012400.txt",-1,"string") ;一維變量
  nlines = dimsizes(lines)

  print(nlines)
  
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
    if(first.eq."D") then  ;換變數的第一個字都是D .eg.是等於的意思
      nl = nl + 1           ; increment line counter nl  = number line
      continue
    
;---Otherwise, get the number of rows and read the data.  
    else
      nrows = 739 ;to int(lines(nl)) 739是一個變數的列數
      
      if(nvar .gt. vars-1)then ;.gt.是greater than的意思
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
;反正上面的意思就是把數據間的空格變成只有一隔空格
      lines(nl:nl+nrows-1) = str_sub_str(lines(nl:nl+nrows-1),"    "," ") ;因為從0開始所以-1 把四個空格取代為一個空格
      lines(nl:nl+nrows-1) = str_sub_str(lines(nl:nl+nrows-1),"   "," ")
      lines(nl:nl+nrows-1) = str_sub_str(lines(nl:nl+nrows-1),"  "," ")
      lines(nl:nl+nrows-1) = str_strip(lines(nl:nl+nrows-1)) ;把頭尾空格取代掉

;---Parse the data into a 2D integer array
      x = tofloat(str_split_csv(lines(nl:nl+nrows-1)," ",0)) ;用空個的分隔符號切開 , 0代表要怎麼處理空格的 共有四種處理方式
      nl = nl + nrows ;要加739列讓他變成下一個變量
      ;print(x)

; . . .Do something here with 'x', like write it to a file. . .
      x1D =  ndtooned(x) ;把n維轉一維存到x裡 如果沒有轉維度會是(第幾列,第幾行)
      ;print(x1D(0:121*61-1)) ;121*61是網格點數 -1是因為從0開始數
      ;print(x1D)
      ;print(nvar+" "+nlev) ;這啥
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

U&lon = lon
U&lat = lat

H&lon@unit = 'degree_east'
H&lat = 'degree_north'

U&lon@unit = 'degree_east'
U&lat = 'degree_north'

copy_VarCoords(H,U)
copy_VarCoords(H,V)
copy_VarCoords(H,T)



do level = 0,levs-1
 wks = gsn_open_wks ("png", "try2_"+pressure_levels(level)+"hPa")       

 wsped=wind_speed(U,V)
 wsped@units="m/s"
 wsped@long_name="wind speed" 
 
 res                 = True                    ; plot mods desired
 res@gsnDraw         = False                   ; don't draw yet
 res@gsnFrame        = False                   ; don't advance frame yet
 res@gsnAddCyclic    = False
 
 res@mpLimitMode     = "LatLon"     ; required
 res@mpMinLatF       =  15.         ; min lat
 res@mpMaxLatF       =  60.         ; max lat
 res@mpMinLonF       =  90.        ; min lon
 res@mpMaxLonF       = 180.        ; max lon
 
 plot3 = gsn_csm_streamline_map_ce(wks,U(level,:,:),V(level,:,:),res)                        ;\\\\\繪製氣流線/////
 draw(plot3)
 frame(wks)
end do
 