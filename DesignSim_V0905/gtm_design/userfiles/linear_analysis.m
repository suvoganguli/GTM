
% Trim Condition

% u0    = 152.0888      % ft/s
% w0    =   7.9706      % ft/s
% h0    = 800.0000      % ft
% theta0 =  3.0000      % deg
% alpha0 =  3.0000      % deg
% V0    = 152.2975      % ft/s
% rho0  = 

g       = 32.17;        % ft/s^2
w0      = 49.6;         % lbs
Iyy     = 4.2540;       % slug*ft^2
S       = 5.9018;       % ft^2
b       = 6.8488;       % ft
Cbar    = 0.9153;       % ft

CX      = 
CZ      = 
Cm      = 

NDscl   = 0.5*rho*V0^2*S;






% u, w, q, theta

Alon  =  [ ...
            [Xu         Xw        0       -m*g*cos(theta0)]/m;
            [Zu         Zw     Zu+m*u0   -m*g*sin(theta0)]/(m-Zwdot);
[Mu + Mwdot*Zu/(m-Zwdot)  Mw + Mwdot*Zw/(m-Zwdot) ...
   Mq + Mwdot*(Zq + m*u0)/(m-Zwdot)  -Mwdot*m*g*sin(theta0)/(m-Zwdot)]/Iy;
             [0          0        1         0];
         ];
       