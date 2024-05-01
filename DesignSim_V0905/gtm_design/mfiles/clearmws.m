function clearmws(model);
%function clearmws(model);
%
% Clears the current model workspace.
%  
% Inputs:
%    model   - name of model, defaults to 'gtm_design'
%  

% d.e.cox@larc.nasa.gov
% $Id: clearmws.m 373 2007-07-25 03:22:47Z cox $

% By default use the bdroot model
if ( ~exist('model','var') || isempty(model) ),
  model=bdroot;
end

mws=get_param(model,'modelworkspace');
mws.clear;


