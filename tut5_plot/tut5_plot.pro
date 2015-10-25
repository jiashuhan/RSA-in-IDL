pro plotty
  ;define x values
  x=findgen(2000000)/1000000-1
  y1=(1.-x^2.)^(0.5);upper head
  y2=-((1.-x^2.)^(0.5));lower head
  y3=-(9/16.-x^2.)^(0.5);mouth
  y4=(1/25.-4*(x-0.25)^2.)^0.5+0.1;upper right eye
  y5=-(1/25.-4*(x-0.25)^2.)^0.5+0.1;lower right eye
  y6=(1/25.-4*(x+0.25)^2.)^0.5+0.1;upper left eye
  y7=-(1/25.-4*(x+0.25)^2.)^0.5+0.1;lower left eye
  ;start save procedure
  ps_ch, 'smiley.ps', /defaults, /color, xsize=8
  ;plot upper head
  plot, x, y1, /isotropic, xrange=[-1.,1.], yrange=[-1.,1.], title="I'm Not Mad!", charsize=2
  ;overplot with other parts
  oplot, x, y2
  oplot, x, y3, color=!green
  oplot, x, y4, color=!red
  oplot, x, y5, color=!red
  oplot, x, y6, color=!red
  oplot, x, y7, color=!red
  ;end save procedure
  ps_ch, /close
  ;plot again in the IDL window
  plot, x, y1, /isotropic, xrange=[-1.,1.], yrange=[-1.,1.], title="I'm Not Mad!", charsize=2
  oplot, x, y2
  oplot, x, y3, color=!green
  oplot, x, y4, color=!red
  oplot, x, y5, color=!red
  oplot, x, y6, color=!red
  oplot, x, y7, color=!red
end

pro smiley_wink
  ;define x values
  x=findgen(2000000)/1000000-1
  y1=(1.-x^2.)^(0.5);upper head
  y2=-((1.-x^2.)^(0.5));lower head
  y3=-(9/16.-x^2.)^(0.5);mouth
  y4=(1/25.-4*(x-0.25)^2.)^0.5;winking right eye
  y5=(1/25.-4*(x+0.25)^2.)^0.5+0.1;upper left eye
  y6=-(1/25.-4*(x+0.25)^2.)^0.5+0.1;lower left eye
  ;plot upper head
  plot, x, y1, /isotropic, xrange=[-1.,1.], yrange=[-1.,1.], title="I'm Not Mad!", charsize=2
  ;overplot with other parts
  oplot, x, y2
  oplot, x, y3, color=!green
  oplot, x, y4, color=!red
  oplot, x, y5, color=!red
  oplot, x, y6, color=!red
end
