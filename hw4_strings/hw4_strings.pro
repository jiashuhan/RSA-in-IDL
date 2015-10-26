pro extract
  ;extracts lines from the file, based on code from exelisvis.com
  openr, lun, 'clues.txt', /get_lun
  ;read one line at a time, saving the result into array
  array=''
  line=''
  while not EOF(lun) do begin
     readf, lun, line
     array = [array, line]
  endwhile
  ;close the file and free the file unit
  free_lun, lun
  ;create a new array and add 1st element
  array1=''
  array1=[array1, strlowcase(strmid(array[1],0,1))]
  ;add 2nd element
  for i=0, n_elements(array)-1 do begin
     if strmatch(array[i],'*og*') EQ 1 then begin
        array1=[array1, strmid(array[i],strpos(array[i],'og'),2)]
     endif
  endfor
  ;add 3rd element
  array1=[array1, '_']
  ;add 4th element
  for i=0, n_elements(array)-1 do begin
     if strmatch(array[i],'*ate*') EQ 1 then begin
        array1=[array1, strmid(array[i],strpos(array[i],'p'),3)]
     endif
  endfor
  ;add 5th element
  for i=0, n_elements(array)-1 do begin
     if strmatch(array[i],'*x*') EQ 1 then begin
        array1=[array1, strmid(array[i],0,2)]
        break
     endif
  endfor
  ;collapse array into a single string
  string=strjoin(array1, /single)
  ;find last 'o' and replace it with empty string
  a=strpos(string, 'o', /reverse_search)
  string=repstr(string, strmid(string,a,2), strmid(string,a+1,1))
  ;concatenate in a .pro
  string=string+'.pro'
  print, string
  ;copy the file to my hw directory
  spawn, "cp "+"/home/amcdowell/public_html/"+string+" /home/jiashu.han/idldecal/hw4_strings/"
end
