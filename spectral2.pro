
;==============================================================================
; This program is the NREL Simple Solar Spectral Model for Direct and Diffuse
; Irradiance on Horizontal and Tilted Planes at the Earth's Surface for 
; Cloudless Atmospheres. It was written to emulate the C and FORTRAN
; versions already available.  
;==============================================================================


;*******************************************************************************
;+
; This is the Neckel and Labs Revised Extraterrestrial Spectrum and
; Atmospheric Absorption Coefficients at 122 Wavelengths
; 
; Created by Ken Kehoe
;  ARM Data Quality Office, University of Oklahoma
;  August 14, 2009
;
; When called will return an array of size [0:4,122] consisting of 
;  [Wavelength , *]
;  [Extraterrestrial Spectrum , *]
;  [Water Vapor Extension Absorbtion Coefficient , *]
;  [Ozone Absorbtion Coefficient , *]
;  [Mixed Gas Absorbtion Coefficient , *]
;
; :Returns: Array[5,122] consisting of
;   [Wavelength , *]
;   [Extraterrestrial Spectrum , *]
;   [Water Vapor Extension Absorbtion Coefficient , *]
;   [Ozone Absorbtion Coefficient , *]
;   [Mixed Gas Absorbtion Coefficient , *]
;
; :Hidden:
;-
FUNCTION SolarSpectralTable

;-- Wavelength in micro-meters --;
Wavelength =[0.3,0.305,0.31,0.315,0.32,0.325,0.33,0.335,0.34,0.345, $
0.35,0.36,0.37,0.38,0.39,0.4,0.41,0.42,0.43,0.44,0.45,0.46,0.47,0.48, $
0.49,0.5,0.51,0.52,0.53,0.54,0.55,0.57,0.593,0.61,0.63,0.656,0.6676, $
0.69,0.71,0.718,0.7244,0.74,0.7525,0.7575,0.7625,0.7675,0.78,0.8,0.816, $
0.8237,0.8315,0.84,0.86,0.88,0.905,0.915,0.925,0.93,0.937,0.948,0.965, $
0.98,0.9935,1.04,1.07,1.1,1.12,1.13,1.145,1.161,1.17,1.2,1.24,1.27,1.29, $
1.32,1.35,1.395,1.4425,1.4625,1.477,1.497,1.52,1.539,1.558,1.578,1.592, $
1.61,1.63,1.646,1.678,1.74,1.8,1.86,1.92,1.96,1.985,2.005,2.035,2.065, $
2.1,2.148,2.198,2.27,2.36,2.45,2.5,2.6,2.7,2.8,2.9,3,3.1,3.2,3.3,3.4, $
3.5,3.6,3.7,3.8,3.9,4]

;-- Extraterrestrial Spectrum in (W m^-2 um^-1) --;
Extraterrestrial_Spectrum =[535.9,558.3,622,692.7,715.1,832.9,961.9,931.9, $
900.6,911.3,975.5,975.9,1119.9,1103.8,1033.8,1479.1,1701.3,1740.4,1587.2, $
1837,2005,2043,1987,2027,1896,1909,1927,1831,1891,1898,1892,1840,1768,1728, $
1658,1524,1531,1420,1399,1374,1373,1298,1269,1245,1223,1205,1183,1148,1091, $
1062,1038,1022,998.7,947.2,893.2,868.2,829.7,830.3,814,786.9,768.3,767,757.6, $
688.1,640.7,606.2,585.9,570.2,564.1,544.2,533.4,501.6,477.5,422.7,440,416.8, $
391.4,358.9,327.5,317.5,307.3,300.4,292.8,275.5,272.1,259.3,246.9,244,243.5, $
234.8,220.5,190.8,171.1,144.5,135.7,123,123.8,113,108.5,97.5,92.4,82.4,74.6, $
68.3,63.8,49.5,48.5,38.6,36.6,32,28.1,24.8,22.1,19.6,17.5,15.7,14.1,12.7,11.5, $
10.4,9.5,8.6]

;-- Water Vapor Extension Absorbtion Coefficient --;
Water_Vapor_Extension_Absorbtion_Coefficient =[0,0,0,0,0,0,0,0,0,0,0,0,0,0, $
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.075,0,0,0,0,0.016,0.0125,1.8,2.5,0.061, $
0.0008,0.0001,0.00001,0.00001,0.0006,0.036,1.6,2.5,0.5,0.155,0.00001,0.0026, $
7,5,5,27,55,45,4,1.48,0.1,0.00001,0.001,3.2,115,70,75,10,5,2,0.002,0.002,0.1, $
4,200,1000,185,80,80,12,0.16,0.002,0.0005,0.0001,0.00001,0.0001,0.001,0.01, $
0.036,1.1,130,1000,500,100,4,2.9,1,0.4,0.22,0.25,0.33,0.5,4,80,310,15000,22000, $
8000,650,240,230,100,120,19.5,3.6,3.1,2.5,1.4,0.17,0.0045]

;-- Ozone Absorbtion Coefficient  --;
Ozone_Absorbtion_Coefficient = [10,4.8,2.7,1.35,0.8,0.38,0.16,0.075,0.04, $
0.019,0.007,0,0,0,0,0,0,0,0,0,0.003,0.006,0.009,0.014,0.021,0.03,0.04,0.048, $
0.063,0.075,0.085,0.12,0.119,0.12,0.09,0.065,0.051,0.028,0.018,0.015,0.012, $
0.01,0.008,0.007,0.006,0.005,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, $
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, $
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]

;-- Mixed Gas Absorbtion Coefficient  --;
Mixed_Gas_Absorbtion_Coefficient = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0, $
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.15,0,0,0,0,0,0,4,0.35,0,0,0,0,0,0,0,0,0, $
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0.05,0.3,0.02,0.0002,0.00011,0.00001,0.05, $
0.011,0.005,0.0006,0,0.005,0.13,0.04,0.06,0.13,0.001,0.0014,0.0001,0.00001, $
0.00001,0.0001,0.001,4.3,0.2,21,0.13,1,0.08,0.001,0.00038,0.001,0.0005,0.00015, $
0.00014,0.00066,100,150,0.13,0.0095,0.001,0.8,1.9,1.3,0.075,0.01,0.00195, $
0.004,0.29,0.025]

SolarSpectralTable = MAKE_ARRAY(5,N_ELEMENTS(Wavelength),/FLOAT)
SolarSpectralTable[0,*] = Wavelength
SolarSpectralTable[1,*] = Extraterrestrial_Spectrum
SolarSpectralTable[2,*] = Water_Vapor_Extension_Absorbtion_Coefficient
SolarSpectralTable[3,*] = Ozone_Absorbtion_Coefficient
SolarSpectralTable[4,*] = Mixed_Gas_Absorbtion_Coefficient

RETURN, SolarSpectralTable
END ; Function End

;*******************************************************************************
;+
; Function to Calculate the Earth Sun Distancei Factor from Spencer 1971 
;
; :Params:
;   date : in, required, type=value
;     input date in 8 digit format
;
; :Returns: Earth Sun Distance factor (0 - 1)
;
; :Hidden:
;-
FUNCTION ESDistFactor, date
 year = DOUBLE(STRMID(STRTRIM(date,2),0,4))
 month = DOUBLE(STRMID(STRTRIM(date,2),4,2))
 day = DOUBLE(STRMID(STRTRIM(date,2),6,2))
 dayOfYear = JULDAY(month,day,year,0,0,0) - JULDAY(1,1,year,0,0,0) 
 numDaysPerYear = JULDAY(1,1,year+1,0,0,0) - JULDAY(1,1,year,0,0,0)
 phi =  2.0D * !PI * (dayOfYear - 1.0D)/numDaysPerYear ; Equation (2-3)
 ; Equation (2-2)
 ESDisFac = 1.00011D + 0.034221D*COS(phi) + 0.00128D*SIN(phi) $
		+ 0.000719D*COS(2.0D*phi) + 0.000077D*SIN(2.0D*phi) 
 RETURN, ESDisFac
END ; ESDistFactor Function End


;*******************************************************************************
;+
; Function to Calculate Rayleigh Scattering Atmospheric Transmittance 
; taken from Kneizyse 1980 
;
; :Keywords:
;   MPRIME : in, required, type=value
;
; :Returns: Array(122) of Transmittance from Raleight Scattering 
;
; :Hidden:
;-
FUNCTION RayleighScatteringTransmittance,  MPRIME=_Mprime
 SST = DOUBLE(SolarSpectralTable())
 Mprime = DOUBLE(_Mprime)
 lambda = DOUBLE(REFORM(SST[0,*]))
 Tr = EXP( -Mprime / (lambda^4 * (115.6406D - 1.335D/lambda^2) ) )  ;Equ. (2-4)
 RETURN, Tr
END ; RayleighScatteringTransmittance


;*******************************************************************************
;+
; Function to Calculate Aerosol Scattering and Absorption 
; :Keywords:
;   AEROOPTDEPTH : in, required, type=value
;   REF_LAMBDA : in, required, type=value
;   M : in, required
;
; :Returns: Array(122) of Transmittance for Aerosol Scattering and Absorbtion 
;
; :Hidden:
;-
FUNCTION AerosolScatteringTransmittance, AeroOptDepth=_AeroOptDepth, $
	REF_LAMBDA=_ref_lambda, M=_M
 ; *Note* AeroOptDepth is the aerosol optical depth at the reference wavelength; 
 ; *Note* ref_lambda is the reference wavelength in micro-meters
 SST = DOUBLE(SolarSpectralTable())
 lambda = DOUBLE(REFORM(SST[0,*]))
 AeroOptDepth = DOUBLE(_AeroOptDepth)
 ref_lambda = DOUBLE(_ref_lambda)
 M = DOUBLE(_M)
 alpha=MAKE_ARRAY(N_ELEMENTS(lambda),VALUE=1.140D)
 index=WHERE(lambda LT 0.5, indexCt)
 IF(indexCt) THEN alpha[index]=1.0274D
 index=WHERE(lambda GE 0.5, indexCt)
 IF(indexCt) THEN alpha[index]=1.2060D
 Ta = EXP( -AeroOptDepth*(lambda/ref_lambda)^(-alpha) * M )
 RETURN, Ta
END ; AerosolScatteringTransmittance Function End



;*******************************************************************************
;+
; Function to Calculate Water Vapor Absorption
; :Keywords:
;   M : in, required, type=value
;   PWV : in, required, type=value
;
; :Returns: Array(122) of Transmittance for Water Vapor Absorption
; :Hidden:
;-
FUNCTION WaterVaporAbsorptionTransmittance, PWV=_PWV, M=_M
 ; *Note* PWV is in cm along a vertical path 
 SST = DOUBLE(SolarSpectralTable())
 PWV = DOUBLE(_PWV)
 M = DOUBLE(_M)
 a=REFORM(SST[2,*])
 Tw = EXP(-0.2385D*a*PWV*M / (1.0D + 20.07D*a*PWV*M)^0.45D )  ; Equ. (2-8)
 RETURN, Tw
END ; WaterVaporAbsorptionTransmittance Function End


;*******************************************************************************
;+
; Function to Calculate Ozone Absorption 
; :Keywords:
;   O3AMOUNT : in, required, type=value
;   SZA : in, required, type=value
;   M : in, required, type=value
;
; :Returns: Array(122) of Transmittance for Ozone Absorption
;
; :Hidden:
;-
FUNCTION OzoneAbsorptionTransmittance, O3AMOUNT=_O3amount, SZA=_SZA, M=_M
 SST = DOUBLE(SolarSpectralTable())
 a=REFORM(SST[3,*])
 O3amount = DOUBLE(_O3amount)
 SZA = DOUBLE(_SZA)
 ;IF(N_ELEMENTS(_M) GT 0) THEN M = DOUBLE(_M)
 height_o = 22.0D	; Height of maximum ozone concentration in (km)
 Mo = (1.0D + height_o/6370D) / (COS(SZA*!PI/180.0D)^2 + 2.0D*height_o/6370D )^0.5
 IF(N_ELEMENTS(_M)) THEN Mo = DOUBLE(_M)
 To = EXP(-a * O3amount * Mo)
 RETURN, To
END ; OzoneAbsorptionTransmittance Function End



;*******************************************************************************
;+
; Function to Calculate Uniformly Mixed Gas Transmittance 
; :Keywords:
;   MPRIME : in, required, type=value
;
; :Returns: Array(122) of Transmittance for Uniformly Mixed Gas
;
; :Hidden:
;-
FUNCTION UniformMixedGasTransmittance, MPRIME=_Mprime  
 SST = DOUBLE(SolarSpectralTable())
 Mprime = DOUBLE(_Mprime)
 a=REFORM(SST[4,*]) 
 Tu = EXP( -1.41D*a*Mprime / (1.0D + 118.3D*a*Mprime)^0.45 )  ; Equ (2-11)
 RETURN, Tu
END ; UniformMixedGasTransmittance


;*******************************************************************************
;+
; Function to Calculate Scattering Constants 
;
; :Returns: Array(122) of Scattering Constants
;
; :Hidden:
;-
FUNCTION Cscatter
 SST = DOUBLE(SolarSpectralTable())
 lambda=REFORM(SST[0,*])
 Cs = MAKE_ARRAY(N_ELEMENTS(lambda),VALUE=1.0D)
 index = WHERE(lambda LE 0.45D, indexCt)
 IF(indexCt) THEN Cs[index] = (lambda[index] + 0.55D)^1.8
 RETURN, Cs
END ; Cscatter 



;*******************************************************************************
;********************************** Main Program *******************************
;*******************************************************************************

;+
; This program is the NREL "Simple Solar Spectral Model for Direct and Diffuse
; Irradiance on Horizontal and Tilted Planes at the Earth's Surface for 
; Cloudless Atmospheres." Additional information can be found at 
; http://rredc.nrel.gov/solar/pubs/spectral/model/
; 
; :Params:
;   Itotal : out, required, type="Array(122)"
;     The total irradiance at the surface (W/m^2/um)
;   Idirect : out, required, type="Array(122)"
;     The direct irradiance at the surface (W/m^2/um)
;   Idiff : out, required, type="Array(122)"
;     The diffuse irradiance at the surface (W/m^2/um)
;
; :Keywords:
;  I_INCPLANE : out, optional, type="Array(122)"
;    The total irradiance at the surface on an inclined plane as defined by the
;    AZIMUTH and TILTANG Keywords.  TILTANG must be set.
;  WAVELENGTH ; out, optional, type="Array(122)"
;    The wavelengths matching to the returned irradiance used 
;    in calculating the spectral values
;    Units = mirometers
;  LAT : in, optional, type=value, default="SGP Central Facility, Lamont, OK"
;    Latitude of desired location.
;    Units = degrees, +0 to +90 for northern hemisphere  (i.e. SGP =  36.605)
;  LON : in, optional, type=value, default="SGP Central Facility, Lamont, OK"
;    Longitude of desired location.
;    Units = degrees, +0 to +180 East of Prime Meridian (i.e. SGP = -97.485)
;  DATE : in, optional, type=value, default="August 14, 2009"
;    Date to retrieve irradiance values in Universal Time
;    Format of date MUST be in 8 digit.  (i.e. 20090814 for August 14, 2009)
;  TIME : in, optional, type=value, default="12:00 UT"
;    Time to retrieve irradiance values in Universal Time
;    Format of time MUST be in decimal hours. (i.e. 12.5 for 12:30 UT)
;  PRESSURE : in, optional, type=value, default="1013 mb"
;    Surface pressure.  
;    Units=milibars
;  AEROOPTDEPTH : in, optional, type=value, default="0.25"
;    Aerosal Optical Depth
;  AODREF_WL : in, optional, type=value, default="0.5 micrometers"
;    The wavelength for the used AeroOptDepth  
;  PWV : in, optional, type=value, default="1.42 cm"
;    Precipital Water Vapor 
;    Units = cm
;  O3AMOUNT : in, optional, type=value, default="0.3 atm-cm"
;    Ozone amount
;    Units = atm-cm
;  GROUND_ALB : in, optional, type=value, default="0.2"
;    Ground albedo ranging from 0-1
;  OMEGA_4 : in, optional, type=value, default="0.945"
;    Aerosal Single Scatter Albedo at 0.4 micro-meters
;  OMEGA_PRIME : in, optional, type=value, default="0.095"
;    Aerosal Wavelength variation factor
;  A_ASY_FAC : in, optional, type=value, default="0.65"
;    Aerosal Asymetry Factor
;  TILTANG : in, optional, type=value, default="0 deg"
;    Tilt angle of plane from 0 = horizontal to 90 = vertical
;    Units = degrees
;  AZIMUTH : in, optional, type=value, default="180 deg"
;    Azimuth angle of the plane with 0 = north and 90 = east
;    Units = degrees
;
; :Uses: 
;   zensun.pro
;
; :Author: Ken Kehoe, ARM Data Quality Office, University of Oklahoma
; :History: Created on August 14, 2009
; :Version: $Id: spectral2.pro 7661 2011-08-05 16:20:10Z kehoe $
;-  
PRO spectral2, Itotal, Idirect, Idiff, I_INCPLANE=I_incPlane, WAVELENGTH=Wavelength, $
	LAT=lat, LON=lon, DATE=date, TIME=time, PRESSURE=pressure, AODREF_WL=AODref_wl, $
	AeroOptDepth=AeroOptDepth, PWV=PWV, O3AMOUNT=O3amount, GROUND_ALB=ground_alb, $
	OMEGA_4=omega_4, OMEGA_PRIME=omega_prime, TILTANG=tiltAng, $
	AZIMUTH=Azimuth, A_ASY_FAC=A_asy_fac 

COMPILE_OPT strictarr
;!EXCEPT=0 ;Turn off math errors

;-- Check Inputs else set to defaults --;
; If input values are out of range, set to default ;
IF(setdefault(lat,MIN=-90.)) THEN lat = 36.605	; Latitude (degrees) :ARM SGP C1 Site
IF(setdefault(lon,MIN=-180.)) THEN lon = -97.485 ; Longitude (degrees) :ARM SGP C1 Site
IF(setdefault(date)) THEN date = '20090814'	; Default Date (yyyyddmm)
IF(setdefault(time)) THEN time = 12.0		; Default Time in UT hours
IF(setdefault(pressure)) THEN pressure = 1013.0	; Default Pressure
IF(setdefault(AeroOptDepth)) THEN  AeroOptDepth = 0.25 	; Guess taken from Husar 1981
						; at 0.5 micro-meters 
IF(setdefault(AODref_wl)) THEN AODref_wl = 0.5	; AaroOptDetph Reference Wavelength (um)
IF(setdefault(PWV)) THEN  PWV = 1.42		; Precipitable Water Vapor (cm)
IF(setdefault(O3amount)) THEN O3amount=0.3	; Ozone (atm-cm)
IF(setdefault(ground_alb)) THEN ground_alb=0.2	; Ground Albedo (0-1)
IF(setdefault(omega_4)) THEN omega_4=0.945	; Aerosol Single Scatter Albedo
							;  at 0.4 micro-meters
IF(setdefault(omega_prime)) THEN omega_prime=0.095	; Aerosol Wavelength 
							;  variation factor
IF(setdefault(A_asy_fact)) THEN A_asy_fact=0.65	; Aerosol Asymetry Factor
IF(setdefault(tiltAng)) THEN tiltAng=0.0	; Tilt angle of collector in degrees. 
						; 0 = horizontal 90 = vertical
IF(setdefault(Azimuth)) THEN Azimuth=180.0	; Angle in degrees of the tilted plane 
						; from North (90 degrees = east)

;-- Read in Irradiance Values --;
SST = SolarSpectralTable()
lambda = REFORM(SST[0,*])
Ho = REFORM(SST[1,*])


; Set up Default Values
ESDistFac = 1.0		; Earth Sun Distance Factor
Tr = MAKE_ARRAY(N_ELEMENTS(lambda),/FLOAT,VALUE=1.0)	; Transmittance for Rayleigh Scattering
Ta = MAKE_ARRAY(N_ELEMENTS(lambda),/FLOAT,VALUE=1.0)	; Transmittance for Aerosol Attenuation
Tw = MAKE_ARRAY(N_ELEMENTS(lambda),/FLOAT,VALUE=1.0)	; Transmittance for Wator Vapor Absorbtion
To = MAKE_ARRAY(N_ELEMENTS(lambda),/FLOAT,VALUE=1.0)	; Transmittance for Ozone Absorbtion
Tu = MAKE_ARRAY(N_ELEMENTS(lambda),/FLOAT,VALUE=1.0)	; Transmittance for Uniformly Mixed Gas Absorbtion


;-- Start Main Program --;
year = FLOAT(STRMID(STRTRIM(date,2),0,4))
month = FLOAT(STRMID(STRTRIM(date,2),4,2))
day = FLOAT(STRMID(STRTRIM(date,2),6,2))
dayOfYear = FLOAT(JULDAY(month,day,year,0,0,0) - JULDAY(1,1,year,0,0,0))

; Calculate Solar Zenith Angle
zensun, dayOfYear, time, lat, lon, SZA, SolarAzimuth, solfac
cos_SZA=COS(SZA*!PI/180.0D)

; Relative Air Mass
M = 1.0D / (cos_SZA + 0.15D*(93.885D - DOUBLE(SZA))^(-1.253))  ; Equation (2-5)

; Pressure-corrected Air Mass with pressure in (mb)
Pnot = 1013.0	; mb
Mprime = M * pressure/Pnot	; Pressure-corrected air mass

; Calculate Earth Sun Distance Factor
ESDistFac = ESDistFactor(date)

; Calculate Rayleigh Scattering Transmittance
Tr = RayleighScatteringTransmittance( MPRIME=Mprime )

; Calculate Aerosol Scattering and Absrobtion Transmittance
Ta = AerosolScatteringTransmittance( AeroOptDepth=AeroOptDepth, REF_LAMBDA=AODref_wl, M=Mprime )

; Calculate Water Vapor Transmittance
Tw = WaterVaporAbsorptionTransmittance( PWV=PWV, M=M )

; Calculate Ozone Transmittance
To = OzoneAbsorptionTransmittance(O3AMOUNT=O3amount,SZA=SZA)

; Calculate Uniform Mixed Gass Transmittance
Tu = UniformMixedGasTransmittance( MPRIME=Mprime )

; Calculate the Direct Radiation component ;
Idirect = Ho * ESDistFac * Tr * Ta * Tw * To * Tu  ; Equation (2-1)

;-- Calculate the Diffuse Irradiance on a Horizontal Surface --;

Cs = Cscatter()

ALG = ALOG(1.0 - A_asy_fact)
BFS = ALG * ( 0.0783 + ALG*(-0.3824 - ALG*0.5874) )
AFS = ALG * (1.459 + ALG*(0.1595 + ALG*0.4129) )
 

Tprime_o = OzoneAbsorptionTransmittance( O3AMOUNT=O3amount,SZA=SZA,M=1.8 )
Tprime_w = WaterVaporAbsorptionTransmittance( PWV=PWV, M=1.8 )
Tprime_r = RayleighScatteringTransmittance( MPRIME=(1.8*pressure/Pnot) )

Fs = 1.0 - 0.5*EXP( (AFS + BFS*cos_SZA) * cos_SZA  )
Fprime_s = 1.0 - 0.5*EXP( (AFS + BFS/1.8)/1.8 )
omega = omega_4 * EXP(-omega_prime * (ALOG(lambda/0.4))^2)
Ta_s = EXP( -omega * AeroOptDepth * M )
Ta_a = EXP( -(1.0 - omega)*AeroOptDepth*M)
Tprime_a_s = EXP( -omega * AeroOptDepth * 1.8) 
Tprime_a_a = EXP( -(1.0 - omega) * AeroOptDepth * 1.8)


sky_alb = Tprime_o * Tprime_w * Tprime_a_a * $
	(0.5*(1.0 - Tprime_r) + (1.0 - Fprime_s) * Tprime_r * (1.0 - Tprime_a_s))

Idiff_ray = Ho * ESDistFac * cos_SZA $ 
	* To * Tu * Tw * Ta_a * (1.0 - Tr^0.95) * 0.5

Idiff_aero = Ho * ESDistFac * cos_SZA $
	* To * Tu * Tw * Ta_a * Tr^1.5 * (1.0 - Ta_s) * Fs * Cs

Idiff_ground = (Idiff_ray*cos_SZA + Idiff_ray + Idiff_aero) $
	* sky_alb * ground_alb * Cs/(1.0 - sky_alb*ground_alb)

Idiff = Idiff_ray + Idiff_aero + Idiff_ground

;-- Add the Direct and diffuse values --;
Itotal = Idirect*cos_SZA + Idiff


;-- Calculate the Global Irradiance on an inclined surface --;
theta = Azimuth - SolarAzimuth 
theta_rd = theta*!PI/180.0
tiltAng_rd = tiltAng*!PI/180.0

IF(N_ELEMENTS(I_incPlane) GT 0 AND tiltAng GT 0) THEN BEGIN
 Ith = Idirect*cos_SZA + Idiff
 I_incPlane = Idirect*COS(theta_rd) $
	+ Idiff*( (Idirect*COS(theta_rd) / (Ho*ESDistFac*cos_SZA)) $
	+ 0.5*(1.0 + COS(tiltAng_rd))*(1.0 - Idirect/(Ho*ESDistFac)) )  $
	+ 0.5*Ith*ground_alb*(1.0 - COS(tiltAng_rd))
ENDIF ELSE I_incPlane = Itotal

wavelength=lambda
END ; Main Program End
