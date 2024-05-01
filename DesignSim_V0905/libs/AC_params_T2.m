function [MWS] = AC_params_T2(MWS)
% Aircraft parameters for T2

% $Id: AC_params_T2.m 1199 2009-02-20 20:46:02Z murch $

% Fuel parameters
MWS.fuel_init  = 12;    % lbs,  initial fuel weight
MWS.fwdfuel    = 6;     % lbs,  initial fuel weight in foward tank
MWS.aftfuel    = 6;     % lbs,  initial fuel weight in aft tank
MWS.joker_fuel = 2;     % lbs,  joker fuel (weight remaining)
MWS.bingo_fuel = 1;     % lbs,  bingo fuel (weight remaining)
MWS.time_init  = 15;    % min,  initial fuel time
MWS.joker_time = 3;     % min,  joker fuel (time remaining)
MWS.bingo_time = 1.5;   % min,  bingo fuel (time remaining)

% Filtering parameters
MWS.tau_press = 0;      % nd,   filter time constant for pressures
MWS.tau_rates = 0;      % nd,   filter time constant for angular rates
MWS.tau_vanes = 0;      % nd,   filter time constant for alpha/beta vanes
MWS.tau_accel = 0;      % nd,   filter time constant for accelerometers
MWS.tau_display = 0.3;  % nd,   filter time constant for display variables

% Mass & Geometry Properties
% All geometry data is in the Aircraft Reference System (ARS).  The datum
% (origin) of this system is 8.745" forward of the nose, on the centerline,
% and 16.86" below the top of the fuselage (between MS 25" and MS 66.6").
% The X-axis of the ARS is positive forwards, the Y-axis is positive out
% the right wing, and the Z-axis is positive downwards.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MWS.w0      = 49.6;         %lbs, initial gross weight

% Inertias for full fuel weight (12lbs), gear up, relative to full fuel CG
% (cg_pos0)
Ixx0 = 1.327;  % slg-ft^2,
Iyy0 = 4.254;  % slg-ft^2,
Izz0 = 5.454;  % slg-ft^2,
Ixz0 = 0.120;  % slg-ft^2,
Iyz0 = 0.0;    % slg-ft^2,
Ixy0 = 0.0;    % slg-ft^2,
MWS.Inertia0 = [Ixx0 Iyy0 Izz0 Ixz0 Iyz0 Ixy0];

% Shift in CG and Inertia when gear are down
MWS.cg_shift_gear = [0 0 0.02083];  % ft,   shift in CG when gear are down
MWS.Inertia_shift_gear = [0.0433  0.0571  0.1461   -0.0663 0 0];% slg-ft^2, shift in inertias when gear are down

% Polynomial coefficients for inertia variation of a single tank as a
% function of fuel burn, relative to the tank centroid
% Based on Pro-E estimates
MWS.Ixx_model = [ 0.000015212259037  -0.000108396795757   0.001076938008733];
MWS.Iyy_model = [ 0.000032526556068  -0.000298176766717   0.002102173236731];
MWS.Izz_model = [-0.000019873124706   0.000212146005908   0.001301531989172];

% A/C Geometry Parameters
MWS.S       = 5.9018;   % ft^2,  reference wing area
MWS.Cbar    = 0.9153;   % ft,    mean aerodynamic chord
MWS.b       = 6.8488;   % ft,    wing span
MWS.le_mac  = 4.5462;   % ft,    leading edge of MAC
MWS.cg_pos0 = [-(MWS.le_mac + MWS.Cbar*0.25) 0 -0.9401]; % ft, initial CG (25% MAC), gear up
MWS.ref_cg  = [-(MWS.le_mac + MWS.Cbar*0.25) 0 -0.9401];  %ft, reference CG: 25% MAC in ARS coordinates 

% T2 Sensor Geometry: Estimated, 1/26/09
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MWS.alphavl_offset =  0.90;    %deg, boom angle offset of left alpha vane, boom angled down = '+' correction
MWS.alphavr_offset =  0.60;    %deg, boom angle offset of right alpha vane, boom angled down = '+' correction
MWS.betavl_offset  = -0.20;    %deg, boom angle offset of left beta vane, boom angled right/inwards = '+' correction
MWS.betavr_offset  =  0.10;    %deg, boom angle offset of right beta vane, boom angled right/outwards = '+' correction

MWS.alphavl_pos    = [-57.81  -42.27 -14.15]/12;    % ft,   location of left alpha vane
MWS.alphavr_pos    = [-57.81   42.27 -14.15]/12;    % ft,   location of right alpha vane
MWS.betavl_pos     = [-60.31  -40.82 -12.70]/12;    % ft,   location of left beta vane
MWS.betavr_pos     = [-60.31   40.82 -12.70]/12;    % ft,   location of right beta vane
MWS.MIDG_pos       = [-54.17    0.00 -10.94]/12;    % ft,   location of MIDG
MWS.MAG3_pos       = [-57.30    0.00 -11.17]/12;    % ft,   location of MAG3 sensor
MWS.fwdfuel_pos    = [-53.425   0.00 -13.57]/12;    % ft,   foward fuel tank position 
MWS.aftfuel_pos    = [-61.675   0.00 -13.57]/12;    % ft,   aft fuel tank position
MWS.engl_pos       = [-51.903 -14.20  -7.71]/12;    % ft,   location of right engine
MWS.engr_pos       = [-51.903  14.20  -7.71]/12;    % ft,   location of left engine
MWS.engl_ang       = [  0       2.146   1.683];     % deg,  angluar offsets of right engine
MWS.engr_ang       = [  0       2.146  -1.683];     % deg,  angluar offsets of left engine

% Alpha/Beta upwash/sidewash
MWS.alphavr_upwash  = [0 1;0 1];    %deg,   2-D table of upwash values (row 2) corresponding to alpha (row 1)
MWS.betavr_sidewash = [0 1;0 1];    %deg,   2-D table of sidewash values (row 2) corresponding to beta (row 1)
MWS.alphavl_upwash  = [0 1;0 1];    %deg,   2-D table of upwash values (row 2) corresponding to alpha (row 1)
MWS.betavl_sidewash = [0 1;0 1];    %deg,   2-D table of sidewash values (row 2) corresponding to beta (row 1)

% Navigation Parameters
MWS.mag_var    = 11.4;     % deg,  variation between true and magnetic north for WFF (37.824525,-75.497123), from http://www.ngdc.noaa.gov/geomagmodels/Declination.jsp
MWS.wgs84_bias = 37.975 ;  % m,    Bias between WGS84 ellipse and mean sea level (MSL) for WFF (37.824525,-75.497123) (sign swapped), from http://earth-info.nga.mil/GandG/wgs84/gravitymod/wgs84_180/intptW.html

% Stall speed estimation Parameters
MWS.wt_ref = [49.6 49.6 49.6];  %lbs,   reference weights for stall speed estimates as a function of flap position
MWS.vs1g   = [48   35   31];    %kts,   stall speeds as a function of flap position

% Engine Parameters
MWS.rpm_reference = 123000; %RPM,   reference RPM for normalizing
MWS.pumpv_table = [0.0 0.90 1.0 6.4 6.41 10.0]; %volts, table of fuel pump voltages  - not accurate at the moment 1/26/09
MWS.fuel_flow_table = [0.0 0.0 0.1762 1.34044 1.34044 1.34044]; %lbs/min,   fuel flow rates corresponding to pump voltages (pumpv_table) - not accurate at the moment 1/26/09
MWS.thrust_model = [[31.519,38.3721,44.6665,51.361,55.7506,60.6258,62.9154,65.8268,69.2567,73.098,76.9685,80.0465,83.2392,86.3014,92.2054,100.1233;];... % percent of reference RPM - updated with preliminary Jetcat P70 data
    [1.0883,1.624,2.2312,3.0479,3.7033,4.5635,5.021,5.6564,6.4877,7.5331,8.7182,9.7617,10.9447,12.1805,14.8619,19.1287;];...%lbs,   2-D table of thrust values (row 2) corresponding to power settings
    [0.00 6.00 12.00 19.00 24.00 30.00 33.00 37.00 42.00 48.00 54.50 60.00 66.00 72.00 84.00 100.00]];% percent handle corresponding to percent of reference RPM (row 1)

