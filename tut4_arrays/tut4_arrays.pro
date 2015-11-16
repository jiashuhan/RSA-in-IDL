pro centroiding
  ;loads spectra, finds the centroids, and plots the result
  spectra=load_spec()
  x=spectra[*,0]
  y=spectra[*,1]
  c=find_centroid()
  y1=fltarr(n_elements(c))+2000
  setcolors, /system_variables
  ;plots spectra
  plot, x, y, title='Some Spectra', xtitle='Wavelength', ytitle='Intensity', charsize=2, color=!white, background=!black
  ;plots centroids (arbitrary height of 2000)
  oplot, c, y1, psym=7, symsize=2, color=!red 
  items=['Spectra','Centroids']
  psyma=[0,7]
  line=[0,0]
  color=[!white, !red]
  legend, items, psym=psyma, linestyle=line, charsize=2, colors=color, textcolor=!white, /right
  ;prints the centroids in an array 'c' 
  print, c
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;using joe's function here to load spectra from .txt file
function load_spec
  readcol, 'spectra.txt', spectrax, spectray, format='F,F', numline=2048, skipline=17
  ret_arr=[[spectrax],[spectray]]
  return, ret_arr
end
;credit to joe zalesky
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

function find_centroid
  ;finds centroids
  spectra=load_spec()
  x=spectra[*,0]
  y=spectra[*,1]
  ;checks high intensity region (I>1000)
  i=0
  array0=[]
  array1=[]
  array2=[]
  while 1 do begin
     i=i+1
     if y[i] GT 1000 then break
  endwhile
  ;finds centroid using a +/- 50 interval
  for m=i-50,i+50 do begin
     array0=[array0,x[m]*y[m]]
     array1=[array1,y[m]]
  endfor
  c=total(array0)/total(array1)
  array2=[array2,c]
  ;repeat this process until the end of spectra
  while 1 do begin
     if i+1 GE n_elements(y)-1 then break
     i=i+50
     array0=[]
     array1=[]
     ;checks next high intensity region
     while 1 do begin
        i=i+1
        if i GE n_elements(y)-1 then break
        if y[i] GT 1000 then break
     endwhile
     for m=i-50,i+50 do begin
        if m GE n_elements(y)-1 then break
        array0=[array0,x[m]*y[m]]
        array1=[array1,y[m]]
     endfor
     c=total(array0)/total(array1)
     if y[i] GT 1000 then begin
        array2=[array2,c]
     endif
  endwhile
  ;return the array containing the centroids
  return, array2
end

;;;;;;;;;;;;;nice;;;;;;;;;;;;;
