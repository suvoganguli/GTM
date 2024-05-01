%
% Example script for xsend mfile.
%

% Here we just hold the plane if a fixed postion, 
% and drive surfaces with joystick.
fixed=[37.8227  -75.5039  500 0 0 0];
surfaces=zeros(6,1);

% Initialize UDP socket
xsend('init');
last=0;
fprintf(1,'Sending joystick to surfaces, 10 seconds:.');

for i=[1:200],
  % Send position/surfaces, get joysick
  labels={ 'Iteration','time','pi' };
  values=[ i, i/20, pi ];
  [joystick,buttons]=xsend('xfer',fixed,surfaces,labels,values);

  % Set main surfaces to 1st three axis
  surfaces(1:3)=joystick(1:3);
  
  % Set gear to 1st button
  surfaces(6)=buttons(1);
  pause(.05); % 20 Hz update
  if mod(i,20)==0,fprintf(1,'.');end
  
end
fprintf('.: Done\n');

% Close UDP socket
xsend('close');

