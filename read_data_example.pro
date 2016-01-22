PRO read_data_example, filename, variablename, data, time, units

cdfid = NCDF_OPEN(filename, /NOWRITE)  ;NOTE, assumes there is only one file per day
	NCDF_VARGET, cdfid, variablename, data ;Note, assumes the field exists
	NCDF_VARGET, cdfid, 'base_time', base_time
	NCDF_VARGET, cdfid, 'time_offset', time_offset
	NCDF_ATTGET, cdfid, variablename, 'units', units  ; Note, units is returned as ASCII numbers not string
	units = STRING(units)	; Convert from ASCII numbers to string
NCDF_CLOSE, cdfid

; Convert base_time and time_offset into something that can be used to plot dates 
time = JULDAY(1,1,1970,0,0,base_time+time_offset) ;This is IDL internal format for time
                                                  ; It is number of julian days from a date BCE.
                                                  ; It starts at 12:00, so has 0.5 offset

END ; procedure
