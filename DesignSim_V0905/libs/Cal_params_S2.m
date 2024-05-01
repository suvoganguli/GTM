%###  /* SVN Revision information:  $LastChangedRevision: 1086 $ */
function [MWS] = Cal_params_S2(MWS)
%function [MWS] = Cal_params_S2(MWS)

% ************** engine identification ******************
MWS.EngineID   = 3;                  % 3 or 7

% ************** Downlink Calibration *******************
RefGainBias=Cal_S2_Downlink();
MWS.RefGainBias_Vec=cell2mat(struct2cell(RefGainBias));

% ************** Uplink Calibration *********************
[DnCals, UpCals]=Cal_S2_Uplink(); 
MWS.UpCals_Eng=cell2mat(struct2cell(DnCals))';
MWS.UpCals_Pwm=cell2mat(struct2cell(UpCals))';

% *************** Surface limits ************************
[lo,hi,SurfaceLimits,RateLimits]=Cal_S2_Limits();
MWS.UplinkHiLimit = cell2mat(struct2cell(hi));
MWS.UplinkLoLimit = cell2mat(struct2cell(lo));
MWS.SurfaceLimits = cell2mat(struct2cell(SurfaceLimits)');
MWS.RateLimits    = cell2mat(struct2cell(RateLimits)');

%***************** MOS Pilot Station Calibration **********
[MOSCalsVolts,MOSCalsNorm]=Cal_S2_MOSPilot();
MWS.MOSCals_Volts=cell2mat(struct2cell(MOSCalsVolts)');
MWS.MOSCals_Norm =cell2mat(struct2cell(MOSCalsNorm)');

%**************** PWM JR Calibration ********************
JRCals_Eng.throttle_cmd = DnCals.ENGTL;
JRCals_Eng.ail_cmd      = DnCals.AILR;
JRCals_Eng.ele_cmd      = DnCals.ELLOB;
JRCals_Eng.rud_cmd      = DnCals.RUDUP;
JRCals_Eng.gear_cmd     = DnCals.GEAR;
JRCals_Eng.flap_cmd     = DnCals.FLAPLOB;
JRCals_Eng.handoff_switch=DnCals.GEAR;   %Just map gear table to switch
JRCals_Eng.BRAKEC       = DnCals.BRAKE;
JRCals_Eng.eng_mode     = DnCals.ENGML;
JRCals_Eng.STEERC       = DnCals.STEER;

JRCals_Pwm.throttle_cmd = UpCals.THROTLC;
JRCals_Pwm.ail_cmd      = UpCals.AILRC;
JRCals_Pwm.ele_cmd      = UpCals.ELLOBC;
JRCals_Pwm.rud_cmd      = UpCals.RUDUPC;
JRCals_Pwm.gear_cmd     = UpCals.GEARC;
JRCals_Pwm.flap_cmd     = UpCals.FLAPLOC;
JRCals_Pwm.handoff_switch=UpCals.GEARC;   %Just map gear table to switch
JRCals_Pwm.BRAKEC       = UpCals.BRAKEC;
JRCals_Pwm.eng_mode     = UpCals.ENGML;
JRCals_Pwm.STEERC       = UpCals.STEERC;

MWS.JRCals_Eng=cell2mat(struct2cell(JRCals_Eng))';
MWS.JRCals_Pwm=cell2mat(struct2cell(JRCals_Pwm))';

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

