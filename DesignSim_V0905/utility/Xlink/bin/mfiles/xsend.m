function [joystick,buttons]=xsend(phase,position,surfaces,labels,values);
%function [joystick,buttons]=xsend(phase,position,surfaces,labels,values);
%
% Sends data to and receives data from X-Plane's Xlink plugin
% 
% Inputs:
%   phase    - One of {'init','xfer','close'};
%    
%   position - Aircraft position and orientation data
%              [Lat, Lon, Alt, Phi, Theta Psi]
%              Units are degs and ft.
%
%   surfaces - Surface displacements (optional)
%              [Aileron, Elevator, Rudder, Flap, Spoiler, GearDown]
%              Units are degs and 0|1
%
%   labels   - Cell array of up to six strings for SimData Overlay
%
%   values   - Vector of data for SimData Overlay
%         
%
% Outputs:
%   joystick - Values of first 16 joystick axis.
%
%   buttons  - Values of Xlink custom buttons  
%

    if isempty(strmatch(lower(phase),{'init','xfer','close'},'exact')),
        error('phase must be on of ''init'',''xfer'',''close'' ');
    end
    
    if strmatch(lower(phase),'xfer')
        % Set default values
        if ~exist('surfaces','var') || isempty(surfaces), surfaces=zeros(6,1);end
	if ~exist('labels','var') || isempty(labels), labels=cell(6,1); end
	if ~exist('values','var') || isempty(values), values=zeros(6,1); end
        % Error check dimensions/types
	if length(position)~=6  
	  error('position vector must be of dimension 6');
	elseif length(surfaces)~=6,
	  error('surfaces vector must be of dimension 6');
	elseif (length(labels) ~= length(values)),
	  error('number of labels and values must be equal');
	elseif (length(labels) > 6),
	  error('number of overlay values must be less than 7');
        end
    end



    % Initiaize, run, or close
    switch lower(phase)
      case 'init'
        [a,b]=MatlabToXPlane([],[],[],[],0);
	
      case 'xfer'
	% Initialize arrays to pass into mex-functin
	chararray=uint8(zeros(1,90));
	valuarray=zeros(1,6);
	% loop through fields, assign to arrays
	for i=1:min(length(labels),6);
	  valuarray(i)=values(i);
	  if length(labels{i})>14 labels{i}=labels{i}(1:14); end
	  chararray((i-1)*15+1:i*15) = ...
	      uint8([labels{i},zeros(1,15-length(labels{i}))]);
	end
	% Send/Receive data
	[joystick,buttons]=MatlabToXPlane(position,surfaces,chararray,valuarray,1);
       
      case 'close'
        [a,b]=MatlabToXPlane([],[],[],[],2);
    end
    
