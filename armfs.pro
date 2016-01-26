; docformat = 'rst'
;+
; A better (and much simpler) ARM file name split subroutine to 
; split an ARM filename or datastream into its components
; 
; :Params:
;   file : in, required, type=String or string array
;     The filename(s) or datastream(s) to parse
;
; :Keywords:
;   DSNAME : out, optional, type=String or string array
;     The Partial Datastream Name (ie sgpmfrsrE13)
;   DATASTREAM : out, optional, type=String or string array
;     The Full Datastream Name (ie. sgpmfrsrE13.b1)
;   SITE : out, optional, type=String or string array
;     The Site Name (indicator), i.e. "sgp" 
;   PLATFORM : out, optional, type=String or string array
;     The Platform (typically similar to ARM Datastream Class), i.e. "1smos"
;   FACILITY : out, optional, type=String or string array
;     The Facility name,  i.e. "C1"
;   LEVEL : out, optional, type=String or string array
;     The Level of the data, i.e. "b1"
;   YYYYMMDD : out, optional, type=String or string array
;     The Year Month Day 8 digit string, i.e. "20090829"
;   HHMMSS : out, optional, type=String or string array
;     The Hour Minute Second 6 digit string, i.e. "123409"
;   EXT : out, optional, type=String or string array
;     The file extension, i.e. "cdf"
;   NULL : in, optional, type = flag
;     Flag to indicate returned values that are not filled should be set to !NULL values.
;     Default is to return a null string.
;
; :Author: Ken Kehoe, ARM Data Quality Office, University of Oklahoma
; :History: Created = ??
; :Version: $Id:$
;-
PRO armfs, file, DSNAME=dsname, SITE=site, PLATFORM=platform, FACILITY=facility, $
	LEVEL=level, YYYYMMDD=yyyymmdd, HHMMSS=hhmmss, EXT=ext, DATASTREAM=datastream, NULL=null

COMPILE_OPT strictarr

IF KEYWORD_SET(null) THEN BEGIN
  site = []
  dsname = []
  platform = []
  facility = []
  datastream = []
  level = []
  yyyymmdd= []
  hhmmss= []
  ext = []
ENDIF ELSE BEGIN
  site=''
  dsname=''
  platform=''
  datastream = ''
  facility=''
  level=''
  yyyymmdd=''
  hhmmss=''
  ext=''
ENDELSE

;-- Check if no files or a null string --;
IF N_ELEMENTS(file) EQ 0 THEN RETURN
IF N_ELEMENTS(file) EQ 1 AND file[0] EQ '' THEN RETURN

;-- Split file names into multi dimension parts --;
names=STRSPLIT(FILE_BASENAME(file),'.',/EXTRACT,LENGTH=length)

;-- Check if came back as LIST. Extract to multi-dimension array or
; transpose to make 1-D array 2-D array --;
IF TYPENAME(names) EQ 'LIST' THEN BEGIN
;  names = names.ToArray() ; Problem with 8.0 
  tmp = [] ; remove after 8.1 installed
  FOREACH name, names DO tmp = [[tmp],[name]] ; remove after 8.1 installed
  names = TRANSPOSE(tmp) ; remove after 8.1 installed
  tmp = !NULL
  length = length[0]
ENDIF ELSE BEGIN
  names = TRANSPOSE(names)
ENDELSE

;-- Reform to a [1,1] array if smaller --;
IF SIZE(names,/N_DIMENSIONS) LT 2 THEN names = REFORM(names,N_ELEMENTS(file),1)

;-- Locate strings that contain letters and don't --;
match = STREGEX(TRANSPOSE(names[0,*]), '[a-z_]', /BOOLEAN,/FOLD_CASE)

;-- Get Level --;
IF ARG_PRESENT(level) THEN BEGIN
  index = WHERE(length EQ 2L, indexCt)
  IF indexCt GT 0 THEN level = names[*,index[0]]
  IF ISA(level,/ARRAY) AND N_ELEMENTS(level) EQ 1 THEN level=level[0]
ENDIF ; level

;-- Get Date --;
IF ARG_PRESENT(yyyymmdd) THEN BEGIN
  index = WHERE(length EQ 8L AND match EQ 0B, indexCt)
  IF indexCt GT 0 THEN yyyymmdd = names[*,index[0]]
  IF ISA(yyyymmdd,/ARRAY) AND N_ELEMENTS(yyyymmdd) EQ 1 THEN yyyymmdd=yyyymmdd[0]
ENDIF ; yyyymmdd

;-- Get time --;
IF ARG_PRESENT(hhmmss) THEN BEGIN
  index = WHERE(length EQ 6L AND match EQ 0B, indexCt)
  IF indexCt GT 0 THEN hhmmss = names[*,index[0]]
  IF ISA(hhmmss,/ARRAY) AND N_ELEMENTS(hhmmss) EQ 1 THEN hhmmss=hhmmss[0]
ENDIF ; hhmmss

;-- Get file extension --;
IF ARG_PRESENT(ext) THEN BEGIN
  index = WHERE(length GE 2L AND length LE 4L AND match EQ 1B, indexCt)
  IF indexCt GT 0 AND index[-1] EQ N_ELEMENTS(length)-1 THEN ext = names[*,index[-1]]
  IF ISA(ext,/ARRAY) AND N_ELEMENTS(ext) EQ 1 THEN ext=ext[0]
ENDIF ; ext

;-- Get datastream name without level --;
IF ARG_PRESENT(dsname) THEN BEGIN
  IF match[0] EQ 1 THEN dsname = names[*,0]
  IF ISA(dsname,/ARRAY) AND N_ELEMENTS(dsname) EQ 1 THEN dsname=dsname[0]
ENDIF ;dsname

;-- Get datastream name --;
num_parts = (SIZE(names,/DIMENSIONS))[1]
IF ARG_PRESENT(datastream) AND num_parts GT 1 AND match[0] EQ 1B AND $
  length[0] GT 7 AND N_ELEMENTS(length) GT 1 && length[1] EQ 2 THEN BEGIN
   datastream = STRJOIN(TRANSPOSE(names[*,0:1]),'.')
   IF ISA(datastream,/ARRAY) AND N_ELEMENTS(datastream) EQ 1 THEN datastream=datastream[0] 
ENDIF ; datastream

;-- Get Site, Platform and Facility --;
IF ARG_PRESENT(site) OR ARG_PRESENT(platform) OR ARG_PRESENT(facility) THEN BEGIN
  parts = STREGEX(names[*,0],'^([a-z]{3})([^A-Z]*)([A-Z0-9]*)$',/EXTRACT,/SUBEXPR)
  IF parts[1] NE '' THEN site = REFORM(parts[1,*])
  IF parts[2] NE '' THEN platform = REFORM(parts[2,*])
  IF parts[3] NE '' THEN facility = REFORM(parts[3,*]) 
  IF ISA(site,/ARRAY) AND N_ELEMENTS(site) EQ 1 THEN BEGIN
    IF N_ELEMENTS(site) GT 0 THEN site=site[0]
    IF N_ELEMENTS(platform) GT 0 THEN platform=platform[0]
    IF N_ELEMENTS(facility) GT 0 THEN facility=facility[0]
  ENDIF  ; ISA()
ENDIF ; arg_present()

END ; Procedure end
