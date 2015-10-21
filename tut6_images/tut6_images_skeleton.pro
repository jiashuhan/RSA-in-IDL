pro main

    ;PURPOSE: this is the main procedure that will run all the functions
    ;and procedures in the correct sequence
    ;INPUT: (None)
    ;OUTPUT: (None)

    ;How do I read in a FITS file into IDL?
    ;reading in the image and the header

    myfave = colorzoom(img)
    ;will zoom in on one kitten's face
    
    artsy_img = better_half(myfave)
    ;will brighten half of that kitten's face

    name = whatsmyname(img, hdr)
    ;will find the kitten's name in the header

    save_kitty, artsy_img, name
    ;will save your edited image along with the kitten's name
end


function colorzoom, pic

    ;PURPOSE: This function will zoom in on the user's choice of kitten
    ;INPUT: A picture of kittens
    ;OUTPUT: A zoomed in image of the user's favorite kitten    

    ;Showing the user the picture


    ;getting the user to select a kitten


    ;setting the range of points that will define the "zoomed" image. 
    ;A box of about 300 by 300 is a good size.


    ;using if statements to ensure that my new image doesn't run over the edges


    ;indexing the picture to select a "zoomed" region


    return, new_pic
end


function better_half, pic

  ;PURPOSE: This function will take your zoomed in image and make the
  ;right half a third again as bright
  ;INPUT: the zoomed image
  ;OUTPUT: the color-altered image
  
  ;defining a new image variable

  ;making the right half a third brighter

  return, new_pic
end


function mindist, header, xpos, ypos

  ;PURPOSE: this function identifies the name of the kitten based on a
  ;set of locations for each kitten and a distance minimization from
  ;where the user clicks
  ;INPUTS: the header, and (x,y) of a point on the kitten's face
  ;OUTPUTS: the string which you must fxpar from the header

  n = 4 ;number of kittens

  locs = strarr(n) 
  ;setting up an array to take in the values of the LOC tags

  
  ;finding the location of each kitten
  ;by loading in the values of
  ;KIT(number)LOC in the header into an array
  ;Hint: for loop and strings


  coords = intarr(2,n)
  ;setting up an array to take the converted values form the loc string

  inds = strpos(locs, ',')
  inds2 = strpos(locs, ']')
  ;identifying locations in the array of strings where delimiting characters are
  ;inds are of array size n_elements(locs)

  for i = 0, n-1 do begin
     coords[0,i] = (byte(strmid(locs[i], 0, inds[i])))[0]
     coords[1,i] = (byte(strmid(locs[i], inds[i]+1, inds2[i]-inds[i]-1)))[0]
  endfor
  ;converting the locations into indices

  
  ;finding the distance between the location and the user click in the image
  ;and minimizing it. how do i find the distance between two points?
  ;how do i take the min of an array in idl?
  

  ;converting the index into the fxpar input. how can i go from the index of
  ;the min distance to a name in the header?

  return, match
end


function whats_my_name, pic, info

  ;PURPOSE: this function will identify the name of the kitten based on
  ;where the kitten is located and information in the header. This
  ;function will rely heavily upon mindist. 
  ;INPUT: the original image and the header
  ;OUTPUT: the name of the kitten


  ;getting the user's input on a favorite kitten
  
  
  ;finding the tag to search for in the image header corresponding to the
  ;selected kitten using min_dist

  
  ;extracting the kitten's name

  return, name
end


pro save_kitty, pic, name

  ;PURPOSE: save a new FITS file with
  ;the modified image along with a new header
  ;INPUT: modified image and the name of your kitten
  ;OUTPUT: A FITS file with a new header
  
  ;making an new FITS file with the input picture and an arbitrary header
  
  
  ;declaring a variable containing the name
  

  ;declaring a variable containing the reason for kitten choice
  
  
  ;sticking in the two strings above into the header
  
  
  ;write the fits file as prettykitty.fits
end
