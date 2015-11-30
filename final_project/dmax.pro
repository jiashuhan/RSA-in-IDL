function dmax, e
  k=1
  while (291600*k+1) MOD e NE 0 do begin
     k+=1
  endwhile
  print, k
  d=(291600*k+1)/e
  print, d
  return,d
end
