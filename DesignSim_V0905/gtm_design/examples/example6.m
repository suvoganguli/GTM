%
%--------------- During 45 degree bank angle turn incur damage------------------ 
%
% Script trims to a climbing 45 degree bank angle turn then simulates 
% each preprogramed  failure condition.  


% $Id$
% david.e.cox@.nasa.gov


% Load nominal starting parameter set
MWS_Nominal=init_design();

% Set nominal trim to climbing turn
MWS_Nominal.DamageCase=0;
MWS_Nominal.DamageOnsetTime=120;
loadmws(MWS_Nominal);
[MWS_Nominal,Xtrim,Fcond,Err]=trimgtm(struct('eas',95, 'gamma',3,...
                                             'yawrate',[],'roll',45));

% Set desired workspace outputs.
% This is usually just done in block diagram but
% the "batch way" is show here for illustration
%
% Preserve original output set.
WSout_orig=get_param('gtm_design/SelectOutputs','OutputSignals');
WSout_expd=get_param('gtm_design/NamedStore','expand');

% Set workspace outputs (alt,lat,lon)
sigsout=strcat(...
    'eom.altitude,eom.latitude,eom.longitude,',...
    'aux.alpha,aux.beta,aux.gamma,aux.eas,',...
    'eom.pb,eom.qb,eom.rb,eom.phi,eom.theta,eom.psi');
set_param('gtm_design/SelectOutputs','OutputSignals',sigsout);
% Set block to expand into  named variables on termination
set_param('gtm_design/NamedStore','expand','on');


% Simulate fligth without damage
loadmws(MWS_Nominal);
fprintf(1,'Simulating...');
sim('gtm_design',[0 15]);
fprintf(1,'Done\n');
tout1=tout;Lon1=longitude*180/pi; Lat1=latitude*180/pi; Alt1=altitude; 
eas1=eas;alpha1=alpha; beta1=beta; gamma1=gamma; pqr1=180/pi*[pb qb rb];
phi1=180/pi*phi;theta1=180/pi*theta;psi1=180/pi*psi;

% Simlate each damage case and plot
for i=[1:length(MWSout.Aero.dC6_damage.cases)],
  % Simulate flight with Damage
  % Set Damage Conditions
  MWS_Damage=MWS_Nominal;
  MWS_Damage.DamageCase=i;
  MWS_Damage.DamageOnsetTime=10;
  %MWS_Damage.Aero.dC6_damage.ddscale.data=ones(18,6,3,6);
  loadmws(MWS_Damage);
  fprintf(1,'Simulating...');
  fprintf(1,'Done\n');
  sim('gtm_design',[0 15]);
  tout2=tout;Lon2=longitude*180/pi; Lat2=latitude*180/pi; Alt2=altitude; 
  eas2=eas;gamma2=gamma;alpha2=alpha;beta2=beta;pqr2=180/pi*[pb qb rb];
  phi2=180/pi*phi;theta2=180/pi*theta;psi2=180/pi*psi;
  % Plot
  % ------------------------Plots---------------------------
  h=figure(1);,set(h,'Position',[20,20,1000,800]);clf
  % Alpha/Beta
  ax=axes('position',[.05 .70 .2 .2]);
  plot(tout2,[alpha2,beta2]);
  legend({'\alpha','\beta'},'Location','SouthWest');,grid on
  xlabel('time (sec)'),
  ylabel('\alpha (deg), \beta (deg)');
  %set(ax,'Ylim',[-10 20]);
  title('Alpha/Beta');
  
  % Flight Path Angle and Airspeed
  axes('position',[.05 .40 .2 .2]);
  [ax,h1,h2]=plotyy(tout2,gamma2,tout2,eas2);grid on
  xlabel('time (sec)'),
  ylabel(ax(1),'Flight Path,  \gamma (deg)');
  ylabel(ax(2),'Equivalent Airspeed (konts)')
  legend([h1;h2],{'\gamma','eas'},'Location','SouthWest');
  title('Flight Path Angle and Airspeed');
  
  % Angular Rates
  ax=axes('position',[.05 .10 .2 .2]);
  plot(tout2,pqr2);grid on
  legend({ 'p','q','r'},'Location','SouthWest');
  xlabel('time (sec)'),ylabel('angular rates (deg/sec)')
  %set(ax,'Ylim',[-15 15]);
  title('Angular Rates');
  
  % Euler Angles
  ax=axes('position',[.50 .70 .45 .2]);
  plot(tout2,[phi2,theta2,psi2]);
  legend({'roll','pitch','yaw'},'Location','SouthWest');,grid on
  xlabel('time (sec)'),
  ylabel('\phi (deg), \theta (deg), \psi (deg)');
  %set(ax,'Ylim',[-10 20]);
  title('Euler Angles');
  
  % Trajectory: 3D plot with orientated vehicle
  ax=axes('position',[.50,.1,.45,.45]);
  titlestr=sprintf('Nominal and DamageCase:%s',...
                   strrep(MWSout.Aero.dC6_damage.cases{MWSout.DamageCase},'_','\_'));;
  h1=plot3(Lat1,Lon1,Alt1','b'); grid on,hold on
  h2=plot3(Lat2,Lon2,Alt2','r'); 
  legend([h1 h2],{'Nominal Flight Path','Damage Flight Path'},...
         'Location','NorthWest');
  title(titlestr);
  xlabel('Latitude (deg)'),ylabel('Longitude (deg)'),zlabel('Altitude (ft)');
  view(-45,5);set(ax,'Zlim',[600 1000]);
  if (exist('AutoRun','var'))
     pause(.2);
     orient portrait
     eval(sprintf('print -dpng exampleplot06-%d',i));
  else
    fprintf(1,'Finished Damage Case %d, Hit Return to Continue...',i),pause,fprintf(1,'.\n');
  end
end

% Restore original signal set to SelectOutputs block
set_param('gtm_design/SelectOutputs','OutputSignals',WSout_orig);
set_param('gtm_design/NamedStore','expand',WSout_expd);



