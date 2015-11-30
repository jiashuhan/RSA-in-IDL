pro start
  print, "To encrypt a message, type 'encrypt, <path>'. To decrypt a message, type 'decrypt, <path>, [n,d]'"
end

;how to let user give input????

pro encrypt, path
  if (size(path))[1] NE 7 then begin
     print, 'Path must be a string.'
  endif else begin
     message=load_file(path)
     m_code=conversion(message,['a'])
     c_code=rsa_e(m_code)
     ciphertext=conversion(0,c_code)
     print, ciphertext
;     save, path, ciphertext
;     print, 'Message saved as message.txt in the working directory.'
  endelse
end

pro decrypt, path, key
  if (size(path))[1] NE 7 then begin
     print, 'Path must be a string.'
  endif else begin
     ciphertext=load_file(path)
     c_code=conversion(ciphertext,0)
     m_code=rsa_d(key,c_code)
     message=conversion(0,m_code)
     print, message
;     save, path, message
;     print, 'Message saved as message.txt in the working directory.'
  endelse
end

function load_file, path
;WORKS FINE NOW
  openr, lun, path, /get_lun
  array=''
  line=''
  while not EOF(lun) do begin
     readf, lun, line
     array = [array, line]
  endwhile
  free_lun, lun
  array1=strjoin(array, ' ')
  array2=[]
  for i=0, strlen(array1) do begin
     c=strmid(array1,i,1)
     array2=[array2,c]
  endfor
  return, array2
end

function conversion, text, code 
;WORKS FINE NOW, code must be an integer array
  characters=['a','A','b','B','c','C','d','D','e','E','f','F','g','G','h','H','i','I','j','J','k','K','l','L','m','M','n','N','o','O','p','P','q','Q','r','R','s','S','t','T','u','U','v','V','w','W','x','X','y','Y','z','Z',' ',',','.',';',':','?','!','"',"'",'(',')','[',']','-']
  if (size(code))[2] NE 2 then begin
     code=[]
     for i=0, n_elements(text)-1 do begin
        for j=0, n_elements(characters)-1 do begin
           if text[i] EQ characters[j] then begin
              code=[code,j]
           endif
        endfor
     endfor
     return, code  
  endif else begin
     text=''
     for i=0, n_elements(code)-1 do begin
        for j=0, n_elements(characters)-1 do begin
           if j EQ code[i] then begin
              text=[text,characters[j]]
           endif
        endfor
     endfor
     return, text
  endelse
end

function gen_rsa_key
;WORKS FINE but very slow, it's not easy to deal with negative n in modulo operations
  n=-1
  while n LT 0 do begin
     k1=((double(fix(randomu(seed)*1000000)))^2)^(0.5)
     k2=((double(fix(randomu(seed)*1000000)))^2)^(0.5)
     k3=((double(fix(randomu(seed)*1000000)))^2)^(0.5)
     p=(primes(k1))[k1-1]
     q=(primes(k2))[k2-1]
     e=(primes(k3))[k3-1]
     n=p*q
  endwhile
  d=((p-1)*(q-1)+1)/e
  key=[n,e,d]
  return, key
end

function rsa_e, m_code
;SERIOUS PROBLEM
  key=gen_rsa_key()
  n=key[0]
  e=key[1]
  d=key[2]
  c_code=m_code^e MOD n
  key_string=string(key)
  print, 'n='+key_string[0]+'   e='+key_string[1]+'   d='+key_string[2]
  return, c_code
end

function rsa_d, key, c_code
;SERIOUS PROBLEM
  n=key[0]
  d=key[1]
  m_code=c_code^d MOD n
  return, m_code
end

function hill, code, key
;SERIOUS PROBLEM
  if (size(code))[2] NE 2 then begin
     m_code=code
     lock=gen_hill_key(m_code)
     c_code=(lock # m_code) MOD 66
     key=invert(lock)
     print, key
     return, c_code
  endif else begin
     c_code=code
     m_code=(key # c_code) MOD 66
     return, m_code
  endelse
end
;dont forget the problem with MOD

function caesar, code, key
;WORKS FINE
;if key=0 then encrypt, if key not=0 then decrypt
  if key EQ 0 then begin
     m_code=code
     key=fix(randomu(seed)*100)
     c_code=(m_code+key) MOD 66
     print, key
     return, c_code
  endif else begin
     c_code=code                                                             
     m_code=(c_code-key) MOD 66
     for i=0, n_elements(m_code)-1 do begin
        while m_code[i] LT 0 do begin
           m_code[i]=m_code[i]+66
        endwhile
     endfor
     return, m_code
  endelse
end

pro save_file, path, message
;UNFINISHED
  spawn, "cp "+path+" message.txt"
  openr, lun, 'message.txt', /get_lun

end

;THERE IS A PROBLEM WITH MODULUS - try to use "for i=0,
;                                  n_elements(array)
;while array[i] LT 0 do
;array[i]=array[i]+mod#

;after fixing all problems, make a new procedure to decide which 2
;algorithms to use to encrypt, and the resulting key should be a 2D
;array with 2 rows (1st element of each row is the # for type of algorithm) 
