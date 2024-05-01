%
%-------- Main Script ----------
%
% Description

% $ runmain.m - 8/25/09 $
% subhabrata.ganguli@honeywell.com

%% status:

% date: 9/18/09
%
% issue: attitude loop does not track well for large commands (with 1/s)
%        attitude loop (theta and roll) seems to be working for smaller
%        commands (1/s)
%
%        without 1/s - the tracking is worse


%% initial setup

setup

do_Ma_analysis = 0;

%% Design Trim Point

% Trim to nominal condition: level flight, alpha=3
mws_designpoint = trimgtm(struct('eas',90,'gamma',0),'elev',1);

% Load Simulation Variables (at trim condition) into Model Workspace
loadmws(mws_designpoint);

% Linearize model about this condition
fprintf(1,'Linearizing...')
[sys,londyn,latdyn]=linmodel(mws_designpoint);
fprintf(1,' Done\n');

%% Open Closed-Loop Diagram

% Open system and load variables
open_system('gtm_design_baseline2');
loadmws(mws_designpoint,'gtm_design_baseline2');


%% Rough Calculations

Ixx = mws_designpoint.Inertia0(1);
Iyy = mws_designpoint.Inertia0(2);
Izz = mws_designpoint.Inertia0(3);
Ixz = mws_designpoint.Inertia0(4);

J = [Ixx 0 -Ixz; 0 Iyy 0; -Ixz 0 Izz];

invJ = inv(J);

Bmat = sys.b([4 5 6],[2 1 3]);   % p q r <- da de dr
invBmat = inv(Bmat);

Kb_rate = 10;
fi_rate = 1/4;
fc_rate = 0; %1/2;

Kb_att = 1;
fi_att = 1/4;
fc_att = 1/2;
f0_att = fc_att*Kb_att/Kb_rate;

sysrate = tf(Kb_rate/2,[1 Kb_rate/2]);
sysatt  = tf(f0_att*fc_rate*Kb_rate^2,[1 fc_rate*Kb_rate f0_att*fc_rate*Kb_rate^2]);

Mq = sys.a(5,5);
Apqr = sys.a(4:6,4:6);

%% Run Simulation - q command

% Construct Command Signal
a=[0 10 0]; % pulse amplitude(deg/sec), [roll, pitch, yaw]
tfinal = 15;

% Construct doublet sequence
set_param('gtm_design_baseline2/Input Generator/Doublet Generator','timeon','[0 2 0]'); 
set_param('gtm_design_baseline2/Input Generator/Doublet Generator','pulsewidth','[0 2 0]');
set_param('gtm_design_baseline2/Input Generator/Doublet Generator','amplitude',sprintf('[%f %f %f]',a(1),a(2),a(3)));

% Simulation Closed Loop GTM
flag_cmd = 1;
[tsimcl,xsimcl,ysimcl]=sim('gtm_design_baseline2',[0 tfinal]);

% Grab state in ysim First 6 are trim outputs, next 12 are state.
ysimcl=ysimcl(:,7:18);

% Simulate Desired Dynamics
sysdes = sysrate;
ulin = ratecmd.signals.values(:,2)';
tlin = ratecmd.time';
ylin = lsim(sysdes,ulin,tlin);

set(figure(1),'Position',[20 20 900 700]);
subplot(331),
plot(tsimcl,ysimcl(:,1)); grid on
title('Linear Velocity');
xlabel('Time (sec)');ylabel('u (ft/sec)')
legend('Simulation');
subplot(334),
plot(tsimcl,ysimcl(:,2)); grid on
xlabel('Time (sec)');ylabel('v (ft/sec)')
subplot(337),
plot(tsimcl,ysimcl(:,3)); grid on
xlabel('Time (sec)');ylabel('w (ft/sec)')
subplot(332),
plot(tsimcl,180/pi*ysimcl(:,4)); grid on
title('Angular Velocity');
xlabel('Time (sec)');ylabel('p (deg/sec)')
subplot(335),
plot(tsimcl,180/pi*ysimcl(:,5),tlin,ylin,...
         tlin,ulin,'r'); grid on
legend('nonlin-sim','des-resp','cmd');     
xlabel('Time (sec)');ylabel('q (deg/sec)')
subplot(338),
plot(tsimcl,180/pi*ysimcl(:,6)); grid on
xlabel('Time (sec)');ylabel('r (deg/sec)')
subplot(333),
plot(tsimcl,sout.AILL); grid on
title('Control Surface');
xlabel('Time (sec)');ylabel('\deltaa (deg)')
subplot(336),
plot(tsimcl,sout.ELLOB); grid on
xlabel('Time (sec)');ylabel('\deltae (deg)')
subplot(339),
plot(tsimcl,sout.RUDU); grid on
xlabel('Time (sec)');ylabel('\deltar (deg)')

keyboard

%% Run Simulation - Roll-axis command

% Construct Command Signal
a=[0.5 0 0]; % pulse amplitude(deg/sec), [roll, pitch, yaw]
tfinal = 15;

% Construct doublet sequence
set_param('gtm_design_baseline2/Input Generator/Doublet Generator','timeon','[2 0 0]'); 
set_param('gtm_design_baseline2/Input Generator/Doublet Generator','pulsewidth','[2 0 0]');
set_param('gtm_design_baseline2/Input Generator/Doublet Generator','amplitude',sprintf('[%f %f %f]',a(1),a(2),a(3)));

% Simulation Closed Loop GTM
flag_cmd = 1;
[tsimcl,xsimcl,ysimcl]=sim('gtm_design_baseline2',[0 tfinal]);

% Grab state in ysim First 6 are trim outputs, next 12 are state.
ysimcl=ysimcl(:,7:18);

% Simulate Desired Dynamics
sysdes = sysrate;
ulin = ratecmd.signals.values(:,1)';
tlin = ratecmd.time';
ylin = lsim(sysdes,ulin,tlin);

set(figure(2),'Position',[20 20 900 700]);
subplot(331),
plot(tsimcl,ysimcl(:,1)); grid on
title('Linear Velocity');
xlabel('Time (sec)');ylabel('u (ft/sec)')
subplot(334),
plot(tsimcl,ysimcl(:,2)); grid on
xlabel('Time (sec)');ylabel('v (ft/sec)')
subplot(337),
plot(tsimcl,ysimcl(:,3)); grid on
xlabel('Time (sec)');ylabel('w (ft/sec)')
subplot(332),
plot(tsimcl,180/pi*ysimcl(:,4),tlin,ylin,...
         tlin,ulin,'r'); grid on
legend('nonlin-sim','des-resp','cmd');     
title('Angular Velocity');
xlabel('Time (sec)');ylabel('p (deg/sec)')
subplot(335),
plot(tsimcl,180/pi*ysimcl(:,5)); grid on
xlabel('Time (sec)');ylabel('q (deg/sec)')
subplot(338),
plot(tsimcl,180/pi*ysimcl(:,6)); grid on
xlabel('Time (sec)');ylabel('r (deg/sec)')
subplot(333),
plot(tsimcl,sout.AILL); grid on
title('Control Surface');
xlabel('Time (sec)');ylabel('\deltaa (deg)')
subplot(336),
plot(tsimcl,sout.ELLOB); grid on
xlabel('Time (sec)');ylabel('\deltae (deg)')
subplot(339),
plot(tsimcl,sout.RUDU); grid on
xlabel('Time (sec)');ylabel('\deltar (deg)')


%% Run Simulation - Yaw-axis command

% Construct Command Signal
a=[0 0 0.5]; % pulse amplitude(deg/sec), [roll, pitch, yaw]
tfinal = 15;

% Construct doublet sequence
set_param('gtm_design_baseline2/Input Generator/Doublet Generator','timeon','[0 0 2]'); 
set_param('gtm_design_baseline2/Input Generator/Doublet Generator','pulsewidth','[0 0 2]');
set_param('gtm_design_baseline2/Input Generator/Doublet Generator','amplitude',sprintf('[%f %f %f]',a(1),a(2),a(3)));

% Simulation Closed Loop GTM
flag_cmd = 1;
[tsimcl,xsimcl,ysimcl]=sim('gtm_design_baseline2',[0 tfinal]);

% Grab state in ysim First 6 are trim outputs, next 12 are state.
ysimcl=ysimcl(:,7:18);

% Simulate Desired Dynamics
sysdes = sysrate;
ulin = ratecmd.signals.values(:,3)';
tlin = ratecmd.time';
ylin = lsim(sysdes,ulin,tlin);

set(figure(3),'Position',[20 20 900 700]);
subplot(331),
plot(tsimcl,ysimcl(:,1)); grid on
title('Linear Velocity');
xlabel('Time (sec)');ylabel('u (ft/sec)')
subplot(334),
plot(tsimcl,ysimcl(:,2)); grid on
xlabel('Time (sec)');ylabel('v (ft/sec)')
subplot(337),
plot(tsimcl,ysimcl(:,3)); grid on
xlabel('Time (sec)');ylabel('w (ft/sec)')
subplot(332),
plot(tsimcl,180/pi*ysimcl(:,4)); grid on
title('Angular Velocity');
xlabel('Time (sec)');ylabel('p (deg/sec)')
subplot(335),
plot(tsimcl,180/pi*ysimcl(:,5)); grid on
xlabel('Time (sec)');ylabel('q (deg/sec)')
subplot(338),
plot(tsimcl,180/pi*ysimcl(:,6),tlin,ylin,...
         tlin,ulin,'r'); grid on
legend('nonlin-sim','des-resp','cmd');     
xlabel('Time (sec)');ylabel('r (deg/sec)')
subplot(333),
plot(tsimcl,sout.AILL); grid on
title('Control Surface');
xlabel('Time (sec)');ylabel('\deltaa (deg)')
subplot(336),
plot(tsimcl,sout.ELLOB); grid on
xlabel('Time (sec)');ylabel('\deltae (deg)')
subplot(339),
plot(tsimcl,sout.RUDU); grid on
xlabel('Time (sec)');ylabel('\deltar (deg)')


%% Run Simulation - theta command

% Construct Command Signal
a=[0 15 0]; % pulse amplitude(deg), [roll, pitch, yaw]
tfinal = 20;

% Construct doublet sequence
set_param('gtm_design_baseline2/Input Generator/Doublet Generator','timeon','[0 2 0]'); 
set_param('gtm_design_baseline2/Input Generator/Doublet Generator','pulsewidth','[0 8 0]');
set_param('gtm_design_baseline2/Input Generator/Doublet Generator','amplitude',sprintf('[%f %f %f]',a(1),a(2),a(3)));

% Simulation Closed Loop GTM
flag_cmd = 0;
[tsimcl,xsimcl,ysimcl]=sim('gtm_design_baseline2',[0 tfinal]);

% Grab state in ysim First 6 are trim outputs, next 12 are state.
ysimcl=ysimcl(:,7:18);

% Simulate Desired Dynamics
sysdes = sysatt;
ulin = attcmd.signals.values(:,2)';
tlin = attcmd.time';
ylin = lsim(sysdes,ulin,tlin);

set(figure(4),'Position',[20 20 900 700]);
subplot(331),
plot(tsimcl,180/pi*ysimcl(:,10)); grid on
title('Euler Angle');
xlabel('Time (sec)');ylabel('\phi (deg)')
subplot(334),
% plot(tsimcl,180/pi*ysimcl(:,11),tlin,ylin+mws_designpoint.StatesInp(11)*180/pi,...
%      tsimcl,ulin+mws_designpoint.StatesInp(11)*180/pi,'r'); grid on
plot(tsimcl,180/pi*ysimcl(:,11),...
     tsimcl,ulin+mws_designpoint.StatesInp(11)*180/pi,'r'); grid on 
legend('nonlin-sim','des-resp','cmd');
xlabel('Time (sec)');ylabel('\theta (deg)')
subplot(337),
plot(tsimcl,180/pi*ysimcl(:,12)); grid on
xlabel('Time (sec)');ylabel('\psi (deg)')
subplot(332),
plot(tsimcl,180/pi*ysimcl(:,4)); grid on
title('Angular Velocity');
xlabel('Time (sec)');ylabel('p (deg/sec)')
subplot(335),
plot(tsimcl,180/pi*ysimcl(:,5)); grid on
xlabel('Time (sec)');ylabel('q (deg/sec)')
subplot(338),
plot(tsimcl,180/pi*ysimcl(:,6)); grid on
xlabel('Time (sec)');ylabel('r (deg/sec)')
subplot(333),
plot(tsimcl,sout.AILL); grid on
title('Control Surface');
xlabel('Time (sec)');ylabel('\deltaa (deg)')
subplot(336),
plot(tsimcl,sout.ELLOB); grid on
xlabel('Time (sec)');ylabel('\deltae (deg)')
subplot(339),
plot(tsimcl,sout.RUDU); grid on
xlabel('Time (sec)');ylabel('\deltar (deg)')

%% Run Simulation - roll angle command

% Construct Command Signal
a=[15 0 0]; % pulse amplitude(deg), [roll, pitch, yaw]
tfinal = 20;

% Construct doublet sequence
set_param('gtm_design_baseline2/Input Generator/Doublet Generator','timeon','[2 0 0]'); 
set_param('gtm_design_baseline2/Input Generator/Doublet Generator','pulsewidth','[8 0 0]');
set_param('gtm_design_baseline2/Input Generator/Doublet Generator','amplitude',sprintf('[%f %f %f]',a(1),a(2),a(3)));

% Simulation Closed Loop GTM
flag_cmd = 0;
[tsimcl,xsimcl,ysimcl]=sim('gtm_design_baseline2',[0 tfinal]);

% Grab state in ysim First 6 are trim outputs, next 12 are state.
ysimcl=ysimcl(:,7:18);

% Simulate Desired Dynamics
sysdes = sysatt;
ulin = attcmd.signals.values(:,1)';
tlin = attcmd.time';
ylin = lsim(sysdes,ulin,tlin);

set(figure(5),'Position',[20 20 900 700]);
subplot(331),
% plot(tsimcl,180/pi*ysimcl(:,10),tlin,ylin+mws_designpoint.StatesInp(10)*180/pi,...
%      tsimcl,ulin+mws_designpoint.StatesInp(10)*180/pi,'r'); grid on
plot(tsimcl,180/pi*ysimcl(:,10),...
     tsimcl,ulin+mws_designpoint.StatesInp(10)*180/pi,'r'); grid on
legend('nonlin-sim','des-resp','cmd'); 
title('Euler Angle');
xlabel('Time (sec)');ylabel('\phi (deg)')
subplot(334),
plot(tsimcl,180/pi*ysimcl(:,11)); grid on
xlabel('Time (sec)');ylabel('\theta (deg)')
subplot(337),
plot(tsimcl,180/pi*ysimcl(:,12)); grid on
xlabel('Time (sec)');ylabel('\psi (deg)')
subplot(332),
plot(tsimcl,180/pi*ysimcl(:,4)); grid on
title('Angular Velocity');
xlabel('Time (sec)');ylabel('p (deg/sec)')
subplot(335),
plot(tsimcl,180/pi*ysimcl(:,5)); grid on
xlabel('Time (sec)');ylabel('q (deg/sec)')
subplot(338),
plot(tsimcl,180/pi*ysimcl(:,6)); grid on
xlabel('Time (sec)');ylabel('r (deg/sec)')
subplot(333),
plot(tsimcl,sout.AILL); grid on
title('Control Surface');
xlabel('Time (sec)');ylabel('\deltaa (deg)')
subplot(336),
plot(tsimcl,sout.ELLOB); grid on
xlabel('Time (sec)');ylabel('\deltae (deg)')
subplot(339),
plot(tsimcl,sout.RUDU); grid on
xlabel('Time (sec)');ylabel('\deltar (deg)')



