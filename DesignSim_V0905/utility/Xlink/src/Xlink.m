function Xvis=Xlink(dt,position,surfaces);
%function Xvis=Xlink(dt,position,surfaces);
%
% Sends data to X-Plane for flight visualization
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
%          Call Xlink with no arguments to delete all timers    
%
          

% Error Check inputs
    if (nargin==0),  % Reset timers
        tall=timerfind('Tag','Xlink');
        delete(tall);
        disp(sprintf('Xlink Reset\n  Deleted %d Xlink Timer Callbacks',length(tall)));
        return;
    end

    if ~exist('surfaces','var') || isempty(surfaces),
        surfaces=zeros(size(position,1),6);
    end
    
    if size(position,2)~=6  
       error('position vector must be of dimension Npts x 6');
    elseif size(surfaces,2)~=6,
       error('surfaces vector must be of dimension Npts x 6');
    elseif  length(dt)~=1 || dt <= 0
        error('dt must be positive scalar');
    end

    delete(timerfind('Tag','Xlink'));
    Xvis=timer('Period',dt,'ExecutionMode','fixedRate','Tag','Xlink');
    %    set(Xvis,'BusyMode','error');
    set(Xvis,'TimerFcn',{@MtoXRun,position,surfaces});
    set(Xvis,'StopFcn', {@MtoXStop});



    
% Timer Callbacks
function MtoXRun(obj,event,pos,surf);
    if isempty(obj.UserData),
        MatlabToXPlane([],[],0);
        obj.UserData=1;
    else
        obj.UserData=obj.UserData+1;
        if (obj.UserData>=size(pos,1) || obj.UserData>=size(surf,1)),
            obj.UserData=[];
            stop(obj);
        else
            MatlabToXPlane(pos(obj.UserData,:),surf(obj.UserData,:),1);
        end
    end
    
       
function MtoXStop(obj,event);
    obj.UserData=[];
    MatlabToXPlane([],[],2);
    
    
    