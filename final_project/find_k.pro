pro find_k, p, q, e
  k=double(1)
  a=double(p*q)
  b=double((p-1)*(q-1))
  d=(b*k+1)/e
  print,d
  print, p*q
  while d mod (p*q) NE 0 do begin
     k+=1
  endwhile
  print, k
  print, d
end
