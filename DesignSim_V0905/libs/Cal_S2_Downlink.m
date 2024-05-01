function RefGainBias = Cal_Downlink();
%function RefGainBias = Cal_Downlink();

%**************** ADC Downlink Calibration ****************
% As-Cal'd Voltage Reference: (Volts, Unity for N/A).
% In-flight Voltage Reference: 0) None, 1) CPTV, 2) BAROV 3)MAG3V
% Gain (units output/input)
% Bias (units of output)
%
% The following are from Mark Sherrill's email of 8-22-08
%  filename: "CalSheet_S2 - BMS_08222008.xls"
RefGainBias.ADC00           = [ +1.000e+00,  0,  +1.000e+00,  +0.000e+00 ];   % From Counts to Counts
RefGainBias.ADC01           = [ +1.000e+00,  0,  +1.000e+00,  +0.000e+00 ];   % From Counts to Counts
RefGainBias.AILL            = [ +4.968e+00,  1,  +1.736e-03,  -7.130e+01 ];   % From Counts to deg
RefGainBias.ADC03           = [ +1.000e+00,  0,  +1.000e+00,  +0.000e+00 ];   % From Counts to Counts
RefGainBias.ADC04           = [ +1.000e+00,  0,  +1.000e+00,  +0.000e+00 ];   % From Counts to Counts
RefGainBias.ADC05           = [ +1.000e+00,  0,  +1.000e+00,  +0.000e+00 ];   % From Counts to Counts
RefGainBias.ADC06           = [ +1.000e+00,  0,  +1.000e+00,  +0.000e+00 ];   % From Counts to Counts
RefGainBias.AILR            = [ +4.968e+00,  1,  +1.790e-03,  -7.513e+01 ];   % From Counts to deg
RefGainBias.ADC08           = [ +1.000e+00,  0,  +1.000e+00,  +0.000e+00 ];   % From Counts to Counts
RefGainBias.ADC09           = [ +1.000e+00,  0,  +1.000e+00,  +0.000e+00 ];   % From Counts to Counts
RefGainBias.RUDU            = [ +4.968e+00,  1,  +1.723e-03,  -7.179e+01 ];   % From Counts to deg
RefGainBias.RUDL            = [ +4.968e+00,  1,  +1.723e-03,  -7.179e+01 ];   % From Counts to deg
RefGainBias.ELLOB           = [ +4.968e+00,  1,  +1.712e-03,  -7.524e+01 ];   % From Counts to deg
RefGainBias.ELLIB           = [ +4.968e+00,  1,  +1.712e-03,  -7.524e+01 ];   % From Counts to deg
RefGainBias.ELROB           = [ +4.968e+00,  1,  +1.686e-03,  -6.739e+01 ];   % From Counts to deg
RefGainBias.ELRIB           = [ +4.968e+00,  1,  +1.686e-03,  -6.739e+01 ];   % From Counts to deg
RefGainBias.RES0            = [ +1.000e+00,  0,  +1.000e+00,  +0.000e+00 ];   % From bitfield to bitfield
RefGainBias.ENGSL           = [ +1.000e+00,  0,  +1.000e+00,  +0.000e+00 ];   % From bitfield to bitfield
RefGainBias.RPML            = [ +1.000e+00,  0,  +1.000e+00,  +0.000e+00 ];   % From RPM to RPM
RefGainBias.EGTL            = [ +1.000e+00,  0,  +1.000e+00,  +0.000e+00 ];   % From degC to degC
RefGainBias.ENGTL           = [ +1.000e+00,  0,  +1.000e+00,  +0.000e+00 ];   % From % to %
RefGainBias.PUMPLV          = [ +1.000e+00,  0,  +1.000e+00,  +0.000e+00 ];   % From Volts to Volts
RefGainBias.PSL             = [ +5.193e+00,  2,  +2.390e-04,  +1.533e+00 ];   % From Counts to psia
RefGainBias.PDL             = [ +5.193e+00,  2,  +2.400e-05,  -6.485e-02 ];   % From Counts to psid
RefGainBias.PSR             = [ +5.193e+00,  2,  +2.375e-04,  +1.517e+00 ];   % From Counts to psia
RefGainBias.PDR             = [ +5.193e+00,  2,  +2.410e-05,  -6.278e-02 ];   % From Counts to psid
RefGainBias.BAROV           = [ +1.000e+00,  0,  +1.245e-04,  +0.000e+00 ];   % From Counts to  Volts
RefGainBias.BUSMON3         = [ +1.000e+00,  0,  +3.118e-04,  +0.000e+00 ];   % From Counts to  Volts
RefGainBias.BUSMON4         = [ +1.000e+00,  0,  +1.126e-04,  +0.000e+00 ];   % From Counts to  Volts
RefGainBias.CPTV            = [ +1.000e+00,  0,  +9.417e-05,  +0.000e+00 ];   % From Counts to  Volts
RefGainBias.TEMPFCU         = [ +1.000e+00,  0,  +7.630e-03,  +0.000e+00 ];   % From Counts to degF
RefGainBias.BUSMON1         = [ +1.000e+00,  0,  +1.966e-04,  +0.000e+00 ];   % From Counts to  Volts
RefGainBias.BUSMON2         = [ +1.000e+00,  0,  +1.971e-04,  +0.000e+00 ];   % From Counts to  Volts
RefGainBias.TEMPAMB         = [ +1.000e+00,  0,  +7.630e-03,  +0.000e+00 ];   % From Counts to degF
RefGainBias.TEMPTRM         = [ +1.000e+00,  0,  +7.630e-03,  +0.000e+00 ];   % From Counts to degF
RefGainBias.RSS             = [ +1.000e+00,  0,  +9.456e-05,  +0.000e+00 ];   % From Counts to  Volts
RefGainBias.ADC30           = [ +1.000e+00,  0,  +1.000e+00,  +0.000e+00 ];   % From Counts to Counts
RefGainBias.ADC31           = [ +1.000e+00,  0,  +1.000e+00,  +0.000e+00 ];   % From Counts to Counts
RefGainBias.SSCS            = [ +1.000e+00,  0,  +1.000e+00,  +0.000e+00 ];   % From bitfield to bitfield
RefGainBias.ENGSR           = [ +1.000e+00,  0,  +1.000e+00,  +0.000e+00 ];   % From bitfield to bitfield
RefGainBias.RPMR            = [ +1.000e+00,  0,  +1.000e+00,  +0.000e+00 ];   % From RPM to RPM
RefGainBias.EGTR            = [ +1.000e+00,  0,  +1.000e+00,  +0.000e+00 ];   % From degC to degC
RefGainBias.ENGTR           = [ +1.000e+00,  0,  +1.000e+00,  +0.000e+00 ];   % From % to %
RefGainBias.PUMPRV          = [ +1.000e+00,  0,  +1.000e+00,  +0.000e+00 ];   % From Volts to Volts
RefGainBias.XACCEL          = [ +4.955e+00,  3,  +3.941e-04,  -1.304e+01 ];   % From Counts to g
RefGainBias.YACCEL          = [ +4.955e+00,  3,  +3.930e-04,  -1.314e+01 ];   % From Counts to g
RefGainBias.ZACCEL          = [ +4.955e+00,  3,  +3.945e-04,  -1.317e+01 ];   % From Counts to g
RefGainBias.XGYRO           = [ +1.000e+00,  0,  +3.048e-02,  -9.909e+02 ];   % From Counts to deg/sec
RefGainBias.YGYRO           = [ +1.000e+00,  0,  -3.043e-02,  +9.913e+02 ];   % From Counts to deg/sec
RefGainBias.ZGRYO           = [ +1.000e+00,  0,  -3.086e-02,  +1.023e+03 ];   % From Counts to deg/sec
RefGainBias.XMAG            = [ +4.955e+00,  3,  +7.630e-05,  -2.449e+00 ];   % From Counts to Gauss
RefGainBias.YMAG            = [ +4.955e+00,  3,  +7.630e-05,  -2.584e+00 ];   % From Counts to Gauss
RefGainBias.ZMAG            = [ +4.955e+00,  3,  +7.630e-05,  -2.433e+00 ];   % From Counts to Gauss
RefGainBias.XGYROT          = [ +1.000e+00,  0,  +1.635e-02,  -4.587e+02 ];   % From Counts to degF
RefGainBias.MAG3V           = [ +1.000e+00,  0,  +1.130e-04,  +0.000e+00 ];   % From Counts to  Volts
RefGainBias.ALPHAVL         = [ +4.968e+00,  1,  +2.896e-03,  -4.395e+01 ];   % From Counts to deg
RefGainBias.BETAVL          = [ +4.968e+00,  1,  +2.834e-03,  -9.305e+01 ];   % From Counts to deg
RefGainBias.ALPHAVR         = [ +4.968e+00,  1,  +2.778e-03,  -4.124e+01 ];   % From Counts to deg
RefGainBias.BETAVR          = [ +4.968e+00,  1,  +2.853e-03,  -9.295e+01 ];   % From Counts to deg
RefGainBias.ADC47           = [ +1.000e+00,  0,  +1.000e+00,  +0.000e+00 ];   % From Counts to Counts
RefGainBias.PortE           = [ +1.000e+00,  0,  +1.000e+00,  +0.000e+00 ];   % From bitfield to bitfield
RefGainBias.PortF           = [ +1.000e+00,  0,  +1.000e+00,  +0.000e+00 ];   % From bitfield to bitfield
