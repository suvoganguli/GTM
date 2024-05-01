% Example for xplay mfile.
%

% load flight data with position and surface info
load flt26_data.mat

% Set display sample rate to 20Hz, decimate data down
dt=1/20;
p=position(1:10:end,:);
s=surfaces(1:10:end,:);
o=overlay(1:10:end,:);
labels={ 'FlightNumber','Time','Elevator','Alpha','Nz','pdeg' };

% Create xplay timer-object
%Xvis=xplay(dt,p,s,labels,o);
Xvis=xplay(dt,p,s,labels,o);

% Start Display as background task
start(Xvis);
% Prompt status
fprintf(1,'Driving X-Plane from workspace data, 15 secs:.');
for i=[1:15],pause(1);fprintf(1,'.');end
fprintf(1,': Done\n');
% Stop X-Plane display as background task
stop(Xvis);


%Notes:
%Doing 
%  start(xplay(dt,p,s));
%works as well, but there is no handle in the workspace to the background task.
%In this case to stop the display do
%  xplay();
%with no input arguments.  This will kill all xplay background jobs.
%
% Surfaces are optional, will be zero if called as xplay(dt,p);
%
% Driving X-Plane faster than it's refresh rate (with e.g. 200 Hz data) 
% should be harmless, but I haven't experimented much.  
% Matlab claims 1-msec resolution in it's timer.
%





