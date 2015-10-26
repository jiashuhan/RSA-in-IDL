pro plotf
  ;plots the original PDF
  x=findgen(50)
  f=10^x/factorial(x)*(exp(1))^(-10)
  plot, x, f, psym=10, title='PDF Plots', xtitle='Location', ytitle='Count', charsize=1.5
  oplot, x, f, psym=10, color=!blue
end

function prob_test, x
  ;returns 3 probabilities for a given value x using MCMC equations
  if x LE 9 then begin
     p1=x/20.
     p2=(10.-x)/20
     p3=1/2.
  endif else begin
     p1=1/2.
     p2=(x-9.)/(2*(x+1))
     p3=5./(x+1)
  endelse
  ;p_arr includes 3 probabilities
  p_arr=[p1,p2,p3]
  return, p_arr
end

function step_decide, prob_arr
  ;using results from prob_test to make a random decision
  ;generates a random value y
  y=randomu(seed)
  ;compare y to the intervals that represent the three cases 
  if y LT prob_arr[0] then begin
     z=-1;move 1 unit to the left
  endif else begin
     if y GT prob_arr[0]+prob_arr[1] then begin
        z=1;move 1 unit to the right
     endif else begin
        z=0;stay the same place
     endelse
  endelse
  return, z
end

pro main, steps, x0
  ;runs all procedures, inputs are number of steps and initial value
  step_arr=[]
  ;the inputs must be integers
  if (size(steps))[1] NE 2 then begin
     print, 'number of steps must be an integer'
  endif else begin
     if (size(x0))[1] NE 2 then begin
        print, 'input number must be an integer'
     endif else begin
        ;record all steps in an array
        for i=0, steps-1 do begin
           step_arr=[step_arr, x0]
           p_arr=prob_test(x0)
           z=step_decide(p_arr)
           x0=x0+z
        endfor
     endelse
  endelse
  ;use plot_mcmc to plot all steps and the density curves
  plot_mcmc, step_arr
end

pro plot_mcmc, step_arr
  ;plots all steps, the original PDF, and the approximated PDF
  x=findgen(n_elements(step_arr)-1)
  y=step_arr
  ;create a density array using the histogram function
  y_pdf=histogram(y, locations=binvals, binsize=1)
  ;normalize the density array
  y_normpdf=y_pdf/total(y_pdf)
  ;print the density array with binsize=1
  print, y_normpdf
  ;allow 2 plots in a window
  !p.multi=[0,1,2]
  ;plot steps
  plot, x, y, title='MCMC A Simple Distribution', xtitle='Steps', ytitle='Location', charsize=1.5
  oplot, x, y, color=!green
  ;plot original PDF
  plotf
  ;overplot approximated PDF
  oplot, x, y_normpdf, psym=10, color=!green
  items=['Original','Approximation']
  psyma=[0,0]
  line=[0,0]
  color=[!blue, !green]
  legend, items, psym=psyma, linestyle=line, charsize=1.5, colors=color, textcolor=!white, /right
end
