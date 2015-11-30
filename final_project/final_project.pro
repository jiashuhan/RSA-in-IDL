;RSA Encryption tool
;Jiashu Han
pro start
  print, "To encrypt or decrypt a message, type 'main, <path>, key'. To generate an RSA key, type 'rsakey'. NOTE: This program supports 76 characters (not including '?') and the components of the RSA key have to be greater than 75 (number of characters supported-1)." ;this is to ensure the transformation from characters to codes is bijective
end

;encryption procedure
pro encrypt, path, key
  if (size(path))[1] NE 7 then begin
     print, 'Path must be a string.'
  endif else begin
     message=load_file(path)
     m_code=conversion(message,['a'])
     c_code=rsa(key,m_code)
     print, c_code
     c_code=string(c_code)
     save, c_code
     print, 'saved as message.txt in the working directory.'
  endelse
end

;decryption procedure
pro decrypt, path, key
  if (size(path))[1] NE 7 then begin
     print, 'Path must be a string.'
  endif else begin
     c_code=load_encrypted_file(path)
     m_code=rsa(key,c_code)
     message=conversion(0,m_code)
     print, message
     save, message
     print, 'saved as message.txt in the working directory.'
  endelse
end

;runs gen_rsa_key
pro rsakey
  key_string=string(gen_rsa_key())
  print, 'N='+key_string[0]+'     E='+key_string[1]+'     D='+key_string[2]
end

;loads the message from file
function load_file, path
  openr, lun, path, /get_lun
  array=''
  line=''
  while not EOF(lun) do begin
     readf, lun, line
     array = [array, line]
  endwhile
  free_lun, lun                 ;the above loads the file
  array1=strjoin(array, ' ')    ;combines the lines
  array2=[]
  for i=0, strlen(array1) do begin ;cuts the strings into single characters
     c=strmid(array1,i,1)
     array2=[array2,c]
  endfor
  return, array2
end

;loads the encrypted code from file
function load_encrypted_file, path
  openr, lun, path, /get_lun
  array=''
  line=''
  while not EOF(lun) do begin
     readf, lun, line
     print, line
     a=line
  endwhile
  free_lun, lun                 ;the above loads the file
  b=strsplit(a, /extract)
  c=ulong64(b)
  return, c
end

;converts letters and symbols to numbers; code must be an integer array; cannot use '?', this is problematic
function conversion, text, code 
  codebook=['a','A','b','B','c','C','d','D','e','E','f','F','g','G','h','H','i','I','j','J','k','K','l','L','m','M','n','N','o','O','p','P','q','Q','r','R','s','S','t','T','u','U','v','V','w','W','x','X','y','Y','z','Z',' ',',','.',';',':','!','"',"'",'(',')','[',']','-','0','1','2','3','4','5','6','7','8','9'] ;this codebook can be easily scrambled
  if (size(code))[2] NE 2 then begin ;converts text to code
     code=[]
     for i=0, n_elements(text)-1 do begin
        for j=0, n_elements(codebook)-1 do begin
           if strmatch(text[i],codebook[j]) EQ 1 then begin
              code=[code,j]
           endif
        endfor
     endfor
     return, code  
  endif else begin              ;converts code to text
     text=''
     for i=0, n_elements(code)-1 do begin
        for j=0, n_elements(codebook)-1 do begin
           if j EQ code[i] then begin
              text=[text,codebook[j]]
           endif
        endfor
     endfor
     text=strjoin(text)
     return, text
  endelse
end

;generates a set of keys for the RSA encryption algorithm; it's not easy to deal with negative divisor
function gen_rsa_key
  n=-1
  while n LT 0 do begin
     k1=ulong64(randomu(seed)*100) ;the components of the key have to be greater than 75
     k2=ulong64(randomu(seed)*100)
     k3=ulong64(randomu(seed)*100)
     p=(primes(k1))[k1-1]
     q=(primes(k2))[k2-1]
     e=(primes(k3))[k3-1]
     n=p*q
;     print,[p,q,e,n]
  endwhile
  k=1
  while (k*(p-1)*(q-1)+1) MOD e NE 0 do begin
     k+=1
  endwhile
;  print,k
  d=(k*(p-1)*(q-1)+1)/e
  key=[n,e,d]
  return, key
end

;encrypts or decrypts code using the RSA algorithm with provided keys
function rsa, key, code
  n=ulong64(key[0])
  e_d=ulong64(key[1])
  code=ulong64(code)
  new_code_array=[]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;this is the way you might think we should use:
;     new_code=(code^e_d) MOD n
;THIS DOESN'T WORK.
;code^e_d easily exceeds 18,446,744,073,709,551,615 (about 1.8E19, max for 64-bit computers)
;n_elements(codebook)-1=75. 75^10<1.8E19, 75^11>1.8E19
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;instead, we do:
  for i=0, n_elements(code)-1 do begin
     S=e_d
     k=0                        ;this helps keep track on how many steps it has taken
     B=code[i]
     array_A=[]
     array_B=[B]
     while S GT 10 do begin     ;all the loops and case statements below are to prevent the numbers from getting too big
        R=S MOD 10
        S=(S-R)/10              ;code^e_d=code^R*code^10S
        if B GT 75 then begin
           M1=B^2 MOD n         ;B^2
           M2=M1^2 MOD n        ;B^4
           M3=M2^2 MOD n        ;B^8
           M4=(M1*M2) MOD n     ;B^6
           case R of
              0:A=1
              1:A=B MOD n
              2:A=M1 MOD n
              3:A=(B*M1) MOD n
              4:A=M2 MOD n
              5:A=(B*M2) MOD n
              6:A=(M1*M2) MOD n
              7:A=(B*M4) MOD n
              8:A=M3 MOD n
              9:A=(B*M2) MOD n
           endcase
        endif else begin
           A=B^R MOD n          ;or A=(array_B[k])^R mod n
        endelse
        if B GT 75 then begin   ;B^10 may also exceed 1.8E19
           M1=B^2 MOD n
           M2=M1^2 MOD n
           M3=M2^2 MOD n
           B=(M1*M3) MOD n
        endif else begin
           B=B^10 MOD n         ;or B=(array_B[k])^10 mod n. this is at most 74
        endelse
        array_A=[array_A,A]
        array_B=[array_B,B]
;        print,[r,s,a,b]         ;this is for debugging
        k+=1
     endwhile                    ;pmax/qmax/emax=541,nmax=30537,dmax=291061-->max steps taken=5
;the for loop below is equivalent to C=ulong64(product(array_A))
     C=array_A[0]               ;based on calculation, x^e_d MOD n=(A1*A2*...*Ak*Bk^Sk) MOD n
     for j=0, n_elements(array_A)-2 do begin
        C=(C*(array_A[j+1])) MOD n
     endfor
;     print, c
     if array_B[k] GT 75 then begin
        M1=(array_B[k])^2 MOD n ;array_B[k]^2
        M2=M1^2 MOD n           ;array_B[k]^4
        M3=M2^2 MOD n           ;array_B[k]^8
        M4=(M1*M2) MOD n        ;array_B[k]^6
        case S of
           0:D=1
           1:D=array_B[k] MOD n
           2:D=M1 MOD n
           3:D=(B*M1) MOD n
           4:D=M2 MOD n
           5:D=((array_B[k])*M2) MOD n
           6:D=(M1*M2) MOD n
           7:D=((array_B[k])*M4) MOD n
           8:D=M3 MOD n
           9:D=((array_B[k])*M2) MOD n
        endcase
     endif else begin
        D=(array_B[k])^S
     endelse
;     print, d
     new_code=((C MOD n)*(D MOD n)) MOD n
     new_code_array=[new_code_array,new_code]
  endfor
  return, new_code_array
end

;saves the result into another .txt file
pro save_file, message
  openw, lun, 'message.txt', /get_lun
  printf, lun, message
  close, lun
end

;in case of negative dividend
function neg_mod, dividend, divisor
  if dividend LT 0 then begin
     A=dividend
     while A LT 0 do begin
        A+=divisor
     endwhile
  endif
  return, A
end

;Acccording to my original proposal, I was going to include several
;different encryption algorithms in this project, but it turned out
;that the RSA part was way much more complicated than I had
;imagined. As I have mentioned, the function 'RSA' was expected to take
;only a few lines but it actually took 75 lines (not including the
;comments). I did write the script for the matrix cipher and caesar
;cipher, butI had spent hours debugging the RSA part and had no time
;to check whether these two other algorithms actually worked or not. I
;decided to keep them here.

;encrypts or decrypts message using the matrix cipher
function matrix, code, key
  if (size(code))[2] NE 2 then begin
     m_code=code
     lock=gen_hill_key(m_code)
     c_code=(lock # m_code) MOD 75
     key=invert(lock)
     print, key
     return, c_code
  endif else begin
     c_code=code
     m_code=(key # c_code) MOD 75
     return, m_code
  endelse
end

;encrypts or decrypts message using the most basic caesar cipher
function caesar, code, key
;if key=0 then encrypt, if key not=0 then decrypt
  if key EQ 0 then begin
     m_code=code
     key=fix(randomu(seed)*100)
     c_code=(m_code+key) MOD 75
     print, key
     return, c_code
  endif else begin
     c_code=code                                                             
     m_code=(c_code-key) MOD 75
     for i=0, n_elements(m_code)-1 do begin
        while m_code[i] LT 0 do begin
           m_code[i]=m_code[i]+75
        endwhile
     endfor
     return, m_code
  endelse
end
