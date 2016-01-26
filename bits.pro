; docformat = 'rst'
;+
; Function to decode bit packed numbers or remove/add bits from/to a bit packed number.
;
;  :Post:
;    Only works with IDL 8.0 or greater.
;
; :Params:
;   number : in, required, type = scaler integer
;     The bit packed number or array of bit packed numbers to return bits or remove bits. 
;
; :Keywords:
;   REMOVE : in, optional, type=integer array or scalar
;     An array of bits to be removed from the bit packed number.
;   ADD : in, optional, type=integer array or scalar
;     An array of bits to be added to the bit packed number.
;
;  :Returns:
;    DEFALUT MODE: Returns array of set bit numbers for all data.  
;     If no bits are set, returns 0.
;
;    ADD or REMOVE Key Word Set: Returns bit packed data array in same type as entered when 
;     used with REMOVE mode. If asked to add a bit number greater than 64
;     will return !NULL.  If the bit requested is larger than the current
;     data type would allow, the type will be up-converted to Unsigned Long or 
;     Unsigned Long 64 as needed. 
;
;  :Example:
;    IDL> data = make_array(5,value=0) & print, data
;           0       0       0       0       0
;    IDL> data =  bits(data,add=[1,3]) & print, data
;           5       5       5       5       5
;
;    IDL> print, bits(data)
;       1   3
;
;    IDL> data = bits(data, remove=[1,2],add=6)
;    IDL> print, bits(data)
;       3   6
;    IDL> print, data
;          36      36      36      36      36
;
;    IDL> data[3:4] = bits(data[3:4],add=5) & print, data
;          36      36      36      52      52
;
;    IDL> print, bits(data)
;       3   5   6
;
;    IDL> FOREACH elem, data DO PRINT, bits(elem)
;       3   6
;       3   6
;       3   6
;       3   5   6
;       3   5   6
;
; :Author: Ken Kehoe, ARM Data Quality Office, University of Oklahoma
; :History: Created = 08/11/2010
; :Version: $Id: bits.pro 17742 2013-05-29 17:33:48Z kehoe $
;-
FUNCTION bits, _number, REMOVE=remove, ADD=add

IF N_ELEMENTS(_number) EQ 0 THEN RETURN, _number

number=_number
type = SIZE(number,/TYPE)

; Check if set to FLOAT or DOULBE. Needs to be non-decimal type ;
IF type GT 3 AND type LT 12 THEN type=3 ; Set to LONG
number = FIX(number, TYPE=type)

;-- If asked to add or remove --;
IF(KEYWORD_SET(REMOVE) OR KEYWORD_SET(ADD)) THEN BEGIN
	; Check data type and convert if needed
    type_check=[type]
    IF KEYWORD_SET(ADD) THEN BEGIN
		IF MAX(add) GE 16 AND type LT 13  THEN type_check = [type_check,13] ; Unsigned Long 
		IF MAX(add) GT 32 AND type LT 15 THEN type_check = [type_check,15] ; Unsigned Long 64 Int.
		IF MAX(add) GT 64 THEN RETURN, !NULL
    ENDIF ; KEYWORD_SET
    IF KEYWORD_SET(REMOVE) THEN BEGIN
		IF MAX(remove) GE 16 AND type LT 13  THEN type_check = [type_check,13] ; Unsigned Long 
		IF MAX(remove) GT 32 AND type LT 15 THEN type_check = [type_check,15] ; Unsigned Long 64 Int.
		IF MAX(remove) GT 64 THEN RETURN, !NULL
    ENDIF ; KEYWORD_SET
    type=MAX(type_check)
	num = FIX(number,TYPE=type)

	; Add specified bit numbers
	IF KEYWORD_SET(ADD) THEN $
		num = num OR FIX(TOTAL(ISHFT(1ULL,add-1)),TYPE=type)

	; Remove specified bit numbers
	IF KEYWORD_SET(REMOVE) THEN $
		num = num AND (NOT FIX(TOTAL(ISHFT(1ULL,remove-1)),TYPE=type))

	RETURN, num

ENDIF ELSE BEGIN
	
	; Get a single bit-packed number of all the bits tripped in all the data values.
	mask = FIX(0,TYPE=type) ; mask needs to be same type as data
	FOREACH elem, number DO mask = mask OR elem

	; Extract all the bits and create an array of bit numbers tripped.
	bits_arr = []
	FOR ii=0, BIT_POPULATION(mask)-1 DO BEGIN
		bit = BIT_FFS(mask)
		bits_arr = [bits_arr,bit]
		mask = mask AND (NOT FIX(ISHFT(1ULL,(bit-1)),TYPE=type))
	ENDFOR ; ii
	IF N_ELEMENTS(bits_arr) EQ 0 THEN bits_arr = [0B]

	RETURN, bits_arr

ENDELSE ;KEWORD REMOVE/ADD 


END ; Function End
