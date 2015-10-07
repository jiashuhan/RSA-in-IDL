function load_spec
  
  readcol, 'spectra.txt', spectrax, spectray, format='F,F', numline=2048, skipline=17
  
  ret_arr=[[spectrax],[spectray]]
  
  return, ret_arr

end
