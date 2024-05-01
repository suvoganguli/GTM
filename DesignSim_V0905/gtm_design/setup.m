% d.e.cox@larc.nasa.gov
% $Id: setup.m 437 2008-02-19 19:34:33Z cox $

model = 'gtm_design';

% Add local dir's to matlab path
path('./mfiles',path);
path('../libs',path);
path('./userfiles',path);  % suvo - 8/25/09
path('./examples',path);  % suvo - 8/26/09
rehash path

% Check matlab version, warn if old
if ( verLessThan('matlab','7.7') || verLessThan('simulink','7.2') ),
  fprintf(1,'Simulation was developed in Matlab-R2008b, older versions are not recommended\n\n');
  pause(2);
end

% Close model if open, prompt if changed.
if  not(isempty(find_system('SearchDepth',0,'Name',model)))
    if strcmp(get_param(model,'Dirty'),'on');
        savechanges=input('  gtm_design model has been changed, save changes (y/N) ?','s');
        if ~isempty(savechanges) && strcmpi(savechanges(1),'y');
	  fprintf(1,'Saving System...');
	  clearmws % Suppreses warning mesage about model workspace
	  clear savechanges % clear temporary response variable
	  save_system(model);
	  fprintf(1,' Done.\n');
        end
    end
    % terminate if left in paused state. matlab will not close paused model.
    if strcmp(get_param(model,'SimulationStatus'),'paused'),
        gtm_design([],[],[],'term');
    end
    bdclose(model);
end

% Clear simout* variables to ensure clean initialization
clear simout simout_names SimWSout

% Clear precompiled functions, required to reflect changes in mfiles
% that exist outside working directory.
clear functions

% Open block diagram
warning('off','Simulink:SL_MdlFileNotOnPath'); % Suppress spurious warnings
open_system(model);  
set_param(model, 'InitInArrayFormatMsg', 'None')

% load nominal starting point
loadmws(init_design('GTM'),model);

% -----------------------------
% debug during call to Mathworks

save_system(model);
mws2 = trimgtm(struct('eas',75, 'gamma',0));

% -----------------------------

% Trim model, and load trimmed conditions
appendmws(trimgtm(struct('eas',75, 'gamma',0)));

warning('on','Simulink:SL_MdlFileNotOnPath');






