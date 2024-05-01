function [MWS] = AC_baseparams_T2(MWS)
% Common (AirSTARsim and gtm_design) Aircraft parameters for T2
% $Id$


% All geometry data is in the Aircraft Reference System (ARS).  The datum
% (origin) of this system is 8.745" forward of the nose, on the centerline,
% and 16.86" below the top of the fuselage (between MS 25" and MS 66.6").
% The X-axis of the ARS is positive forwards, the Y-axis is positive out
% the right wing, and the Z-axis is positive downwards.

% Mass & Geometry Properties
MWS.w0      = 52;         %lbs, initial gross weight

% Inertias for full fuel weight (12lbs), gear up, relative to full fuel CG
% (cg_pos0)
% Per G. Howland email/excel file: T2_Inertia_9-4-09.xls (note Ixz not
% included)
Ixx0 = 1.221;  % slg-ft^2,
Iyy0 = 4.523;  % slg-ft^2,
Izz0 = 5.538;  % slg-ft^2,
Ixz0 = 0.120;  % slg-ft^2,
Iyz0 = 0.0;    % slg-ft^2,
Ixy0 = 0.0;    % slg-ft^2,
MWS.Inertia0 = [Ixx0 Iyy0 Izz0 Ixz0 Iyz0 Ixy0];

% Shift in CG and Inertia when gear are down
MWS.cg_shift_gear = [-0.0025 0 0.0150];  % ft,   shift in CG when gear are down, per G. Howland email 9/10/09
MWS.Inertia_shift_gear = [0.0441  0  0.006994   0 0 0];% slg-ft^2, shift in inertias when gear are down, 
                                                       % per G. Howland email/excel file: T2_Inertia_9-4-09.xls

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
MWS.cg_pos0 = [-(MWS.le_mac + MWS.Cbar*0.24) 0 -0.9761]; % ft, initial CG (24% MAC), gear up
MWS.ref_cg  = [-(MWS.le_mac + MWS.Cbar*0.25) 0 -0.9401];  %ft, reference CG: 25% MAC in ARS coordinates 

% Fuel Location and weight
MWS.fwdfuel    = 6;     % lbs,  initial fuel weight in foward tank
MWS.aftfuel    = 6;     % lbs,  initial fuel weight in aft tank
MWS.fwdfuel_pos    = [-53.43    0.00 -13.86]/12;    % ft,   foward fuel tank position 
MWS.aftfuel_pos    = [-62.30    0.00 -13.86]/12;    % ft,   aft fuel tank position

% Engine Position/Orientation
MWS.engl_pos       = [-51.903 -14.20  -7.71]/12;    % ft,   location of right engine, not part of 9/8/09 measurements
MWS.engr_pos       = [-51.903  14.20  -7.71]/12;    % ft,   location of left engine, not part of 9/8/09 measurements
MWS.engl_ang       = [  0       1.98   2.22];       % deg,  angluar offsets of left engine
MWS.engr_ang       = [  0       1.95  -1.18];       % deg,  angluar offsets of right engine
