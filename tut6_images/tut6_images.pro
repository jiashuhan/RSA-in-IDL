function min_dist, header, xpos, ypos
  img=mrdfits('idl_image.fits', 0, hdr)
  kit1=fxpar(hdr, 'kit1loc')
  kit2=fxpar(hdr, 'kit2loc')
  kit3=fxpar(hdr, 'kit3loc')
  kit4=fxpar(hdr, 'kit4loc')
  n=4
 ; str
  kitloc_arr=strarr(n)
  for i=10, 13 do begin
     kitloc_arr=[kitloc_arr,strpos(hdr[i], i)]
  endfor
  ;INPUTS: the header, and (x,y) of a point on the kitten's face
  ;OUTPUTS: the string which you must fxpar from the header
  coords=intarr(2,n)
  comma=strpos(kitloc_arr, ',')
  bracket=strpos(kitloc_arr, ']')
  for i=0, n-1 do begin
     coords[0,i]=(byte(strmid(kitloc_arr[i], 0, comma[i])))[0]
     coords[1,i]=(byte(strmid(kitloc_arr[i], comma[i]+1, bracket[i]-comma[i]-1)))[0]
  endfor
  return, coords
                                ;finding the distance between the
                                ;location and the user click in the
                                ;image
  ;and minimizing it. how do i find the distance between two points?
  ;how do i take the min of an array in idl?
  

                                ;converting the index into the fxpar
                                ;input. how can i go from the index of
  ;the min distance to a name in the header?

;  return, match

end

;min dist: Write a function that finds the kitten closest to the user’s click. Hint: look in the header for the center of each kitten’s face and write some code that figures out which kitten is the closest to the click.
;whats my name: Write a function to find out the name of the kitten that was clicked on. The names of each kitten are stored in the header, make sure your script automat- ically picks out the name after the user has clicked.
;colorzoom: Write a function that zooms in and changes the color of a kitten of your choice. Remember your 2D array manipulation skills from your work with arrays and colortables from your work with plots.
;better half: Write a function that takes the zoomed-in face and increases the bright- ness of the right side by a factor of 1/3
;save kitty: Write a procedure that will save your colorful, brightened kitten as a new FITS file called pretty_kitty.fits into your tut6_images directory. In the header of this new FITS file include both the name of the kitten you chose and why you chose it over the other three.
;main: Finally write a wrapper procedure that will call your other routines in the correct order. Once you’re done you should just be able to call main and your new FITS file should be generated after the user picks a kitten.
