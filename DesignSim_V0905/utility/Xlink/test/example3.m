%
% Example for Xlink simulink block
%

% load flight data with position and surface info
load flt26_data.mat

% Open block diagram
open_system('showflight');

% Run simulation
fprintf(1,'Running showflight simulation for 10 seconds:.');
sim('showflight',[0 10]);
fprintf(1,'Done\n');

