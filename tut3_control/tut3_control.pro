pro intersqrt, a, b
  ;this procedure prints the square roots of all integers between a and b
  input_arr = [a,b]
  s=size(input_arr)
  if s[2] NE 2 then begin
     print, "the inputs must be positive integers."
  endif else begin
     if a LE 0 then begin
        print, "the first input must be a positive integer."
     endif else begin
        if b LE 0 then begin
           print, "the second input must be a positive integer."
        endif else begin
           if a GE b then begin
              print, "the first input must be less than the second input."
           endif else begin
              for i=a+1, b-1 do begin
                 print, sqrt(i)
              endfor 
           endelse
        endelse
     endelse
  endelse
end

pro factorial, a
  ;this procedure calculates the factorial of any integrer a between [1,12]
  x=[a]
  s=size(x)
  if s[2] NE 2 then begin;checks datatype
     print, "input must be an integer."
  endif else begin
     if a LT 1 then begin;checks domain
        print, "input must be between [1,12]."
     endif else begin
        if a GT 12 then begin;checks domain
           print, "input must be between [1,12]."
        endif else begin
           print, factorial(a)
        endelse
     endelse
  endelse
end

function randomarr_loop
  ;this function generates a random array of elements GE 50.0 using loop
  array = randomu(seed,1000)*100;generate random array
  a = list();create an empty list
  for i=0, 999 do begin
     if array[i] GE 50.0 then begin
        a.add, array[i];add elements GE 50.0 to the empty list
     endif
  endfor
  b = a.toarray();convert list to array
  return, b
end

function randomarr_where
  ;this function generates a random array of elements GE 50.0 using where
  array = randomu(seed,1000)*100
  array1 = array[where(array GE 50.0)];take out elements GE 50.0
  return, array1
end
