  lines  = asciiread("012400.txt",-1,"string") ;�@���ܶq
  nlines = dimsizes(lines)

  print(nlines)
  
  mlon  = 121 ;90~180 0.75
  nlat  = 61 ;15~60 0.75
  levs  = 5 ;300,500,700,850,1000
  vars  = 4 ;H,U,V,T
  var   = new ( (/vars,levs,nlat,mlon/), float)

  pressure_levels = (/ 300,500,700,850,1000 /)

  nl    = 0    ; line counter �q0�}�lŪ
  nvar = 0
  nlev = 0
  
  do while(nl.lt.nlines)
;---Read the first character of this line

    first = str_get_cols(lines(nl),0,0) ;��᭱�r�� �_�l�檺0 ~ ���I��0
    
;---If it's a "%", then increment to next line.
    if(first.eq."D") then  ;���ܼƪ��Ĥ@�Ӧr���OD .eg.�O���󪺷N��
      nl = nl + 1           ; increment line counter nl  = number line
      continue
    
;---Otherwise, get the number of rows and read the data.  
    else
      nrows = 739 ;to int(lines(nl)) 739�O�@���ܼƪ��C��
      
      if(nvar .gt. vars-1)then ;.gt.�Ogreater than���N��
         nvar = 0
         nlev = nlev + 1 ;�ĤG�檺*****���n
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
;�ϥ��W�����N��N�O��ƾڶ����Ů��ܦ��u���@�j�Ů�
      lines(nl:nl+nrows-1) = str_sub_str(lines(nl:nl+nrows-1),"    "," ") ;�]���q0�}�l�ҥH-1 ��|�ӪŮ���N���@�ӪŮ�
      lines(nl:nl+nrows-1) = str_sub_str(lines(nl:nl+nrows-1),"   "," ")
      lines(nl:nl+nrows-1) = str_sub_str(lines(nl:nl+nrows-1),"  "," ")
      lines(nl:nl+nrows-1) = str_strip(lines(nl:nl+nrows-1)) ;���Y���Ů���N��

;---Parse the data into a 2D integer array
      x = tofloat(str_split_csv(lines(nl:nl+nrows-1)," ",0)) ;�ΪŭӪ����j�Ÿ����} , 0�N���n���B�z�Ů檺 �@���|�سB�z�覡
      nl = nl + nrows ;�n�[739�C���L�ܦ��U�@���ܶq
      ;print(x)

; . . .Do something here with 'x', like write it to a file. . .
      x1D =  ndtooned(x) ;��n����@���s��x�� �p�G�S������׷|�O(�ĴX�C,�ĴX��)
      ;print(x1D(0:121*61-1)) ;121*61�O�����I�� -1�O�]���q0�}�l��
      ;print(x1D)
      ;print(nvar+" "+nlev) ;�oԣ
      var(nvar,nlev,:,:) = reshape(x1D(0:mlon*nlat-1),(/nlat,mlon/)) ;��Φ��ڭ̷Q�n����
      ;print(x1D(0)+"  "+x1D(mlon*nlat-1))   
      nvar = nvar + 1
      
    end if
    
  end do

lat = fspan(15,60,nlat)
lon = fspan(90,180,mlon)
H = var(0,:,:,:) ;�Ĥ@�h
H!0="lev"
H!1="lat"
H!2="lon"
H&lat=lat
H&lon=lon
H&lat@units="degrees_north"
H&lon@units="degrees_east"
U = var(1,:,:,:) ;�ĤG�h
V = var(2,:,:,:) ;�ĤT�h
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
 wks = gsn_open_wks ("png", "hw3_"+pressure_levels(level)+"hPa streamline")       
 
 
 res                 = True                    ; plot mods desired
 res@gsnDraw         = False                   ; don't draw yet
 res@gsnFrame        = False                   ; don't advance frame yet
 res@gsnAddCyclic    = False
 res@tiMainString    = pressure_levels(level)+"hPa"+" streamline"
 
 res@mpLimitMode     = "LatLon"     ; required
 res@mpMinLatF       =  15.         ; min lat
 res@mpMaxLatF       =  60.         ; max lat
 res@mpMinLonF       =  90.        ; min lon
 res@mpMaxLonF       = 180.        ; max lon
 
 plot2 = gsn_csm_streamline_map_ce(wks,U(level,:,:),V(level,:,:),res)                        ;\\\\\ø�s��y�u/////
 draw(plot2)
 frame(wks)
end do
 