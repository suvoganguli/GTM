function [pwmlo, pwmhi, SurfaceLimits, RateLimits] = Cal_Limits(); 
%function [pwmlo, pwmhi, SurfaceLimits, RateLimits] = Cal_Limits(); 

% Lower and Upper PWM limits for saturation block contained with the Uplink Packing block
% low limits and high limits have been modified according to the S2_limits block which was eliminated.  (WGR 10/23/08)
pwmlo.AILLC = 1030;    pwmhi.AILLC = 1900;
pwmlo.AILRC = 1030;    pwmhi.AILRC = 1900;
pwmlo.SPLLIBC = 1000;  pwmhi.SPLLIBC = 2000;
pwmlo.SPLLOBC = 1000;  pwmhi.SPLLOBC = 2000;
pwmlo.SPLRIBC = 1000;  pwmhi.SPLRIBC = 2000;
pwmlo.SPLROBC = 1000;  pwmhi.SPLROBC = 2000;
pwmlo.ELLOBC = 1000;   pwmhi.ELLOBC = 2000;
pwmlo.ELLIBC = 1000;   pwmhi.ELLIBC = 2000;
pwmlo.ELROBC = 1000;   pwmhi.ELROBC = 2000;
pwmlo.ELRIBC = 1000;   pwmhi.ELRIBC = 2000;
pwmlo.RUDUPC = 1160;   pwmhi.RUDUPC = 1840;
pwmlo.RUDLOC = 1160;   pwmhi.RUDLOC = 1840;
pwmlo.THROTLC = 1330;  pwmhi.THROTLC = 1920;
pwmlo.THROTRC = 1330;  pwmhi.THROTRC = 1920;
pwmlo.GEARC = 1250;    pwmhi.GEARC = 1730;
pwmlo.LINK0 = 0;       pwmhi.LINK0 = 4000;
pwmlo.FLAPLIC = 1470;  pwmhi.FLAPLIC = 1916;
pwmlo.FLAPLOC = 1470;  pwmhi.FLAPLOC = 1916;
pwmlo.FLAPRIC = 1470;  pwmhi.FLAPRIC = 1916;
pwmlo.FLAPROC = 1470;  pwmhi.FLAPROC = 1916;
pwmlo.BRAKAC = 1000;   pwmhi.BRAKAC = 2000;
pwmlo.STEERC = 1000;   pwmhi.STEERC = 2000;
pwmlo.ENGMLC = 1000;   pwmhi.ENGMLC = 2000;
pwmlo.ENGMRC = 1000;   pwmhi.ENGMRC = 2000;
pwmlo.PWM24 = 1000;    pwmhi.PWM24 = 2000;
pwmlo.PWM25 = 1000;    pwmhi.PWM25 = 2000;
pwmlo.PWM26 = 1000;    pwmhi.PWM26 = 2000;
pwmlo.PWM27 = 1000;    pwmhi.PWM27 = 2000;
pwmlo.PWM28 = 1000;    pwmhi.PWM28 = 2000;
pwmlo.PWM29 = 1000;    pwmhi.PWM29 = 2000;
pwmlo.PWM30 = 1000;    pwmhi.PWM30 = 2000;
pwmlo.LINK1 = 0;       pwmhi.LINK1 = 4000;

%%%% Control surface position and rate limits, columns ordered as follows. First
% row is the lower limit, second row is the upper limit.

SurfaceLimits.THROTLC = [  0;100];
SurfaceLimits.THROTRC = [  0;100];
SurfaceLimits.ELLOBC  = [-30; 20];
SurfaceLimits.ELLIBC  = [-30; 20];
SurfaceLimits.ELROBC  = [-30; 20];
SurfaceLimits.ELRIBC  = [-30; 20];
SurfaceLimits.AILLC   = [-20; 20];
SurfaceLimits.SPLLOBC = [  0; 45];
SurfaceLimits.SPLLIBC = [  0; 45];
SurfaceLimits.SPLRIBC = [  0; 45];
SurfaceLimits.SPLR0BC = [  0; 45];
SurfaceLimits.AILRC   = [-20; 20];
SurfaceLimits.RUDUPC  = [-30; 30];
SurfaceLimits.RUDLOC  = [-30; 30];
SurfaceLimits.FLAPLOC = [  0; 45];
SurfaceLimits.FLAPLIC = [  0; 45];
SurfaceLimits.FLAPROC = [  0; 45];
SurfaceLimits.FLAPRIC = [  0; 45];
SurfaceLimits.GEARC   = [  0;  1];

% Rate limits (degrees/second)
RateLimits.THROTLC = [-Inf;Inf];
RateLimits.THROTRC = [-Inf;Inf];
RateLimits.ELLOBC  = [-150;150];
RateLimits.ELLIBC  = [-150;150];
RateLimits.ELROBC  = [-150;150];
RateLimits.ELRIBC  = [-150;150];
RateLimits.AILLC   = [-150;150];
RateLimits.SPLLOBC = [-150;150];
RateLimits.SPLLIBC = [-150;150];
RateLimits.SPLRIBC = [-150;150];
RateLimits.SPLR0BC = [-150;150];
RateLimits.AILRC   = [-150;150];
RateLimits.RUDUPC  = [-150;150];
RateLimits.RUDLOC  = [-150;150];
RateLimits.FLAPLOC = [-150;150];
RateLimits.FLAPLIC = [-150;150];
RateLimits.FLAPROC = [-150;150];
RateLimits.FLAPRIC = [-150;150];
RateLimits.GEARC   = [-Inf;Inf];

