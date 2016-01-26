; docformat = 'rst'

;+
; Procedure to match array indexes of time arrays
; 
; :Params:
;   time1 : in, required, type = 1D array of IDL JULDAY times
;     The primary time array. The program will loop over this time array
;     to find matches with time2 within time limit.
;   time2 : in, required, type = 1D array of IDL JULDAY times
;     The secondary time array. The program will search this array for times
;     within threshold of each time1 array element
;   return_index1 : out, required, type = 1D array
;     Array of indexes into time1 that will correspond with times of time2.
;     The returned index array may be of smaller size if a time match was not 
;     possible. If no matches are made, a null array will be returned. 
;   return_index2 : out, required, type = 1D array
;     Array of indexes into time2 that correspond to times within time limit 
;     for matching time1 array of times. If no matches are made, 
;     a null array will be returned.
;   max_diff : in, optional, type = scalar
;     Scalar number of seconds for minimum difference to return a match. Default is 60 seconds
;   no_sort : in, optional, type = flag
;     Flag indicating to not use faster sorting method. The sorting method may change
;     time2 order if not sorted to be increasing.
;
; :Keywords:
;   MAX_DIFF : in, optional, type=scalar
;     The number of seconds to use as a maximum time difference for matching
;     time1 to time2 array. Default value is 60 seconds.
;  
; :Example: 
;   IDL> time1 = TIMEGEN(START=JULDAY(3,20,2008,0,0,0), FINAL=JULDAY(4,11,2008,0,0,0))
;   IDL> time2 = TIMEGEN(START=JULDAY(4,1,2008,0,0,0), FINAL=JULDAY(12,31,2008,0,0,0))
;   IDL> match_times, time1, time2, return_index1, return_index2
;   IDL> FOR ii=0, N_ELEMENTS(return_index1)-1 DO PRINT, SYSTIME(0,(time1[return_index1[ii]] - JULDAY(1,1,1970,0,0,0))*60D*60D*24D),'   ', SYSTIME(0,(time2[return_index2[ii]] - JULDAY(1,1,1970,0,0,0))*60D*60D*24D)
;
; :Author: Ken Kehoe, ARM Data Quality Office, University of Oklahoma
; :Created: February 7, 2012
; :Updated: February 23, 2014 to use bifurcation search to increase speed with large arrays
; :Version: $Id:$
;-
PRO match_times, time1, time2, return_index1, return_index2, MAX_DIFF=max_diff, NO_SORT=no_sort

IF N_ELEMENTS(no_sort) EQ 0 THEN no_sort=0

;-- Check if no times to analyze --;
return_index1 = []
return_index2 = []
IF N_ELEMENTS(time1) EQ 0 || N_ELEMENTS(time2) EQ 0 || $ 
  TOTAL(FINITE(time1)) EQ 0 || TOTAL(FINITE(time2)) EQ 0 THEN RETURN

;-- Convert maximum time difference to IDL JULDAY time --;
IF N_ELEMENTS(max_diff) EQ 0 THEN max_diff=60
CALDAT, 0, month,day,year,hour,min
max_time_diff = JULDAY(month,day,year,hour,min,max_diff)


;-- Check number of elements to search. If the number is large use modified bifurcation search, 
;   else use regular method. Significant performance increase with large arrays. --;

; Initialize value to 'missing valule' for length of time1 array. If a matching value is 
; found in time2, a value will be changed to time2 index. A value not equal to 'missing value'
; will indicate wich indexes in time1 are found.
return_index2 = MAKE_ARRAY(N_ELEMENTS(time1),VALUE=-1,/LONG)

;-- Check if second array length is greater than optimal number of elements for using 
;   bisection search method.
IF no_sort EQ 0 AND N_ELEMENTS(time2) GT 3000L THEN BEGIN

  ; Determine length and number of sub-arrays to create
  time2=time2[SORT(time2)] ; Sort time to allow for bisection search
  slice_len = CEIL(SQRT(N_ELEMENTS(time2))) ; Calculate legth of each sub-array
  n_slice = CEIL(FLOAT(N_ELEMENTS(time2))/FLOAT(slice_len)) ; Calculate number of sub-arrays
  search_list = LIST() ; List of sub-arrays of for time2
  st_arr = [] ; Start of each array time
  en_arr = [] ; End of each array time

  ; Create a list of arrays for search and store start/end points for determining
  ;  which array to search.
  FOR ii=0L, n_slice-1L DO BEGIN
    ss = (ii*slice_len) ; Calculate start index
    ee = (ii*slice_len+slice_len-1L) ; Calclate end index
    IF ee GE N_ELEMENTS(time2) then ee = -1L ; If end index greather than lenght of array 
                                             ; use subtraction indexing
    search_list.add, time2[ss:ee] ; Add sub-array to list
    st_arr=[st_arr,time2[ss]] ; Add start time to start time array
    en_arr=[en_arr,time2[ee]] ; Add end time to end time array
  ENDFOR ; ii

  ; Loop over each time element of time1 array
  FOR ii=0L,N_ELEMENTS(time1)-1L DO BEGIN
    ; Search start/end time arrays to determine which index for the LIST
    ind = (WHERE(time1[ii] GE st_arr AND time1[ii] LE en_arr, indexCt))[0]
    ; If value is not equal to value in array or at ends check other arrays in list
    ; First check for all arrays Less than value and take first array
    IF indexCt EQ 0 THEN ind = (WHERE(time1[ii]-max_time_diff LT en_arr, indexCt))[0]
    ; If still not found check for all arrays greater than and take last array
    IF indexCt EQ 0 THEN ind = (WHERE(time1[ii]+max_time_diff GT st_arr, indexCt))[-1]
    IF indexCt EQ 0 THEN CONTINUE ; Not found continue
    ; Search single array in LIST by indexing list 
    IF ABS(MIN(time1[ii]-search_list[ind], index,/NAN,/ABSOLUTE)) LE max_time_diff THEN $
      return_index2[ii] = index+(ind*slice_len) 
  ENDFOR ;ii

ENDIF ELSE BEGIN
  ;  If number of elements in time2 less than optimal limit use classic method.
  ;-- Loop over each element of time1 to find matching time in time2 --;
  FOR ii=0L, N_ELEMENTS(time1)-1L DO $
    IF ABS(MIN(time1[ii] - time2, index,/NAN,/ABSOLUTE)) LE max_time_diff THEN $
      return_index2[ii] = index

ENDELSE ; time2

; Find indexes where not set to initial value. A value not equal to 'missing value' 
; indecates a value for time1 was found at that index.
return_index1=WHERE(return_index2 GE 0,/NULL) 
; Subset return_index2 to locations where not equal to 'missing value'
return_index2=return_index2[return_index1]

END ; Procedure
