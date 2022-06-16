  lines  = asciiread("012400.txt",-1,"string")
  nlines = dimsizes(lines)
;  print(nlines)

  mlon  = 121 ;90~180 0.75
  nlat  = 61 ;15~60 0.75
  levs  = 5 ;300,500,700,850,1000
  vars  = 4 ;H,U,V,T
  var   = new ( (/vars,levs,nlat,mlon/), float)

  pressure_levels = (/ 300,500,700,850,1000 /)

  nl    = 0    ; line counter
  nvar = 0
  nlev = 0
  do while(nl.lt.nlines)
;---Read the first character of this line
    first = str_get_cols(lines(nl),0,0)
;---If it's a "%", then increment to next line.
    if(first.eq."D") then
      nl = nl + 1           ; increment line counter
      continue
    else
;---Otherwise, get the number of rows and read the data.
      nrows = 739 ;toint(lines(nl))
      if(nvar .gt. vars-1)then
         nvar = 0
         nlev = nlev + 1
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
      lines(nl:nl+nrows-1) = str_sub_str(lines(nl:nl+nrows-1),"    "," ")
      lines(nl:nl+nrows-1) = str_sub_str(lines(nl:nl+nrows-1),"   "," ")
      lines(nl:nl+nrows-1) = str_sub_str(lines(nl:nl+nrows-1),"  "," ")
      lines(nl:nl+nrows-1) = str_strip(lines(nl:nl+nrows-1))

;---Parse the data into a 2D integer array
      x = tofloat(str_split_csv(lines(nl:nl+nrows-1)," ",0))
      nl = nl + nrows

; . . .Do something here with 'x', like write it to a file. . .
      x1D =  ndtooned(x)
      ;print(x1D(0:121*61-1))
      ;print(nvar+" "+nlev)
      var(nvar,nlev,:,:) = reshape(x1D(0:mlon*nlat-1),(/nlat,mlon/))
      ;print(x1D(0)+"  "+x1D(mlon*nlat-1))   
      nvar = nvar + 1
    end if
  end do

lat = fspan(15,60,nlat)
lon = fspan(90,180,mlon)
H = var(0,:,:,:)
H!0="lev"
H!1="lat"
H!2="lon"
H&lat=lat
H&lon=lon
H&lat@units="degrees_north"
H&lon@units="degrees_east"
U = var(1,:,:,:)
V = var(2,:,:,:)
T = var(3,:,:,:)
copy_VarCoords(H,U)
copy_VarCoords(H,V)
copy_VarCoords(H,T)

do level = 0,levs-1
 wks = gsn_open_wks ("png", "hw3-2_"+pressure_levels(level)+"hPa")        ; send graphics to PNG file

 res                 = True                    ; plot mods desired
 res@gsnDraw         = False                   ; don't draw yet
 res@gsnFrame        = False                   ; don't advance frame yet
 res@gsnAddCyclic    = False

 res@mpLimitMode     = "LatLon"                ; required
 res@mpMinLatF       =  15.                    ; min lat
 res@mpMaxLatF       =  60.                    ; max lat
 res@mpMinLonF       =  90.                    ; min lon
 res@mpMaxLonF       = 180.                    ; max lon

 plot = gsn_csm_map_ce (wks, res)

 rse_vc  = res
 rse_vc@stArrowLengthF     = 0.004             ; size of the arrows
 rse_vc@stMinArrowSpacingF = 0.004             ; arrow spacing
 rse_vc@stArrowStride      = 3                 ; arrows start every 3rd
 rse_vc@tiMainString  = ""+pressure_levels(level)+"hpa Streamline" ; title
 rse_vc@tiMainFontHeightF = 0.02                                   ; the size of title

 vector= gsn_csm_streamline (wks,U(level,:,:),V(level,:,:),rse_vc)
 
 overlay(plot,vector)
 draw(plot)
 frame(wks)

end do
