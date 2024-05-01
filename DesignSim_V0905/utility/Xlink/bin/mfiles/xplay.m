function Xvis=xplay(dt,position,surfaces,labels,values);
%function Xvis=xplay(dt,position,surfaces,labels,values);
%
% Sends timed data to X-Plane for flight visualization
% 
% 
% Inputs:
%   dt       - Timestep for data (sec)
%   position - Aircraft position and orientation data Dim: Npts x 6
%              [Lat, Lon, Alt, Phi, Theta Psi]
%              Units are degs and ft.
%
%   surfaces - Surface displacements (optional)  Dim: Npts x 6
%              [Aileron, Elevator, Rudder, Flap, Spoiler, GearDown]
%              Units are degs and 0|1
%
% Outputs:
%   Xvis - timer object for visualization callback
%          Use start(Xvis) to start visualization, stop(Xvis) to stop
%          Call Xplay with no arguments to delete all timers    
%
          

% Error Check inputs
    if (nargin==0),  % Reset timers
        tall=timerfind('Tag','Xplay');
        delete(tall);
        disp(sprintf('Xplay Reset\n  Deleted %d Xplay Timer Callbacks',length(tall)));
        return;
    end
% Estabilish defaults  
    if ~exist('surfaces','var') || isempty(surfaces),
      surfaces=zeros(size(position,1),6);
    end
    if ~exist('labels','var') || isempty(labels), labels=cell(6,1); end
    if ~exist('values','var') || isempty(values), values=zeros(length(surfaces),6); end
% Check sizes
    if size(position,2)~=6  
       error('position vector must be of dimension Npts x 6');
    elseif size(surfaces,2)~=6,
       error('surfaces vector must be of dimension Npts x 6');
    elseif  length(dt)~=1 || dt <= 0
      error('dt must be positive scalar');
    elseif (length(labels) ~= size(values,2) ),
      error('number of labels and number of columns in values must be equal');
    elseif (length(labels) > 6),
      error('number of overlay values must be less than 7');
    end

    delete(timerfind('Tag','Xplay'));
    Xvis=timer('Period',dt,'ExecutionMode','fixedRate','Tag','Xplay');
    set(Xvis,'BusyMode','error');
    set(Xvis,'TimerFcn',{@MtoXRun,position,surfaces,labels,values});
    set(Xvis,'StopFcn', {@MtoXStop});
    set(Xvis,'StartFcn',{@MtoXInit});
%    set(Xvis,'ErrorFcn',{@MtoXErr});

    
% Timer Callbacks
function MtoXRun(obj,event,pos,surf,labels,values);
obj.UserData=obj.UserData+1;
if (obj.UserData>=size(pos,1) || obj.UserData>=size(surf,1)),
    obj.UserData=[];
    stop(obj);
  else
    % Initialize arrays to pass into mex-functin
    chararray=uint8(zeros(1,90));
    valuarray=zeros(1,6);
    % loop through fields, assign to arrays
    for i=1:min(length(labels),6);
      valuarray(i)=values(obj.UserData,i);
      if length(labels{i})>14 labels{i}=labels{i}(1:14); end
      chararray((i-1)*15+1:i*15) = ...
	  uint8([labels{i},zeros(1,15-length(labels{i}))]);
    end
    [a,b]=MatlabToXPlane(pos(obj.UserData,:),surf(obj.UserData,:),...
                         chararray,valuarray,1);
end
    
       
function MtoXStop(obj,event);
obj.UserData=[];
[a,b]=MatlabToXPlane([],[],[],[],2);
    
    
function MtoXInit(obj,event);
[a,b]=MatlabToXPlane([],[],[],[],0);
obj.UserData=1;
    

%function MtoXErr(obj,event);
%fprintf(1,'Timer Overrun at iteration %d\n',obj.UserData);

