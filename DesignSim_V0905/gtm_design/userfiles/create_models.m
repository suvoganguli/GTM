%
%-------- Create models ----------
%
% Create multiple trimmed models
% with varying speed and save all in a 
% data structure.

% $ create_models - 8/25/09 $
% subhabrata.ganguli@honeywell.com

%% initial setup

setup

%% trim points

modeldata = [];

% Trim to set of equivalent air speeds
% speeds=[[37:5:57],[60:10:140]];
speeds = [60:10:140];

% Allocate variables to plot
alpha=zeros(length(speeds),1);
elevator=zeros(length(speeds),1);
throttle=zeros(length(speeds),1);

% Compute trim points
MWS=init_design();
fprintf('\nLevel Flight Trim\n  Trimming at eas:\n');
for trimpt=[1:length(speeds)],
  fprintf(1,'     %3.2f,',speeds(trimpt));
  loadmws(MWS,'gtm_design'); 
  [MWS,Xt,Tc,Err]=trimgtm(struct('eas',speeds(trimpt),'gamma',0), 'elev', 0);
  if (Err>1e-3),  % try again, different starting poing
      loadmws(init_design(),'gtm_design');
      fprintf('   Poor convergence, trying again. ');
      [MWS,Xt,Tc,Err]=trimgtm(struct('eas',speeds(trimpt),'gamma',0), 'elev', 0);
      if (Err>1e-3)  % No joy, skip point.
          Tc=struct('alpha',NaN,'elevator',NaN,'throttle',NaN);
          fprintf(1,'Failed to Trim  ');
          else fprintf(1,'Done  ');
      end
  end
  fprintf(1,' Residual=%3.2e\n',Err);

  eval(['modeldata.tp' num2str(trimpt) ' = MWS;']);
  
end
fprintf(' Done\n');