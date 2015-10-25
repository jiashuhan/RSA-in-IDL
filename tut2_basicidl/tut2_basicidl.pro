function r_t_d, r
;this function converts radian to degree
  
  ;output is in degree
  d = 180*r/!pi

  return, d

end

function d_t_r, d
;this function converts degree to radian

  ;output is in radian
  r = !pi*d/180

  return, r

end

function weight_of_mars, m
;this function returns the weight of a mass on Mars in lbs
  
  ;the gravity of Mars is 3.711/9.807 of the Earth; 1kg = 2.20462 lbs
  w = m*3.711/9.807*2.20462

  return, w

end

pro tip_calc, n, a
;this procedure is a tip calculator
;n = group size, a = bill, t = tip, p = tip per person, b = total cost

  t = 0.15*a
  p = t/n
  b = a+t
  output_arr = [t, p, b]

  ;prints t, p, and b for given values of n and a
  print, output_arr

end

pro swap_em, a, b, c
;this procedure swaps the values of a and b

  ;c is equal to the original a, a is equal to the original b
  c = a
  a = b
  b = c

  print, a, b

end

function nth_root, a, b
;this function takes the ath root of b

  input_arr = [a,b]
  root = b^(1./a)
  ;the root is a float

  return, root

end
