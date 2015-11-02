function x_vector
  ;loads in data from data.dat and returns array containing x and y
  readcol, 'data.dat', x, y, format='F,F', numline=1000
  a=fltarr(n_elements(x))+1
  ;appending a to x gives us x' but it's more convenient to do it in main 
  ret_arr=[[x],[a],[y]]
  return, ret_arr
end

function find_coeffs, y, x_prime
  ;calculates A given y and x'
  x_t=transpose(x_prime)
  A=invert(x_t ## x_prime) ## x_t ## y
  return, A
end

function regress, x_prime, A
  ;returns y' given x' and A
  y_prime=x_prime ## A
  return, y_prime
end

pro main
  ;runs all procedures and functions
  ;plots the data and the best-fit line and saves the plot
  arr=x_vector()
  x=arr[*,0]
  b=arr[*,1]
  y=arr[*,2]
  ;define x' and find A and y'
  x_prime=transpose([[x],[b]])
  A=find_coeffs(y,x_prime)
  y_prime=regress(x_prime,A)
  ;plot the data and the best-fit line
  plot, x, y, title='y=mx+b', psym=1, xtitle='x value', ytitle='y value', charsize=1.5
  oplot, x, y, color=!blue, psym=1
  oplot, x, y_prime, color=!green
  itemsa=['Data','Fit']
  psyma=[1,0]
  colora=[!blue,!green]
  legend, itemsa, psym=psyma, color=colora, charsize=1.5, /left
  ;save the plot as a .ps file
  ps_ch, 'best_fit_jiashu.han.ps', /defaults, /color
  plot, x, y, title='y=mx+b', psym=1, xtitle='x value', ytitle='y value', charsize=1.5
  oplot, x, y, color=!blue, psym=1
  oplot, x, y_prime, color=!green
  itemsa=['Data','Fit']
  psyma=[1,0]
  colora=[!blue,!green]
  legend, itemsa, psym=psyma, color=colora, charsize=1.5, /left
  ps_ch, /close
  ;print A
  print, A
end
