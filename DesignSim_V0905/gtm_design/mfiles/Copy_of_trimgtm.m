function [MWS,Xtrim,Trimcond,Err] = trimgtm(target,PitchSurf,verbose);
%function [MWS,Xtrim,Trimcond,Err] = trimgtm(target,PitchSurf,verbose);
%
% Trims gtm_design simulation to target conditions.
%
% Inputs:
%  Target is a structure which has some subset of the following fields:
%     eas          - Equivalent air speed (knots)
%     tas          - True airspeed (knots)
%     alpha        - Angle of attack (deg)
%     beta         - Sideslip (deg), defaults to zero
%     gamma        - Flight path angle (deg)
%     roll         - Roll angle (deg)
%     pitch        - Pitch angle (deg)
%     yaw          - Heading angle (0-360)
%     rollrate     - d/dt(phi) (deg/sec), defaults to zero
%     pitchrate    - d/dt(theta) (deg/sec), defaults to zero
%     yawrate      - d/dt(psi) (deg/sec), defaults to zero
%     pdeg         - Angular velocity (deg/sec)
%     qdeg         - Angular velocity (deg/sec)
%     rdeg         - Angular velocity (deg/sec)
%
%   PitchSurf    - 'elev' for elevator (default) or 'stab' for stabalizer
%   verbose      - 0(quiet), 1(soln disp), or 2(iterations), defaults to 2
%
%Outputs:
%   MWS    - simulation parameter set, updated to be at trim condition
%   Xtrim    - simulation full-state, at trim
%   Trimcond - values of state and control surfaces at trim.
%   Err      - max error in trim condition
%
% Unspecified variables are free, or defaulted to the values shown above.
% To force a defaulted variable to be free define it with an empty matrix.
% For example, by default beta=0  but "target.beta=[];" will allow beta
% to be free in searching for a trim condition.
%
% Examples:
%  MWS=trimAirSTAR(struct('eas',95,'gamma',0));
%  [MWS,Xt,Tc,Er]=trimAirSTAR(struct('alpha',3,'gamma',0,'yaw',120),1);
%  [MWS,Xt,Tc,Er]=trimAirSTAR(struct('tas',100,'gamma',3,'yawrate',10),0,0);
%

% d.e.cox@larc.nasa.gov
% $Id: trimAirSTAR.m 885 2008-07-22 17:51:23Z murch $

% Constants
fps2knots = 0.592487;

% Elevator Trim by default
if (~exist('PitchSurf','var') || isempty (PitchSurf)),
    PitchSurf='elev';
end

% Assign logical TrimWithStab variable
if strncmpi(PitchSurf,'elev',4), TrimWithStab=0;
elseif strncmpi(PitchSurf,'stab',4), TrimWithStab=1;
else error('String variable PitchSurf must be one of ''elev'' or ''stab'' ');
end

% Noisy by default
if ( ~exist('verbose','var') || isempty(verbose) ), verbose=2; end

% Error checking input
if ( isfield(target,'eas') && isfield(target,'tas') )
    error('May specify a eas or tas, but not both');
end

if isfield(target,'alpha')&&isfield(target,'pitch')&&isfield(target,'gamma'),
    error('Lacking free variable, cannot specify target in alpha,pitch and gamma');
end

knownfields={ 'eas','tas','alpha','beta','gamma','gndtrack',...
    'roll','pitch','yaw',...
    'rollrate','pitchrate','yawrate',...
    'pdeg','qdeg','rdeg'};
saywhat=setdiff(fieldnames(target),knownfields);
if ~isempty(saywhat),
    for i=1:length(saywhat),fprintf(1,'Unknown field in target: %s\n',saywhat{i}),end
    error('Unknown fields');
end

% Defaults if not specified
if ~isfield(target,'beta'),     target.beta=0; end
if ~isfield(target,'rollrate'), target.rollrate=0; end
if ~isfield(target,'pitchrate'),target.pitchrate=0; end
if ~isfield(target,'yawrate'),  target.yawrate=0; end

% Remove fields assocated with empty targets (overrides defaults);
fn=fieldnames(target);
for i=1:length(fn)
    if isempty(target.(fn{i}))
        target=rmfield(target,fn{i});
    end
end

% Warn on zero gndtrack|yaw
if isfield(target,'yaw') && target.yaw==0,
    warning('0 degree yaw is at 0/360 discontinuity, optimizer may stall'); pause(1);
end

%Define surface bounds for trim conditions
ThrLim  = [ 0; 100];      % Throttle limits (%)
EleLim  = [-30.0;  30.0]; % Elevator bounds (degrees)
StbLim  = [-12.0;  4.0]; % Stabilizer bounds (degrees)
AilLim  = [-20;  20];     % Aileron limits (degrees)
RudLim  = [-30;  30];     % Rudder limits (deg)

% Set Inline Params to off.
% If not "off", optimization stalls completely.
dirtyflag =get_param('gtm_design','Dirty');
inlineflag=get_param('gtm_design','InlineParams');
set_param('gtm_design','InlineParams','off');

% Compile model, setup initial conds and bounds
[t,Xo,y]=sim('gtm_design',0);Xo=Xo(:);

[tmp1,tmp2,StateNames]=gtm_design([],[],[],'compile');

% Find Configurable Subsystems
AircraftType = get_param('gtm_design/Aircraft Model','BlockChoice');

switch AircraftType
    case 'L1011_S2'
        if TrimWithStab
            error('Cannot trim with Stab on S2')
        end
        EngType = get_param('gtm_design/Aircraft Model/L1011_S2/Engines/L1011_S2/Engine','BlockChoice');
        % Get index offsets to relevant states, EOM, Engine dynamics and actuator servos
        Index.EOM  = find(strcmp(StateNames,'gtm_design/Aircraft Model/L1011_S2/EOM/Integrator')==1);
        Index.Eng = ...
            find(strcmp(StateNames,['gtm_design/Aircraft Model/L1011_S2/Engines/L1011_S2/Engine/', EngType,'/Tunable Lag/Integrator'])==1);
        Index.Ele = [...
            find(strcmp(StateNames,'gtm_design/Aircraft Model/L1011_S2/Actuators/L1011_S2/LeftElevatorServo/Integrator')),...
            find(strcmp(StateNames,'gtm_design/Aircraft Model/L1011_S2/Actuators/L1011_S2/RightElevatorServo/Integrator'))];
        Index.Ail = [...
            find(strcmp(StateNames,'gtm_design/Aircraft Model/L1011_S2/Actuators/L1011_S2/LeftAileronServo/Integrator')),...
            find(strcmp(StateNames,'gtm_design/Aircraft Model/L1011_S2/Actuators/L1011_S2/RightAileronServo/Integrator'))];
        Index.Rud =  ...
            find(strcmp(StateNames,'gtm_design/Aircraft Model/L1011_S2/Actuators/L1011_S2/RudderServo/Integrator'));

    case 'GTM_T2'

        LfEngType = get_param(['gtm_design/Aircraft Model/GTM_T2/Engines/GTM_T2/Left_Engine'],'BlockChoice');
        RtEngType = get_param(['gtm_design/Aircraft Model/GTM_T2/Engines/GTM_T2/Right_Engine'],'BlockChoice');

        % Get index offsets to relevant states, EOM, Engine dynamics and actuator servos
        Index.EOM  = find(strcmp(StateNames,['gtm_design/Aircraft Model/GTM_T2/EOM/Integrator'])==1);
        Index.Eng = [...
            find(strcmp(StateNames,['gtm_design/Aircraft Model/GTM_T2/Engines/GTM_T2/Left_Engine/', RtEngType,'/Tunable Lag/Integrator'])==1),...
            find(strcmp(StateNames,['gtm_design/Aircraft Model/GTM_T2/Engines/GTM_T2/Right_Engine/',LfEngType,'/Tunable Lag/Integrator'])==1)
            ];
        Index.Stb = find(strcmp(StateNames,['gtm_design/Aircraft Model/GTM_T2/Actuators/GTM_T2/StabilizerServo/Integrator']));
        Index.Ele = [...
            find(strcmp(StateNames,['gtm_design/Aircraft Model/GTM_T2/Actuators/GTM_T2/ElevatorLOBServo/Integrator'])),...
            find(strcmp(StateNames,['gtm_design/Aircraft Model/GTM_T2/Actuators/GTM_T2/ElevatorLIBServo/Integrator'])),...
            find(strcmp(StateNames,['gtm_design/Aircraft Model/GTM_T2/Actuators/GTM_T2/ElevatorROBServo/Integrator'])),...
            find(strcmp(StateNames,['gtm_design/Aircraft Model/GTM_T2/Actuators/GTM_T2/ElevatorRIBServo/Integrator']))];
        Index.Ail = [...
            find(strcmp(StateNames,['gtm_design/Aircraft Model/GTM_T2/Actuators/GTM_T2/LeftAileronServo/Integrator'])),...
            find(strcmp(StateNames,['gtm_design/Aircraft Model/GTM_T2/Actuators/GTM_T2/RightAileronServo/Integrator']))];
        Index.Rud =  [...
            find(strcmp(StateNames,['gtm_design/Aircraft Model/GTM_T2/Actuators/GTM_T2/RudderUServo/Integrator'])),...
            find(strcmp(StateNames,['gtm_design/Aircraft Model/GTM_T2/Actuators/GTM_T2/RudderLServo/Integrator']))];
end



% Construct set of parameters to tune in finding trim
if (TrimWithStab),
    ndxPitchSurf=Index.Stb(1);
    PitchSurfLim=StbLim;
else
    ndxPitchSurf=Index.Ele(1);
    PitchSurfLim=EleLim;
end

XU_0=[Xo(Index.EOM(1:6)); Xo(Index.EOM(10:12)); Xo(Index.Eng(1)); Xo(ndxPitchSurf); Xo(Index.Ail(2)); Xo(Index.Rud); 1e4];



% Set limits on variables used to constrain optimization
XU_lower=[ -inf*ones(9,1); ThrLim(1); PitchSurfLim(1); AilLim(1); RudLim(1); 0];
XU_upper=[  inf*ones(9,1); ThrLim(2); PitchSurfLim(2); AilLim(2); RudLim(2); inf];

% Setup optimization parameters
para=[];
if (verbose==2), para(1)=1; end    % Verbose display
para(2)=1e-7; % Convergence criteria
para(7)=1;    % Update Hessian
para(13)=6;   % 6 equality constraints d/dt[pqr;uvw] = 0
para(14)=2500; % Iteration limit

% Run optimization
if (verbose==1), fprintf(1,'Optimizing using simulink function nlconst...'); end
warning('off','MATLAB:nearlySingularMatrix');
warning('off','MATLAB:divideByZero');
[XU_opt,opt] = simcnstr('trim',@(x) simio(x,Xo,Index,target,TrimWithStab,AircraftType),XU_0,para,XU_lower,XU_upper,[]);
warning('on','MATLAB:nearlySingularMatrix');
warning('on','MATLAB:divideByZero');
if (verbose==1), fprintf(1,' Done\n'), end

% Map angular trim conditions to this range:
% phi=[-pi:pi]   theta=[-pi:pi]  psi=[0:2*pi]
% Note: using XU_lower/upper constraints for these
%       seems to make optimization more difficult
XU_opt(7:9)=mod(XU_opt(7:9),2*pi);
if(XU_opt(7)>+pi), XU_opt(7)=XU_opt(7)-2*pi; end
if(XU_opt(7)<-pi), XU_opt(7)=XU_opt(7)+2*pi; end
if(XU_opt(8)>+pi), XU_opt(8)=XU_opt(8)-2*pi; end
if(XU_opt(8)<-pi), XU_opt(8)=XU_opt(8)+2*pi; end
if(XU_opt(9)<0),   XU_opt(9)=XU_opt(9)+2*pi; end

switch AircraftType
    case 'L1011_S2'
        % Extract trim state from optimization variable
        Xtrim=Xo;
        Xtrim(Index.EOM(1:6))  = XU_opt(1:6);
        Xtrim(Index.EOM(10:12))= XU_opt(7:9);
        Xtrim(Index.Eng)       = XU_opt(10);
        Xtrim(Index.Ele)       = XU_opt(11)*[1;1];
        Xtrim(Index.Ail)       = XU_opt(12)*[-1;1];
        Xtrim(Index.Rud)       = XU_opt(13);
    case 'GTM_T2'
        % Extract trim state from optimization variable
        Xtrim=Xo;
        Xtrim(Index.EOM(1:6))  = XU_opt(1:6);
        Xtrim(Index.EOM(10:12))= XU_opt(7:9);
        Xtrim(Index.Eng) = XU_opt(10)*[1;1];
        if (TrimWithStab)
            Xtrim(Index.Stb)= XU_opt(11);
        else
            Xtrim(Index.Ele)= XU_opt(11)*[1;1;1;1];
        end
        Xtrim(Index.Ail)  = XU_opt(12)*[-1;1];
        Xtrim(Index.Rud)  = XU_opt(13)*[1;1];
end

% Return MWS (Model WorkSpace) variables that reflect trimmed values
% Grab model workspace into structure
MWS=grabmws('gtm_design');
% Update values effected by trimming
MWS.StatesInp(1:6)   = XU_opt(1:6);
MWS.StatesInp(10:12) = XU_opt(7:9);
MWS.bias.throttle    = XU_opt(10);
if (TrimWithStab),
    MWS.bias.stabilizer = XU_opt(11);
else
    MWS.bias.elevator   = XU_opt(11);
end
MWS.bias.aileron     = XU_opt(12);
MWS.bias.rudder      = XU_opt(13);

yout=gtm_design(0,Xtrim,[],'outputs');
dx  =gtm_design(0,Xtrim,[],'derivs');
gtm_design([],[],[],'term');

% Calculate Error in trim condition
Err = max(abs(dx(1:6))); % Should all be zero
outnames={'eas','tas','alpha','beta','gamma','gndtrack','roll','pitch','yaw','rollrate','pitchrate','yawrate','pdeg','qdeg','rdeg'};
outvalues=[yout(1:6);Xtrim(10:12)*180/pi;dx(10:12)*180/pi; Xtrim(4:6)*180/pi];
for i=1:length(outnames)
    if isfield(target,outnames{i}),  % for ones that are specified target points
        Err = max(Err,abs(outvalues(i)-target.(outnames{i})));
    end
end

% Print results to screen
if (verbose),
    fprintf(1,'\nTarget conditions:\n  ');
    fn=sort(fieldnames(target));
    for i=1:length(fn),  if (target.(fn{i})~=0),   fprintf(1,'%s: %5.2f   ',fn{i},target.(fn{i})); end, end
    fprintf('\n  ');
    for i=1:length(fn),  if (target.(fn{i})==0),   fprintf(1,'%s: %5.2f   ',fn{i},target.(fn{i})); end, end
    fprintf(1,'\n\nTrim conditions (Err=%5.3e)\n',Err);
    fprintf(1,'  gamma: %5.2f\t\ttas: %5.2f\t\talt: %8.2f\n',yout(5),yout(2),Xtrim(9));
    fprintf(1,'  eas: %5.2f\t\talpha: %5.2f\t\tbeta: %5.2f\n',yout(1),yout(3),yout(4));
    fprintf(1,'  pdeg: %5.2f\t\tqdeg: %5.2f\t\trdeg: %5.2f\n',Xtrim(4:6)*180/pi);
    fprintf(1,'  roll: %5.2f\t\tpitch: %5.2f\t\tyaw: %5.2f\t\tgndtrack:%5.2f\n',Xtrim(10:12)*180/pi,yout(6));
    fprintf(1,'  rollrate: %5.2f\tpitchrate: %5.2f\tyawrate: %5.2f\n\n',dx(10:12)*180/pi);
    fprintf(1,'  elevator: %5.2f\tstabilizer: %5.2f\tailerons: %5.2f\t\trudder:% 5.2f\n',...
        MWS.bias.elevator, MWS.bias.stabilizer, MWS.bias.aileron, MWS.bias.rudder);
    fprintf(1,'  throttle: %5.2f\tspeedbrake: %5.2f\tflaps: %5.2f\t\tgeardown:% 5.2f\n\n',...
        MWS.bias.throttle, MWS.bias.speedbrake, MWS.bias.flaps, MWS.bias.geardown);
    fprintf(1,'  d/dt(u,v,w,p,q,r)\t[%5.2e %5.2e %5.2e %5.2e %5.2e %5.2e]\n',dx(1:6));
    fprintf(1,'  d/dt(phi,theta,psi)\t[%5.2e %5.2e %5.2e]\n\n',dx(10:12));
end

% Tabulate results in Trim Condition structure
Trimcond.eas      =yout(1);
Trimcond.tas      =yout(2);
Trimcond.alpha    =yout(3);
Trimcond.beta     =yout(4);
Trimcond.gamma    =yout(5);
Trimcond.pdeg     =Xtrim(4)*180/pi;
Trimcond.qdeg     =Xtrim(5)*180/pi;
Trimcond.rdeg     =Xtrim(6)*180/pi;
Trimcond.altitude =Xtrim(9);
Trimcond.roll     =Xtrim(10)*180/pi;
Trimcond.pitch    =Xtrim(11)*180/pi;
Trimcond.yaw      =Xtrim(12)*180/pi;
Trimcond.gndtrack =yout(6);
Trimcond.pitchrate=dx(10)*180/pi;
Trimcond.rollrate =dx(11)*180/pi;
Trimcond.yawrate  =dx(12)*180/pi;
Trimcond.throttle =MWS.bias.throttle;
Trimcond.stab     =MWS.bias.stabilizer;
Trimcond.aileron  =MWS.bias.aileron;
Trimcond.rudder   =MWS.bias.rudder;
Trimcond.elevator =MWS.bias.elevator;
Trimcond.spdbrake =MWS.bias.speedbrake;
Trimcond.flaps    =MWS.bias.flaps;
Trimcond.geardown =MWS.bias.geardown;
Trimcond.Xo       =Xtrim(Index.EOM);

% return model to initial parameters
set_param('gtm_design','InlineParams',inlineflag);
set_param('gtm_design','Dirty',dirtyflag);


%============================== SubFunctions ==============================
function [f,g]=simio(xu,Xo,Index,target,TrimWithStab,AircraftType)
%function [f,g]=gtmio(xu,Xo,Index,target,TrimWithStab,AircraftType)
%
% Calls model simulation in "precompiled" mode
% sets up objective function and constraints for optimization

switch AircraftType
    case 'L1011_S2'
        %
        % Setup tweaked vector
        %
        Xtweak=Xo;
        Xtweak(Index.EOM(1:6))   = xu(1:6);        % [u;v;w;p;q;r]
        Xtweak(Index.EOM(10:12)) = xu(7:9);        % [phi;theta;psi]
        Xtweak(Index.Eng)        = xu(10);         % Engine integrator states
        Xtweak(Index.Ele)        = xu(11)*[1;1];   % Both Elevator servo state
        Xtweak(Index.Ail)        = xu(12)*[-1;1];  % Both Aileron servo states
        Xtweak(Index.Rud)        = xu(13);         % Rudder servo states

    case 'GTM_T2'
        %
        % Setup tweaked vector
        %
        Xtweak=Xo;
        Xtweak(Index.EOM(1:6))   = xu(1:6);          % [u;v;w;p;q;r]
        Xtweak(Index.EOM(10:12)) = xu(7:9);          % [phi;theta;psi]
        Xtweak(Index.Eng)        = xu(10)*[1;1];     % Both engine integrator states
        if (TrimWithStab),
            Xtweak(Index.Stb)        = xu(11);           % Stabilizer servo state
        else
            Xtweak(Index.Ele)        = xu(11)*[1;1;1;1]; % All four Elevator servo state
        end
        Xtweak(Index.Ail)        = xu(12)*[-1;1];    % Both Aileron servo states
        Xtweak(Index.Rud)        = xu(13)*[1;1];     % Both Rudder servo states
end
% Calculate outputs and derivatives
trim_at_time=1e-3; % sec, Avoiding zero as it might trigger IC blocks or
% other initialization procedures.
yout = gtm_design(trim_at_time,Xtweak,[],'outputs');
dx   = gtm_design(trim_at_time,Xtweak,[],'derivs');

% Form trim error on auxilary variables
delta=zeros(15,1);
if isfield(target,'eas'),      delta(1)  =yout(1)-target.eas;     end % eas
if isfield(target,'tas'),      delta(2)  =yout(2)-target.tas;    end % tash
if isfield(target,'alpha'),    delta(3)  =yout(3)-target.alpha;   end % alpha
if isfield(target,'beta'),     delta(4)  =yout(4)-target.beta;   end % beta
if isfield(target,'gamma'),    delta(5)  =yout(5)-target.gamma;    end % gamma
if isfield(target,'gndtrack'), delta(6)  =yout(6)-target.gndtrack;end % ground track
if isfield(target,'roll'),     delta(7)  =Xtweak(Index.EOM(10))-target.roll*pi/180;end   % roll
if isfield(target,'pitch'),    delta(8)  =Xtweak(Index.EOM(11))-target.pitch*pi/180;end   % pitch
if isfield(target,'yaw'),      delta(9)  =Xtweak(Index.EOM(12))-target.yaw*pi/180;end   % yaw (heading)
if isfield(target,'rollrate'), delta(10) =dx(Index.EOM(10))-target.rollrate*pi/180;  end  % phidot
if isfield(target,'pitchrate'),delta(11) =dx(Index.EOM(11))-target.pitchrate*pi/180; end  % thetadot
if isfield(target,'yawrate'),  delta(12) =dx(Index.EOM(12))-target.yawrate*pi/180;   end  % psidot
if isfield(target,'pdeg'),     delta(13) =Xtweak(Index.EOM(4))-target.pdeg*pi/180; end  % p
if isfield(target,'qdeg'),     delta(14) =Xtweak(Index.EOM(5))-target.qdeg*pi/180; end  % q
if isfield(target,'rdeg'),     delta(15) =Xtweak(Index.EOM(6))-target.rdeg*pi/180; end  % r

f=xu(end);  %Lagrange Multiplier
g=[dx(1:6); delta(:)-f; -delta(:)-f ]; % d/dt[uwv,pqr]=0 equality constraint,
% minimize trim error with Lagrange multiplier





