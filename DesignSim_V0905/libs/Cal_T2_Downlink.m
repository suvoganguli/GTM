function RefGainBias = Cal_T2_Downlink()
% function RefGainBias = Cal_T2_Downlink()
%
% $Id: Cal_T2_Downlink.m 2021 2009-09-03 21:41:40Z murch $
%**************** ADC Downlink Calibration ****************
% In-flight Voltage Reference: 0) None, 1) CPTV, 2) BAROV 3)MAG3V
% Gain (units output/input)
% Bias (units of output)
%
% The following was auto-generated from CalSheet_T2.xlsx on 03-Sep-2009 17:39:41

RefGainBias.ALPHAVL         = [ 1,  +1.15842e+002,  -4.73225e+001 ];   % From Counts to deg 
RefGainBias.BETAVL          = [ 1,  -1.15718e+002,  +9.38764e+001 ];   % From Counts to deg 
RefGainBias.AILL            = [ 1,  +6.68372e+001,  -6.65481e+001 ];   % From Counts to deg 
RefGainBias.FLAPLOB         = [ 1,  +4.95362e+001,  -4.00584e+001 ];   % From Counts to deg 
RefGainBias.FLAPLIB         = [ 1,  +4.76130e+001,  -3.06197e+001 ];   % From Counts to deg 
RefGainBias.ALPHAVR         = [ 1,  +1.12150e+002,  -4.51952e+001 ];   % From Counts to deg 
RefGainBias.BETAVR          = [ 1,  -1.19581e+002,  +9.33477e+001 ];   % From Counts to deg 
RefGainBias.AILR            = [ 1,  +4.81700e+001,  -4.27258e+001 ];   % From Counts to deg 
RefGainBias.FLAPROB         = [ 1,  +4.76715e+001,  -3.80434e+001 ];   % From Counts to deg 
RefGainBias.FLAPRIB         = [ 1,  +6.61527e+001,  -5.50839e+001 ];   % From Counts to deg 
RefGainBias.RUDU            = [ 1,  +6.70642e+001,  -5.79562e+001 ];   % From Counts to deg 
RefGainBias.RUDL            = [ 1,  +6.95153e+001,  -5.49579e+001 ];   % From Counts to deg 
RefGainBias.ELLOB           = [ 1,  +4.78393e+001,  -4.25926e+001 ];   % From Counts to deg 
RefGainBias.ELLIB           = [ 1,  +4.91971e+001,  -4.90398e+001 ];   % From Counts to deg 
RefGainBias.ELROB           = [ 1,  +4.87594e+001,  -4.16572e+001 ];   % From Counts to deg 
RefGainBias.ELRIB           = [ 1,  +4.83524e+001,  -4.79038e+001 ];   % From Counts to deg 
RefGainBias.RES0            = [ 0,  +1.00000e+000,  +0.00000e+000 ];   % From bitfield to bitfield 
RefGainBias.ENGSL           = [ 0,  +1.00000e+000,  +0.00000e+000 ];   % From bitfield to bitfield 
RefGainBias.RPML            = [ 0,  +1.00000e+000,  +0.00000e+000 ];   % From RPM to RPM 
RefGainBias.EGTL            = [ 0,  +1.00000e+000,  +0.00000e+000 ];   % From degC to degC 
RefGainBias.ENGTL           = [ 0,  +1.00000e+000,  +0.00000e+000 ];   % From % to % 
RefGainBias.PUMPLV          = [ 0,  +1.00000e+000,  +0.00000e+000 ];   % From Volts to Volts 
RefGainBias.PSL             = [ 2,  +9.87757e+000,  +1.35266e+000 ];   % From Counts to psia 
RefGainBias.PDL             = [ 2,  +9.95746e-001,  -1.02789e-001 ];   % From Counts to psid 
RefGainBias.PSR             = [ 2,  +9.88722e+000,  +1.33527e+000 ];   % From Counts to psia 
RefGainBias.PDR             = [ 2,  +9.94586e-001,  -9.35647e-002 ];   % From Counts to psid 
RefGainBias.BAROV           = [ 0,  +1.25193e-004,  +0.00000e+000 ];   % From Counts to  Volts 
RefGainBias.BUSMON3         = [ 0,  +3.15517e-004,  +0.00000e+000 ];   % From Counts to  Volts 
RefGainBias.BUSMON4         = [ 0,  +1.13166e-004,  +0.00000e+000 ];   % From Counts to  Volts 
RefGainBias.CPTV            = [ 0,  +1.25732e-004,  +0.00000e+000 ];   % From Counts to  Volts 
RefGainBias.TEMPFCU         = [ 0,  +7.62951e-003,  +0.00000e+000 ];   % From Counts to degF 
RefGainBias.BUSMON1         = [ 0,  +2.00301e-004,  +0.00000e+000 ];   % From Counts to  Volts 
RefGainBias.BUSMON2         = [ 0,  +2.00118e-004,  +0.00000e+000 ];   % From Counts to  Volts 
RefGainBias.TEMPAMB         = [ 0,  +7.62951e-003,  +0.00000e+000 ];   % From Counts to degF 
RefGainBias.TEMPTRM         = [ 0,  +7.62951e-003,  +0.00000e+000 ];   % From Counts to degF 
RefGainBias.RSS             = [ 0,  +1.25124e-004,  +0.00000e+000 ];   % From Counts to  Volts 
RefGainBias.ADC30           = [ 0,  +1.00000e+000,  +0.00000e+000 ];   % From Counts to Counts 
RefGainBias.ADC31           = [ 0,  +1.00000e+000,  +0.00000e+000 ];   % From Counts to Counts 
RefGainBias.SSCS            = [ 0,  +1.00000e+000,  +0.00000e+000 ];   % From bitfield to bitfield 
RefGainBias.ENGSR           = [ 0,  +1.00000e+000,  +0.00000e+000 ];   % From bitfield to bitfield 
RefGainBias.RPMR            = [ 0,  +1.00000e+000,  +0.00000e+000 ];   % From RPM to RPM 
RefGainBias.EGTR            = [ 0,  +1.00000e+000,  +0.00000e+000 ];   % From degC to degC 
RefGainBias.ENGTR           = [ 0,  +1.00000e+000,  +0.00000e+000 ];   % From % to % 
RefGainBias.PUMPRV          = [ 0,  +1.00000e+000,  +0.00000e+000 ];   % From Volts to Volts 
RefGainBias.XACCEL          = [ 0,  +1.85491e-004,  -6.25000e+000 ];   % From Counts to g 
RefGainBias.YACCEL          = [ 0,  +1.91577e-004,  -6.25000e+000 ];   % From Counts to g 
RefGainBias.ZACCEL          = [ 0,  +1.89399e-004,  -6.25000e+000 ];   % From Counts to g 
RefGainBias.XGYRO           = [ 0,  +1.60621e-002,  -5.00000e+002 ];   % From Counts to deg/sec 
RefGainBias.YGYRO           = [ 0,  +1.62365e-002,  -5.00000e+002 ];   % From Counts to deg/sec 
RefGainBias.ZGYRO           = [ 0,  +1.59580e-002,  -5.00000e+002 ];   % From Counts to deg/sec 
RefGainBias.XMAG            = [ 0,  +7.62951e-005,  -2.50000e+000 ];   % From Counts to Gauss 
RefGainBias.YMAG            = [ 0,  +7.62951e-005,  -2.50000e+000 ];   % From Counts to Gauss 
RefGainBias.ZMAG            = [ 0,  +7.62951e-005,  -2.50000e+000 ];   % From Counts to Gauss 
RefGainBias.XGYROT          = [ 0,  +1.63490e-002,  -4.58714e+002 ];   % From Counts to degF 
RefGainBias.MAG3V           = [ 0,  +1.13101e-004,  +0.00000e+000 ];   % From Counts to  Volts 
RefGainBias.ADC43           = [ 0,  +1.00000e+000,  +0.00000e+000 ];   % From Counts to Counts 
RefGainBias.ADC44           = [ 0,  +1.00000e+000,  +0.00000e+000 ];   % From Counts to Counts 
RefGainBias.ADC45           = [ 0,  +1.00000e+000,  +0.00000e+000 ];   % From Counts to Counts 
RefGainBias.ADC46           = [ 0,  +1.00000e+000,  +0.00000e+000 ];   % From Counts to Counts 
RefGainBias.ADC47           = [ 0,  +1.00000e+000,  +0.00000e+000 ];   % From Counts to Counts 
RefGainBias.PortE           = [ 0,  +1.00000e+000,  +0.00000e+000 ];   % From bitfield to bitfield 
RefGainBias.PortF           = [ 0,  +1.00000e+000,  +0.00000e+000 ];   % From bitfield to bitfield 
