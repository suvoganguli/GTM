function [sys,londyn,latdyn] = linmodel(MWS,vabflag,SplitSurf,Ts)
%function [sys,londyn,latdyn] = linmodel(MWS,vabflag,SplitSurf,Ts)
%
% Linearize gtm_design simulation at current trim point
%
% Inputs:
%  MWS     -  simulation parameters, defaults to pre-loaded model workspace
%  vabflag  - flag to get linear models in terms of V, alpha, beta (0 default)
%  SplitSurf- flag for returning independent control surface inputs rather
%             than grouped surfaces (0 default)
%  Ts       - Sample time, zero for continuous model (0 default)
% Outputs:
%   sys    - 6dof system with control surface inputs/state outputs
%   londyn - Approximate (4th order) longitudinal dynamics
%   latdyn - Approximate (4th order) lateral dynamics
%

% d.e.cox@larc.nasa.gov
% $Id: linmodel.m 425 2008-02-12 01:53:15Z cox $

% Load new model workspace if supplied
if (exist('MWS','var') && ~isempty(MWS)),
    loadmws(MWS,'gtm_design');
end

if ~exist('vabflag','var') || isempty(vabflag),
    vabflag = 0;
end

if ~exist('SplitSurf','var') || isempty(SplitSurf),
    SplitSurf = 0;
else
  error('Split surface linearization is unavailable in this version');
end

if ~exist('Ts','var') || isempty(Ts),
    Ts = 0;
end

% Set Inline Params to off.
% If not "off", trim results degrade (why??)
dirtyflag =get_param('gtm_design','Dirty');
inlineflag=get_param('gtm_design','InlineParams');
set_param('gtm_design','InlineParams','off');

% Grab state names
[tmp1,tmp2,StateNames]=gtm_design;

% Find Configurable Subsystems
AircraftType = get_param('gtm_design/Aircraft Model','BlockChoice');

% Get index for Equations of Motion states
% suvo
%EOM =find(strcmp(StateName,['gtm_design/Aircraft Model/' AircraftType '/EOM/Integrator'])==1);
EOM =find(strcmp(StateNames,['gtm_design/Aircraft Model/EOM/Integrator'])==1);

% Bypass Engine Dynamics
warning('off','Simulink:SL_SetParamLinkChangeWarn')

%suvo
%set_param(['gtm_design/Aircraft Model/' AircraftType '/Engines/' AircraftType '/Bypass'],'Value','1')
set_param(['gtm_design/Aircraft Model/Engines/Bypass'],'Value','1')

% Run sim for 0.1 seconds.
% This initializes some states that are not set by trimgtm, e.g.
% memory blocks, filter states, etc.
[t,Xtime,y]=sim('gtm_design',[0 0.1]);
Xo=Xtime(end,:);

%% Check to ensure non-accelerating set point
tol=1e-3;
delta_vel=Xtime(1,EOM(1:6))-Xtime(end,EOM(1:6));
if max(abs(delta_vel))>tol,
    fprintf(1,'\n  at t=%3.2f sec Xvel=[%5.2e %5.2e %5.2e %5.2e %5.2e %5.2e]',t(1),  Xtime(1,EOM(1:6)));
    fprintf(1,'\n  at t=%3.2f sec Xvel=[%5.2e %5.2e %5.2e %5.2e %5.2e %5.2e]\n',t(end),Xtime(end,EOM(1:6)));
    warning('Model does not appear to be at a stationary point, deltaV=%3.2f',max(abs(delta_vel)));
end

%% Extract the Linear Model
if (Ts==0),
% Use linmod to extract a continuous time linear model
% Disable the warning about ignoring discrete states
  warning('off','Simulink:tools:dlinmodIgnoreDiscreteStates')
  [a,b,c,d]=linmod('gtm_design',Xo);
  sys=ss(a,b,c,d);
% Enable the warning about ignoring discrete states
  warning('on','Simulink:tools:dlinmodIgnoreDiscreteStates')
else
  [a,b,c,d]=dlinmod('gtm_design',Ts,Xo);
  sys=ss(a,b,c,d,Ts);
end

% Define states to retain, remove others
keep=EOM(1)+[0:11]';
elim=setdiff([1:length(a)]',keep);
sys=modred(sys,elim,'del');

% Remove some of the outputs that are used for trim only
% First 6 are from AUX, last 12 are from the EOM
sys=sys([2:4,7:18],:);

% Convert units on selected outputs
sys.c(1,:) = sys.c(1,:)*1.6878; % convert tas to feet per second
sys.c(2,:) = sys.c(2,:)*pi/180; % convert alpha to radians
sys.c(3,:) = sys.c(3,:)*pi/180; % convert beta to radians

% Set names, hardwired from ordering in block diagram
Inames={'Elevator','Aileron','Rudder',...
        'L Spoiler','R Spoiler','Flaps','Stabilizer','L Throttle','R Throttle'};
Snames={ 'u','v','w','p','q','r',...
    'Lat','Lon','Alt','phi','theta','psi'};
Onames={ 'tas','alpha','beta','u','v','w','p','q','r',...
    'Lat','Lon','Alt','phi','theta','psi'};

set(sys,'StateName',Snames,'OutputName',Onames,'InputName',Inames);

% Create 4th order longitudinal/lateral models
Xlon=[1 3 5 11]; % States to keep (u,w,q,theta)
Xlat=[2 4 6 10]; % States to keep (v,p,r,phi)
Ilon= [1 4 5 8 9]; % inputs to keep (elevator, L/R spoilers, L/R Throttle)
Ilat=[2 3 4 5]; % inputs to keep (aileron, rudder, L/R spoilers,)

if vabflag
    Ylon = [1 2 8 14]; % outputs to keep (tas,alpha,q,theta)
    Ylat = [3 7 9 13]; % outputs to keep (beta,p,r,phi)
    londyn=modred(sys(Ylon,Ilon),setdiff(1:12,Xlon),'del');
    londyn.a = londyn.c*londyn.a*inv(londyn.c);
    londyn.b = londyn.c*londyn.b;
    londyn.c = eye(4);
    set(londyn,'StateNames',Onames([1 2 8 14]))
    
    latdyn=modred(sys(Ylat,Ilat),setdiff(1:12,Xlat),'del');
    latdyn.a = latdyn.c*latdyn.a*inv(latdyn.c);
    latdyn.b = latdyn.c*latdyn.b;
    latdyn.c = eye(4);
    set(latdyn,'StateNames',Onames([3 7 9 13]))
    
    sys = sys([1:3, 7:15],:);
    sys.a = sys.c*sys.a*inv(sys.c);
    sys.b = sys.c*sys.b;
    sys.c = eye(12);
    set(sys,'StateNames',Onames([1:3, 7:15]))    
    
else
    Ylon = [4 6 8 14]; % outputs to keep (u,w,q,theta)
    Ylat = [5 7 9 13]; % outputs to keep (v,p,r,phi)  
    londyn=modred(sys(Ylon,Ilon),setdiff(1:12,Xlon),'del');
    latdyn=modred(sys(Ylat,Ilat),setdiff(1:12,Xlat),'del');
    sys = sys(4:15,:);
end

% return to initial parameters
set_param('gtm_design','InlineParams',inlineflag);
set_param('gtm_design','Dirty',dirtyflag);

% reset Bypass Engine Dynamics
% suvo
%set_param(['gtm_design/Aircraft Model/' AircraftType '/Engines/' AircraftType '/Bypass'],'Value','0')
set_param(['gtm_design/Aircraft Model/Engines/Bypass'],'Value','0')
warning('on','Simulink:SL_SetParamLinkChangeWarn')


