function MWS = NoiseParams_S2(MWS,noise_on)
% Sensor noise, scale factor, and bias parameters.
% Default to off if only one input supplied.

% $Id: init_design.m 439 2008-02-19 21:00:25Z murch $

if nargin < 2
    noise_on = 0;
end
% Sensor noise
MWS.SensorNoise.On           = noise_on;        % nd,   1 = noise on, 0 = noise off (default)

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Standard Deviations, estimated from S2_flt8 using smoo.m
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
MWS.SensorNoise.alpha.Std        = 0.07;     % deg,  alpha white noise standard deviation
MWS.SensorNoise.beta.Std         = 0.09;     % deg,  beta white noise standard deviation
MWS.SensorNoise.dyn_press.Std    = 0.0019;   % psi,  dynamic pressure white noise standard deviation
MWS.SensorNoise.static_press.Std = 0.0045;   % psi,  static pressure white noise standard deviation
MWS.SensorNoise.KTAS.Std         = 0.43;     % kts,  true airspeed white noise standard deviation
MWS.SensorNoise.baro_alt.Std     = 5.6;      % ft,   barometric altitude white noise standard deviation
% MIDG Parameters
MWS.SensorNoise.MIDG.phi.Std     = 0.05;     % deg,  Euler roll white noise standard deviation
MWS.SensorNoise.MIDG.theta.Std   = 0.05;     % deg,  Euler pitch white noise standard deviation
MWS.SensorNoise.MIDG.psi.Std     = 0.05;     % deg,  Euler yaw white noise standard deviation
MWS.SensorNoise.MIDG.pdeg.Std    = 1.57;     % deg/sec,  roll rate white noise standard deviation
MWS.SensorNoise.MIDG.qdeg.Std    = 1.49;     % deg/sec,  pitch rate white noise standard deviation
MWS.SensorNoise.MIDG.rdeg.Std    = 1.34;     % deg/sec,  yaw rate white noise standard deviation
MWS.SensorNoise.MIDG.nxbody.Std  = 0.011;    % g,  x-axis acclerometer white noise standard deviation
MWS.SensorNoise.MIDG.nybody.Std  = 0.01;     % g,  y-axis acclerometer white noise standard deviation
MWS.SensorNoise.MIDG.nzbody.Std  = 0.028;    % g,  z-axis acclerometer white noise standard deviation
% MAG3 Parameters
MWS.SensorNoise.MAG3.phi.Std     = 0.05;     % deg,  Euler roll white noise standard deviation
MWS.SensorNoise.MAG3.theta.Std   = 0.05;     % deg,  Euler pitch white noise standard deviation
MWS.SensorNoise.MAG3.psi.Std     = 0.05;     % deg,  Euler yaw white noise standard deviation
MWS.SensorNoise.MAG3.pdeg.Std    = 1.57;     % deg/sec,  roll rate white noise standard deviation
MWS.SensorNoise.MAG3.qdeg.Std    = 1.49;     % deg/sec,  pitch rate white noise standard deviation
MWS.SensorNoise.MAG3.rdeg.Std    = 1.34;     % deg/sec,  yaw rate white noise standard deviation
MWS.SensorNoise.MAG3.nxbody.Std  = 0.011;    % g,  x-axis acclerometer white noise standard deviation
MWS.SensorNoise.MAG3.nybody.Std  = 0.01;     % g,  y-axis acclerometer white noise standard deviation
MWS.SensorNoise.MAG3.nzbody.Std  = 0.028;    % g,  z-axis acclerometer white noise standard deviation
MWS.SensorNoise.pots.Std         = 0.05;     % deg,  control surface pots white noise standard deviation
MWS.SensorNoise.tempamb.Std      = 0.05;     % deg F,  ambient temperature white noise standard deviation

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Bias parameters, estimated from S2_flt8 using Data Compatibility Analysis
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
MWS.SensorNoise.alpha.Bias        = 0.34;    % deg,  alpha bias
MWS.SensorNoise.beta.Bias         = 0.23;    % deg,  beta bias
MWS.SensorNoise.dyn_press.Bias    = 0;       % psi,  dynamic pressure bias
MWS.SensorNoise.static_press.Bias = 0;       % psi,  static pressure bias
MWS.SensorNoise.KTAS.Bias         = 0;       % kts,  true airspeed bias
MWS.SensorNoise.baro_alt.Bias     = 0;      % ft,   barometric altitude bias
% MIDG Paremeters
MWS.SensorNoise.MIDG.phi.Bias     = 0;       % deg,  Euler roll bias
MWS.SensorNoise.MIDG.theta.Bias   = 0;       % deg,  Euler pitch bias
MWS.SensorNoise.MIDG.psi.Bias     = 0;       % deg,  Euler yaw bias
MWS.SensorNoise.MIDG.pdeg.Bias    = 0.006;   % deg/sec,  roll rate bias
MWS.SensorNoise.MIDG.qdeg.Bias    = 0.103;   % deg/sec,  pitch rate bias
MWS.SensorNoise.MIDG.rdeg.Bias    = 0.024;   % deg/sec,  yaw rate bias
MWS.SensorNoise.MIDG.nxbody.Bias  = 0.0034;  % g,  x-axis acclerometer bias
MWS.SensorNoise.MIDG.nybody.Bias  = 0.0084;  % g,  y-axis acclerometer bias
MWS.SensorNoise.MIDG.nzbody.Bias  = 0.0047;  % g,  z-axis acclerometer bias
% MAG3 Parameters
MWS.SensorNoise.MAG3.phi.Bias     = 0;       % deg,  Euler roll bias
MWS.SensorNoise.MAG3.theta.Bias   = 0;       % deg,  Euler pitch bias
MWS.SensorNoise.MAG3.psi.Bias     = 0;       % deg,  Euler yaw bias
MWS.SensorNoise.MAG3.pdeg.Bias    = 0.006;   % deg/sec,  roll rate bias
MWS.SensorNoise.MAG3.qdeg.Bias    = 0.103;   % deg/sec,  pitch rate bias
MWS.SensorNoise.MAG3.rdeg.Bias    = 0.024;   % deg/sec,  yaw rate bias
MWS.SensorNoise.MAG3.nxbody.Bias  = 0.0034;  % g,  x-axis acclerometer bias
MWS.SensorNoise.MAG3.nybody.Bias  = 0.0084;  % g,  y-axis acclerometer bias
MWS.SensorNoise.MAG3.nzbody.Bias  = 0.0047;  % g,  z-axis acclerometer bias
MWS.SensorNoise.pots.Bias         = 0;       % deg,  control surface pots bias
MWS.SensorNoise.tempamb.Bias      = 0;       % deg F,  ambient temperature bias

% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Scale Factor parameters, estimated from S2_flt8 using Data Compatibility Analysis
% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
MWS.SensorNoise.alpha.Scf        = 1.23;    % nd,  alpha scale factor
MWS.SensorNoise.beta.Scf         = 1.50;    % nd,  beta scale factor
MWS.SensorNoise.dyn_press.Scf    = 1;       % nd,  dynamic pressure scale factor
MWS.SensorNoise.static_press.Scf = 1;       % nd,  static pressure scale factor
MWS.SensorNoise.KTAS.Scf         = 1;       % kts,  true airspeed scale factor
MWS.SensorNoise.baro_alt.Scf     = 1;       % ft,   barometric altitude scale factor
% MIDG Parameters
MWS.SensorNoise.MIDG.phi.Scf     = 1;       % nd,  Euler roll scale factor
MWS.SensorNoise.MIDG.theta.Scf   = 1;       % nd,  Euler pitch scale factor
MWS.SensorNoise.MIDG.psi.Scf     = 1;       % nd,  Euler yaw scale factor
MWS.SensorNoise.MIDG.pdeg.Scf    = 1;       % nd,  roll rate scale factor
MWS.SensorNoise.MIDG.qdeg.Scf    = 1;       % nd,  pitch rate scale factor
MWS.SensorNoise.MIDG.rdeg.Scf    = 1;       % nd,  yaw rate scale factor
MWS.SensorNoise.MIDG.nxbody.Scf  = 1;       % nd,  x-axis acclerometer scale factor
MWS.SensorNoise.MIDG.nybody.Scf  = 1;       % nd,  y-axis acclerometer scale factor
MWS.SensorNoise.MIDG.nzbody.Scf  = 1;       % nd,  z-axis acclerometer scale factor
% MAG3 Parameters
MWS.SensorNoise.MAG3.phi.Scf     = 1;       % nd,  Euler roll scale factor
MWS.SensorNoise.MAG3.theta.Scf   = 1;       % nd,  Euler pitch scale factor
MWS.SensorNoise.MAG3.psi.Scf     = 1;       % nd,  Euler yaw scale factor
MWS.SensorNoise.MAG3.pdeg.Scf    = 1;       % nd,  roll rate scale factor
MWS.SensorNoise.MAG3.qdeg.Scf    = 1;       % nd,  pitch rate scale factor
MWS.SensorNoise.MAG3.rdeg.Scf    = 1;       % nd,  yaw rate scale factor
MWS.SensorNoise.MAG3.nxbody.Scf  = 1;       % nd,  x-axis acclerometer scale factor
MWS.SensorNoise.MAG3.nybody.Scf  = 1;       % nd,  y-axis acclerometer scale factor
MWS.SensorNoise.MAG3.nzbody.Scf  = 1;       % nd,  z-axis acclerometer scale factor
MWS.SensorNoise.pots.Scf         = 1;       % nd,  control surface pots scale factor
MWS.SensorNoise.tempamb.Scf      = 1;       % nd,  ambient temperature scale factor

% MAG3 Temperature Compensation parameters
% Per Morelli email, 7/15/08, for sensor #6306
% Negated YGYRO gain, Swapped X/Y axes, to change from Memsense axes to
% aircraft body-axes
MAG3TempComp.XGYRO  =  0.09428;   % deg/s per deg C
MAG3TempComp.YGYRO  = -0.21532;   % deg/s per deg C
MAG3TempComp.ZGYRO  =  0.03517;   % deg/s per deg C
MAG3TempComp.XACCEL = -0.000438;  % g per deg C
MAG3TempComp.YACCEL = -0.000438;  % g per deg C
MAG3TempComp.ZACCEL = -0.000438;  % g per deg C

MWS.MAG3TempComp = cell2mat(struct2cell(MAG3TempComp)');