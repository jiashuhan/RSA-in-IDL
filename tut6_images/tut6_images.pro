function min_dist, header, xpos, ypos
  img=mrdfits('idl_image.fits', 0, hdr)
  n=4
  locs=[]
  for i=0, n_elements(hdr)-1 do begin
     a=string(i)
     a1=repstr(a, ' ', '')
     b='kit'+a1+'loc'
     if strmatch(hdr[i], '*]*') EQ 1 then begin
     locs=[locs,fxpar(hdr, b)]
     endif
  endfor
  coords = intarr(2,n)
  ;find locations of delimiting characters
  inds = strpos(locs, ',')
  inds2 = strpos(locs, ']')
  ;use inds to take out values from locs and convert them into floats
  for i = 0, n-1 do begin
     coords[0,i] = float(strmid(locs[i], 1, inds[i]-1))
     coords[1,i] = float(strmid(locs[i], inds[i]+1, inds2[i]-inds[i]-1))
  endfor
  ;find minimum distance
  d_arr=[]
  for i=0, n-1 do begin
     d=((xpos-coords[0,i])^2+(ypos-coords[1,i])^2)^0.5
     d_arr=[d_arr, d]
     if d LT min(d_arr) then begin
        d1=d
        i1=i
     endif
  endfor
  ;record the number of the kitten
  string=string(i1+1)
  string1=repstr(string, ' ', '')
  number='kit'+string1
  return, number
end

function whats_my_name, pic, header 
  ;input the result of min_dist and find the name of the kitten
  cursor, xpos, ypos
  a=min_dist(header, xpos, ypos)
  b=a+'name'
  name=fxpar(hdr, b)
  return, name
end

function colorzoom, pic
  ;zoom in the selected kitten and change its color
  ;show the picture
  display, pic, title='choose a kitten'
  ;select a kitten
  cursor, xpos, ypos
  a=min_dist(hdr, xpos, ypos)
  b=a+'loc'
  ;find location of nearset kitten using min_dist
  loc=fxpar(hdr, b)
  coords = intarr(2)
  inds = strpos(loc, ',')
  inds2 = strpos(loc, ']')
  coords[0] = float(strmid(loc, 1, inds-1))
  coords[1] = float(strmid(loc, inds+1, inds2-inds-1))
  new_pic=rot(pic, 0, 2, coords[0], coords[1])
  ;setting the range of points that will define the "zoomed" image. 
  new_pic=bytscl(new_pic)
  color=colortable(!yellow)
  return, new_pic
end

function better_half, pic
  ;take the image from colorzoom and increase the brightness of the right half by 1/3
  img=colorzoom(pic)
  ;defining a new image variable
  new_pic=img
  xloc=new_pic[*,0]
  yloc=new_pic[*,1]
  ;making the right half a third brighter
  for i=n_elements(xloc)/2, n_elements(xloc)-1 do begin
     for j=0, n_elements(yloc)-1 do begin
        new_pic[i,j]=4/3*new_pic[i,j]
     endfor
  endfor
  return, new_pic
end

pro save_kitty, pic, name
  ;save the new picture in a new FITS file with new header
  ;declaring a variable containing the name
  kitname=name
  ;declaring a variable containing the reason for kitten choice
  reason='chosen by a random click'  
  ;sticking in the two strings above into the header
  sxaddpar, hdr, 'kitname', kitname
  sxaddpar, hdr, 'reason', reason  
  ;write the fits file as prettykitty.fits
  mwrfits, img, 'pretty_kitty.fits', hdr
end

pro main
  ;run all functions in correct sequence
  ;reading in the image and the header
  img=mrdfits('idl_image.fits', 0, hdr)
  ;will zoom in on one kitten's face
  myfave=colorzoom(img, hdr)
  ;will brighten half of that kitten's face
  artsy_img=better_half(myfave)
  ;will find the kitten's name in the header
  name=whats_my_name(img, hdr)
  ;will save your edited image along with the kitten's name 
  save_kitty, artsy_img, name
end
