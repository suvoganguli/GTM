%
%------- CLAW experiment ------------
%
% Create linear model, design pitch-axis controller, and
% test at different trim points

% $ my_ex1.m - 8/25/09 $
% subhabrata.ganguli@honeywell.com

%% initial setup

setup

% load nominal starting point into simulation model workspace
loadmws(init_design('GTM'));

% Trim to nominal condition: level flight, alpha=3
SimVars=trimgtm(struct('alpha',3, 'gamma',0));

% Load Simulation Variables (at trim condition) into Model Workspace
loadmws(SimVars);

% Linearize model about this condition
fprintf(1,'Linearizing...')
[sys,londyn,latdyn]=linmodel();
fprintf(1,' Done\n');


%% Open-loop Tests

% Construct 1 degree double in elevator only. 
f=100;    % 100 Hz input sampling on sequence
d=0.5;      % 2 sec pulse duration
a=[1 0 0];% pulse amplitude(deg), [ele,rud,ail]

dub=[zeros(4*f*d,1);ones(f*d,1);-1*ones(f*d,1);zeros(4*f*d,1)]; % a doublet
ulin = [  [a(1)*dub;0*dub;0*dub], [0*dub;0*dub;a(3)*dub], [0*dub;a(2)*dub;0*dub] ]; % doublet sequence
tlin=[0:length(ulin)-1]/f;

% Run linear simulation
ylin=lsim(sys(:,[1,2,3]),ulin,tlin);

% Construct same doublet sequence via simulink
set_param('gtm_design/Input Generator/Doublet Generator','timeon','[2 12 7]'); 
set_param('gtm_design/Input Generator/Doublet Generator','pulsewidth','[0.5 0.5 0.5]');
set_param('gtm_design/Input Generator/Doublet Generator','amplitude',sprintf('[%f %f %f]',a(1),a(3),a(2)));
[tsim,xsim,ysim]=sim('gtm_design',[0 max(tlin)]);

% Turn simulink doublet generation off
set_param('gtm_design/Input Generator/Doublet Generator','amplitude','[0 0 0]');

% Grab state in ysim First 6 are trim outputs, next 12 are state.
ysim=ysim(:,7:18);


%% Open-loop Plots

set(figure(1),'Position',[20 80 900 700]);
subplot(321),
plot(tsim,ysim(:,1),  tlin,ylin(:,1)+ysim(1,1)); grid on
title('Linear Velocity to Doublet Sequence [elevator,rudder,aileron]');
xlabel('Time (sec)');ylabel('u (ft/sec)')
legend('Simulation', 'Linear');
subplot(323),
plot(tsim,ysim(:,2),  tlin,ylin(:,2)+ysim(1,2)); grid on
xlabel('Time (sec)');ylabel('v (ft/sec)')
subplot(325),
plot(tsim,ysim(:,3),  tlin,ylin(:,3)+ysim(1,3)); grid on
xlabel('Time (sec)');ylabel('w (ft/sec)')

subplot(322),
plot(tsim,180/pi*ysim(:,4),  tlin,180/pi*(ylin(:,4)+ysim(1,4))); grid on
title('Angular Velocity to Doublet Sequence [elevator,rudder,aileron]');
xlabel('Time (sec)');ylabel('p (deg/sec)')
subplot(324),
plot(tsim,180/pi*ysim(:,5),  tlin,180/pi*(ylin(:,5)+ysim(1,5))); grid on
xlabel('Time (sec)');ylabel('q (deg/sec)')
subplot(326),
plot(tsim,180/pi*ysim(:,6),  tlin,180/pi*(ylin(:,6)+ysim(1,6))); grid on
xlabel('Time (sec)');ylabel('r (deg/sec)')


%% Baseline Control Law - Pitch-axis

Alon    = londyn.a;
Blon    = londyn.b;
Alon_sp = Alon([3 2],[3 2]);   % q w
Blon_sp = Blon([3 2],1);       % q w <- de

ub_trim = MWSout.StatesInp(1); % fps
vb_trim = MWSout.StatesInp(2); % fps
wb_trim = MWSout.StatesInp(3); % fps
tas_fps = norm([ub_trim,vb_trim,wb_trim],2); % fps
alpha_trim = atan(wb_trim/ub_trim)*180/pi; % deg

T_wtoalp = [1 0;0 tas_fps];
Alon_sp2 = inv(T_wtoalp) * Alon_sp * (T_wtoalp);  % q alp
Blon_sp2 = inv(T_wtoalp) * Blon_sp;               % q alp <- de

% Inversion gains
CA = [1 0]*Alon_sp2;
invCB = inv([1 0]*Blon_sp2);

% Desired Dynamics
Kb = 4;
fi = 1/4;
fc = 1/2*0;

% newFC_on = 1;
% if newFC_on
%     
%     % Trim to nominal condition: level flight, alpha=3
%     SimVars=trimgtm(struct('alpha',5, 'gamma',0, 'tas',60));  % origtas = 90
%     
%     ub_trim = MWSout.StatesInp(1); % fps
%     vb_trim = MWSout.StatesInp(2); % fps
%     wb_trim = MWSout.StatesInp(3); % fps
%     tas_fps = norm([ub_trim,vb_trim,wb_trim],2); % fps
%     alpha_trim = atan(wb_trim/ub_trim)*180/pi; % deg    
% 
% end

% Open block diagram
open_system('gtm_design_baseline'); 

% Load Simulation Variables (at trim condition) into Model Workspace
loadmws(SimVars,'gtm_design_baseline');

% Construct 1 degree double in elevator only. 
a=[5 0 0];% pulse amplitude(deg/sec), [pitch-rate]

% Construct 1 degree double in elevator only. 
f=100;      % 100 Hz input sampling on sequence
d=5;        % 5 sec step
a=[5 0 0];  % pulse amplitude(deg), [pitch-rate,rud,ail]

% Construct same doublet sequence via simulink
set_param('gtm_design_baseline/Input Generator/Doublet Generator','timeon','[5 12 7]'); 
set_param('gtm_design_baseline/Input Generator/Doublet Generator','pulsewidth','[5 0.5 0.5]');
set_param('gtm_design_baseline/Input Generator/Doublet Generator','amplitude',sprintf('[%f %f %f]',a(1),a(3),a(2)));
[tsimcl,xsimcl,ysimcl]=sim('gtm_design_baseline',[0 10]);

% Turn simulink doublet generation off
set_param('gtm_design_baseline/Input Generator/Doublet Generator','amplitude','[0 0 0]');

% Grab state in ysim First 6 are trim outputs, next 12 are state.
ysimcl=ysimcl(:,7:18);

% Simulate Desired Dynamics
stp=[zeros(f*d,1);ones(f*d,1)];
ulin = [a(1)*stp]; 
tlin=[0:length(ulin)-1]/f;
sysdes = tf(4,[1 4 4]);
ylin=lsim(sysdes,ulin,tlin);


%% Closed-loop Plots

set(figure(2),'Position',[20 80 900 700]);
subplot(321),
plot(tsimcl,ysimcl(:,1)); grid on
title('Linear Velocity to Doublet Sequence [elevator,rudder,aileron]');
xlabel('Time (sec)');ylabel('u (ft/sec)')
legend('Simulation');
subplot(323),
plot(tsimcl,ysimcl(:,2)); grid on
xlabel('Time (sec)');ylabel('v (ft/sec)')
subplot(325),
plot(tsimcl,ysimcl(:,3)); grid on
xlabel('Time (sec)');ylabel('w (ft/sec)')

subplot(322),
plot(tsimcl,180/pi*ysimcl(:,4)); grid on
title('Angular Velocity to Doublet Sequence [elevator,rudder,aileron]');
xlabel('Time (sec)');ylabel('p (deg/sec)')
subplot(324),
plot(tsimcl,180/pi*ysimcl(:,5),tlin,ylin); grid on
xlabel('Time (sec)');ylabel('q (deg/sec)')
subplot(326),
plot(tsimcl,180/pi*ysimcl(:,6)); grid on
xlabel('Time (sec)');ylabel('r (deg/sec)')

figure(3);
plot(tsimcl,sout.ELLOB); % all elevs are same



%% Close Diagrams

% Close open-loop block diagram
bdclose('gtm_design');
bdclose('gtm_design_baseline');
