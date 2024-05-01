%
%-------- Analyze AeroData ----------
%
% Script to analyse and understand the
% aerodyanmic data for the gtm model
%
% Incomplete as of 8/26/09
% 
% $ analyze_aerodata - 8/26/09 $
% subhabrata.ganguli@honeywell.com

%% initial setup

setup

%% Design Trim Point

% Trim to nominal condition: level flight, alpha=3
mws_designpoint = trimgtm(struct('eas',85,'gamma',0),'elev',1);

% Load Simulation Variables (at trim condition) into Model Workspace
loadmws(mws_designpoint);

% Linearize model about this condition
fprintf(1,'Linearizing...')
[sys,londyn,latdyn]=linmodel(mws_designpoint);
fprintf(1,' Done\n');

%% Basic Airframe

% alpha range = [-5 ... 85]
% beta range  = [-45 ...45]

% Extract Aerodata
aerodata = mws_designpoint.Aero;

in_alpha = 3; % deg
in_beta = 0; % deg

vec_beta  = aerodata.C6_bas.beta;
vec_alpha = aerodata.C6_bas.alpha;
idx_beta  = find(in_beta == vec_beta);
idx_alpha = find(in_alpha >= vec_alpha, 1, 'last' );

CX_vs_alpha = aerodata.C6_bas.data(:,idx_beta,1);
CY_vs_alpha = aerodata.C6_bas.data(:,idx_beta,2);
CZ_vs_alpha = aerodata.C6_bas.data(:,idx_beta,3);
Cl_vs_alpha = aerodata.C6_bas.data(:,idx_beta,4);
Cm_vs_alpha = aerodata.C6_bas.data(:,idx_beta,5);
Cn_vs_alpha = aerodata.C6_bas.data(:,idx_beta,6);

% !! Warning: assumes mid-point for alpha (for now)
CX_vs_beta = (aerodata.C6_bas.data(idx_alpha,:,1)+aerodata.C6_bas.data(idx_alpha+1,:,1))/2; 
CY_vs_beta = (aerodata.C6_bas.data(idx_alpha,:,2)+aerodata.C6_bas.data(idx_alpha+1,:,2))/2;
CZ_vs_beta = (aerodata.C6_bas.data(idx_alpha,:,3)+aerodata.C6_bas.data(idx_alpha+1,:,3))/2;
Cl_vs_beta = (aerodata.C6_bas.data(idx_alpha,:,4)+aerodata.C6_bas.data(idx_alpha+1,:,4))/2;
Cm_vs_beta = (aerodata.C6_bas.data(idx_alpha,:,5)+aerodata.C6_bas.data(idx_alpha+1,:,5))/2;
Cn_vs_beta = (aerodata.C6_bas.data(idx_alpha,:,6)+aerodata.C6_bas.data(idx_alpha+1,:,6))/2;

CX = (aerodata.C6_bas.data(idx_alpha,idx_beta,1)+aerodata.C6_bas.data(idx_alpha+1,idx_beta,1))/2; 
CY = (aerodata.C6_bas.data(idx_alpha,idx_beta,2)+aerodata.C6_bas.data(idx_alpha+1,idx_beta,2))/2;
CZ = (aerodata.C6_bas.data(idx_alpha,idx_beta,3)+aerodata.C6_bas.data(idx_alpha+1,idx_beta,3))/2;
Cl = (aerodata.C6_bas.data(idx_alpha,idx_beta,4)+aerodata.C6_bas.data(idx_alpha+1,idx_beta,4))/2;
Cm = (aerodata.C6_bas.data(idx_alpha,idx_beta,5)+aerodata.C6_bas.data(idx_alpha+1,idx_beta,5))/2;
Cn = (aerodata.C6_bas.data(idx_alpha,idx_beta,6)+aerodata.C6_bas.data(idx_alpha+1,idx_beta,6))/2;

set(figure(1),'Position',[20 80 900 700]);
subplot(321)
plot(vec_alpha,CX_vs_alpha); grid on
xlabel('alpha (deg)'); ylabel('CX (\beta = 0 deg)');
subplot(323)
plot(vec_alpha,CY_vs_alpha); grid on
xlabel('alpha (deg)'); ylabel('CY (\beta = 0 deg)');
subplot(325)
plot(vec_alpha,CZ_vs_alpha); grid on
xlabel('alpha (deg)'); ylabel('CZ (\beta = 0 deg)');
subplot(322)
plot(vec_alpha,Cl_vs_alpha); grid on
xlabel('alpha (deg)'); ylabel('Cl (\beta = 0 deg)');
subplot(324)
plot(vec_alpha,Cm_vs_alpha); grid on
xlabel('alpha (deg)'); ylabel('Cm (\beta = 0 deg)');
subplot(326)
plot(vec_alpha,Cn_vs_alpha); grid on
xlabel('alpha (deg)'); ylabel('Cn (\beta = 0 deg)');

set(figure(2),'Position',[20 80 900 700]);
subplot(321)
plot(vec_beta,CX_vs_beta); grid on
xlabel('beta (deg)'); ylabel('CX (\alpha = 0 deg)');
subplot(323)
plot(vec_beta,CY_vs_beta); grid on
xlabel('beta (deg)'); ylabel('CY (\alpha = 0 deg)');
subplot(325)
plot(vec_beta,CZ_vs_beta); grid on
xlabel('beta (deg)'); ylabel('CZ (\alpha = 0 deg)');
subplot(322)
plot(vec_beta,Cl_vs_beta); grid on
xlabel('beta (deg)'); ylabel('Cl (\alpha = 0 deg)');
subplot(324)
plot(vec_beta,Cm_vs_beta); grid on
xlabel('beta (deg)'); ylabel('Cm (\alpha = 0 deg)');
subplot(326)
plot(vec_beta,Cn_vs_beta); grid on
xlabel('beta (deg)'); ylabel('Cn (\alpha = 0 deg)');

%% Linear Analysis - Long Dynamics

% Trim Condition

% u0    = 152.0888      % ft/s
% w0    =   7.9706      % ft/s
% h0    = 800.0000      % ft
% theta0 =  3.0000      % deg
% alpha0 =  3.0000      % deg
% V0    = 152.2975      % ft/s
% qbar0 =  24.4603      % psf

open_system('gtm_design_olp');
loadmws(mws_designpoint,'gtm_design_olp');

g       = 32.17;        % ft/s^2
w0      = 49.6;         % lbs
Iyy     = 4.2540;       % slug*ft^2
S       = 5.9018;       % ft^2
b       = 6.8488;       % ft
Cbar    = 0.9153;       % ft

u0    = 152.0888;      % ft/s
theta0 =  3.0000;      % deg
qbar0 =  24.4603;      % psf


% A-Matrix Entries

Cma = (-0.0526-0.1556)/((8-0)*pi/180);





% u, w, q, theta

Alon  =  [ ...
            [Xu         Xw        0       -m*g*cos(theta0)]/m;
            [Zu         Zw     Zu+m*u0   -m*g*sin(theta0)]/(m-Zwdot);
[Mu + Mwdot*Zu/(m-Zwdot)  Mw + Mwdot*Zw/(m-Zwdot) ...
   Mq + Mwdot*(Zq + m*u0)/(m-Zwdot)  -Mwdot*m*g*sin(theta0)/(m-Zwdot)]/Iy;
             [0          0        1         0];
         ];

     
     
     
     
     
     
     
     
     
     
     
     
     
     
     
