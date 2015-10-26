function load_spec
  ;loads spectra from .txt file
  readcol, 'spectra.txt', x, y, skipline=17, numline=2048, format='F,F'
  ret_arr=[[x],[y]]
  ;returns data in an array
  return, ret_arr
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;procedure to overplot vertical lines
;written by JohnJohn, found on astro.berkeley.edu
pro vline, val,_extra=extra, min=min, max=max
  if !y.type eq 1 then yrange = 10^!y.crange else yrange = !y.crange
  nv = n_elements(val)
  for i = 0, nv-1 do oplot,fltarr(2)+val[i],yrange,_extra=extra
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

pro plot_spec
  ;loads spectra, finds the centroids, and plots the result
  spectra=load_spec()
  x=spectra[*,0]
  y=spectra[*,1]
  c=find_spec_centroid()
  setcolors, /system_variables
  ;plots spectra
  plot, x, y, title='Some Spectra', xtitle='Pixel', ytitle='Intensity', charsize=1.5
  ;plots centroids as vertical lines
  vline, c, color=!red, linestyle=2
  items=['Spectra','Centroids']
  psyma=[0,0]
  line=[0,2]
  color=[!white, !red]
  legend, items, psym=psyma, linestyle=line, charsize=1.5, colors=color, textcolor=!white, /right
  ;prints the centroids in an array 'c' 
  print, c
end

function find_spec_centroid
  ;finds centroids for the spectra
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

pro gen_gauss
  ;defines and plots three gaussian distributions, and then finds their centroids
  x=findgen(50)-25
  d1=1/(1*(2*!pi)^0.5)*(exp(1))^(-((x-0)^2.)/(2*1^2.))
  d2=1/(3*(2*!pi)^0.5)*(exp(1))^(-((x-15)^2.)/(2*3^2.))
  d3=1/(1.5*(2*!pi)^0.5)*(exp(1))^(-((x-(-18))^2.)/(2*1.5^2.))
  plot, x, d1, xrange=[-25,25], yrange=[0,0.5], color=!white, charsize=1.5, psym=10, title='Gaussian Distributions', xtitle='x', ytitle='Frequency'
  oplot, x, d1, color=!blue, psym=10
  oplot, x, d2, color=!green, psym=10
  oplot, x, d3, color=!red, psym=10
  ;finds centroids for the distributions
  c=find_gauss_centroid()
  setcolors, /system_variables
  ;plots centroids as vertical lines
  vline, c, color=!red, linestyle=2
  items=['Distributions','Centroids']
  psyma=[0,0]
  line=[0,2]
  color=[!white, !red]
  legend, items, psym=psyma, linestyle=line, charsize=1.5, colors=color, textcolor=!white, /right
  ;prints the centroids in an array 'c' 
  print, c
end

function find_gauss_centroid
  ;finds centroids for the gaussian distributions
  x=findgen(50)-25
  d1=1/(1*(2*!pi)^0.5)*(exp(1))^(-((x-0)^2.)/(2*1^2.))
  d2=1/(3*(2*!pi)^0.5)*(exp(1))^(-((x-15)^2.)/(2*3^2.))
  d3=1/(1.5*(2*!pi)^0.5)*(exp(1))^(-((x-(-18))^2.)/(2*1.5^2.))
  y=d1+d2+d3
  mean=mean(y)
  ;checks high frequency region (F>mean)
  i=0
  array0=[]
  array1=[]
  array2=[]
  while 1 do begin
     i=i+1
     if y[i] GT mean then break
  endwhile
  ;finds centroid using a +/- 6 interval
  for m=i-6,i+6 do begin
     array0=[array0,x[m]*y[m]]
     array1=[array1,y[m]]
  endfor
  c=total(array0)/total(array1)
  array2=[array2,c]
  ;repeat this process until the end of distribution
  while 1 do begin
     if i+1 GE n_elements(y)-1 then break
     i=i+6
     array0=[]
     array1=[]
     ;checks next high frequency region
     while 1 do begin
        i=i+1
        if i GE n_elements(y)-1 then break
        if y[i] GT mean then break
     endwhile
     for m=i-6,i+6 do begin
        if m GE n_elements(y)-1 then break
        array0=[array0,x[m]*y[m]]
        array1=[array1,y[m]]
     endfor
     c=total(array0)/total(array1)
     if y[i] GT mean then begin
        array2=[array2,c]
     endif
  endwhile
  ;return the array containing the centroids
  return, array2
end
