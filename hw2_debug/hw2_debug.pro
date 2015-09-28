;Debugging Homework


pro error1
   x = findgen(10);creates an array of ten elements from 0 to 9
   for i = 0, n_elements(x)-1 do begin;should be "n_elements(x)-1"
       print, x[i];lacks a comma
   endfor
   ;typo
   ;this for loop prints every element of the array x in order
end
;there are a few syntax errors, and the for loop needs to stop at i=9.

pro error2;typo
   print, 'hello';lacks apostrophes
   ;this procedure prints the string "hello"
end
;there are two typos and the string should be inside apostrophes. 

pro error3;this is a procedure not a function
   a='ed '
   b=' is '
   c=' a girl?'
   result=a+b+c;d is not defined
   ;this prints the combination of the strings
   print, result
end
;this is a procedure not function, and an undefined value d is used.

pro error4
   x = [1,2,3]
   y = ['a','b', 'c']
   z = list(x, y);x and y do not have the same datatype
   print, z;prints the list
end
;Different datatypes are mixed together in an array and a list should be
;used as an alternative to put the two arrays together; it also lacks
;the print procedure.


pro error5
   x=findgen(100,100);creates a 100 by 100 array from 0 to 9999
   s=size(x)
   
   for i=0,s[1] do begin;s[1] = # of columns = 100
      for j=0,s[2] do begin;s[2] = # of rows = 100
         if i+j EQ 90 then begin;use EQ instead of =
            x[i,j]=0;replace such element with 0
         endif
      endfor
   endfor;should be "endfor"
   for i=0,s[1]-1 do begin
      for j=0,s[2]-1 do begin
         if i+j GT 45 then begin;use GT instead of >
            x[i,j]=i+j;replace such element with i+j
         endif
      endfor
      print, x
   endfor;lacks "endfor"
end
;for loops need to end with "endfor"; "=" and ">" should be replaced by EQ
;and GT in conditional statements.
;The second for loop seems to overwrite the result of the first loop
;since the condition "i+j EQ 90" is weaker than "i+j GT 45," so all
;the 0 terms become i+j after the second loop. I'm not sure if
;the program means to do so. If not, then we should consider switch the places
;of the two loops.






























































































;There are no easter eggs down here, go away.










































;The solution to Homework 2 can be found at...




































































;Haha, got ya
