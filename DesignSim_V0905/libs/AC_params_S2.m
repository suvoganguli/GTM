function [MWS] = AC_params_S2(MWS)
% Aircraft parameters for S2

% $Id: AC_params_S2.m 1132 2009-01-27 13:59:36Z murch $

% Post-compile parameters
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MWS.fuel_init  = 7;     % lbs,  inital weight of fuel
MWS.fwdfuel    = 0;     % lbs,  initial fuel weight in foward tank
MWS.aftfuel    = 7;     % lbs,  initial fuel weight in aft tank
MWS.joker_fuel = 2;     % lbs,  weight based joker fuel
MWS.joker_time = 3;     % min,  time remaining, joker fuel
MWS.time_init  = 14;    % min,  inital value for fuel timer
MWS.bingo_fuel = 1;     % lbs,  weight based bingo fuel
MWS.bingo_time = 1.5;   % min,  time remaining,  bingo fuel

% Filtering parameters
MWS.tau_press = 0;      % nd,   filter time constant for pressures
MWS.tau_rates = 0;      % nd,   filter time constant for angular rates
MWS.tau_vanes = 0;      % nd,   filter time constant for alpha/beta vanes
MWS.tau_accel = 0;      % nd,   filter time constant for accelerometers
MWS.tau_display = 0.3;  % nd,   filter time constant for display variables
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Mass/Inertia Properties
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MWS.w0     = 47.77;     %lbs, max gross weight
MWS.cg_pos0 = [-42.628 0 -0.59]/12; % ft, inital CG, gear up

% Inertias for full fuel weight (7lbs), gear up,
Ixx0 = 1.0770;  % slg-ft^2,  post-flight estimate = 1.0571
Iyy0 = 4.1628;  % slg-ft^2,  post-flight estimate = 4.1962
Izz0 = 4.9695;  % slg-ft^2,  post-flight estimate = 5.0606
Ixz0 = 0.4160;  % slg-ft^2,  60.7 deg: post-flight estimate = 0.4655
Iyz0 = 0.0;  % slg-ft^2,
Ixy0 = 0.0;  % slg-ft^2,
MWS.Inertia0 = [Ixx0 Iyy0 Izz0 Ixz0 Iyz0 Ixy0];


% A/C Geometry Parameters
MWS.S      = 1014.6/144;   % wing area (ft^2)
MWS.Cbar   = 10.9/12;      % wing mean aerodynamic chord (ft)
MWS.b      = 85.0/12;      % wing span (ft)
MWS.le_mac = 40.448/12;    % ft, nose of a/c to leading edge of MAC

% Reference CG
MWS.ref_cg  = [-42.628 0 0]/12;  %ft, reference CG, using 20% MAC = MS 42.628 (25% MAC = MS 43.173)

% Shift in CG and Inertia when gear are down
MWS.cg_shift_gear = [0 0 0.02083];  % ft,   shift in CG when gear are down
MWS.Inertia_shift_gear = [0.0433  0.0571  0.1461   -0.0663 0 0];% slg-ft^2, shift in inertias when gear are down

% Polynomial coefficients for inertia variation as a function of fuel burn
MWS.Ixx_model = [ 1.0480 -18.921 0]/(32.17405*144);
MWS.Iyy_model = [ 0.8537 -43.807 0]/(32.17405*144);
MWS.Izz_model = [-0.1878 -40.056 0]/(32.17405*144);

MWS.engr_pos     = [-77.00   0.00 -2.83]/12;        % ft,   Guess at where the engine is mounted.
MWS.engl_pos     = [-77.00   0.00 -2.83]/12;        % ft,   Guess at where the engine is mounted.

% S2 Geometry: updated to 063008A drawing, 7/2/08
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
MWS.alphavl_offset =  0.90;    %deg, boom angle offset of left alpha vane, boom angled down = '+' correction
MWS.alphavr_offset =  0.60;    %deg, boom angle offset of right alpha vane, boom angled down = '+' correction
MWS.betavl_offset  = -0.20;    %deg, boom angle offset of left beta vane, boom angled right/inwards = '+' correction
MWS.betavr_offset  =  0.10;    %deg, boom angle offset of right beta vane, boom angled right/outwards = '+' correction

% Reference point for dimensions is MS = BL = WL = 0.
% Sign convention follows standard aircraft body-axes:
%                              x positive out the nose
%                              y positive out the right wing
%                              z positive out the bottom of fuselage
% Note: x & z signs are switched to convert from ARS to aircraft body-axis
MWS.alphavl_pos  = [-46.89 -42.03 -1.22]/12;    % ft,   location of left alpha vane
MWS.alphavr_pos  = [-46.85  42.29 -1.17]/12;    % ft,   location of right alpha vane
MWS.betavl_pos   = [-49.42 -40.58  0.24]/12;    % ft,   location of left beta vane
MWS.betavr_pos   = [-49.34  40.91  0.17]/12;    % ft,   location of right beta vane
MWS.MIDG_pos     = [-20.06   0.00 -5.54]/12;    % ft,   location of MIDG
MWS.MAG3_pos     = [-44.63   0.00 -0.15]/12;    % ft,   location of MAG3 sensor (Howland email, 7/23/08)
MWS.fwdfuel_pos  = [-38.00   0.00  0.46]/12;    % ft,   fuel tank position - don't have usage data for each tank, so treat as one tank
MWS.aftfuel_pos  = [-38.00   0.00  0.46]/12;    % ft,   fuel tank position - don't have usage data for each tank, so treat as one tank

% Alpha/Beta upwash/sidewash
MWS.alphavr_upwash  = [0 1;0 1];    %deg,   2-D table of upwash values (row 2) corresponding to alpha (row 1)
MWS.betavr_sidewash = [0 1;0 1];    %deg,   2-D table of sidewash values (row 2) corresponding to beta (row 1)
MWS.alphavl_upwash  = [0 1;0 1];    %deg,   2-D table of upwash values (row 2) corresponding to alpha (row 1)
MWS.betavl_sidewash = [0 1;0 1];    %deg,   2-D table of sidewash values (row 2) corresponding to beta (row 1)

% Navigation parameters
MWS.mag_var    = 11.4;     % deg,  variation between true and magnetic north for WFF (37.824525,-75.497123), from http://www.ngdc.noaa.gov/geomagmodels/Declination.jsp
MWS.wgs84_bias = 37.975 ;  % m,    Bias between WGS84 ellipse and mean sea level (MSL) for WFF (37.824525,-75.497123) (sign swapped), from http://earth-info.nga.mil/GandG/wgs84/gravitymod/wgs84_180/intptW.html

% Stall speed estimation parameters
MWS.wt_ref = [49.6 49.6 49.6]; % lbs,  reference weights for stall speed estimates %%% May be INCORRECT %%%
MWS.vs1g   = [48 35 31];       % kts, stall speeds as a function of flap position

% Engine and Fuel Parameters
% Jetcat 120SE.  Fuel flow and thrust HALVED, so right+left = one engine
MWS.rpm_reference = 123000; %RPM,   reference RPM for normalizing
MWS.pumpv_table = [0 0.576	0.625	0.6985	0.7845	0.8575	0.919	0.9805	1.0415	1.1025...
    1.1515	1.262	1.287	1.373	1.52	1.618	1.74	1.887	1.973...
    2.12	2.255	2.4385	2.647	2.7575	2.9905	3.162]; %volts, table of fuel pump voltages
MWS.fuel_flow_table = [0,0.0794,0.0876,0.102,0.1149,0.1275,0.1379,0.1487,0.1586,0.1671,...
    0.1775,0.1858,0.194,0.2038,0.2206,0.2405,0.2566,0.2746,0.2921,0.3102,...
    0.3266,0.3445,0.3533,0.3611,0.3866,0.4083;]; %lbs/min,   HALVED fuel flow rates corresponding to pump voltages (pumpv_table)
% 2-D table of thrust values (row 2) corresponding to RPM (row 1), and  RPM command (row 3)
MWS.thrust_model = [28,29.2,33.4,37.2,40.9,43.7,46.5,49.1,51.7,54.4,55.8,58.6,61.2,64.8,69.9,73.3,76.5,79.7,83.1,86.4,89.4,92,94.8,97.4,98.8;... row 1, RPM, % of ref on std day
    0.545,0.605,0.83,1.065,1.315,1.535,1.775,2.02,2.29,2.58,2.75,3.11,3.475,4.03,4.905,5.57,6.26,7.01,7.875,8.755,9.645,10.465,11.405,12.33,12.835;... row 2, HALVED reduced gross thrust corresponding to row 1
    0,2,4.7,7.7,10.7,13.1,16.1,18.8,21.5,24.5,27.5,30.2,33.6,38.9,45.6,51.7,57,62.4,68.5,74.2,80.5,85.9,91.6,97,100]; % row 3, Throttle position corresponding to row 1

