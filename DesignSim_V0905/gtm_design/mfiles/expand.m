function expand(structure);
%function expand(structure);
%
% Given a data structure this expands each field into
% a separate named variable in the callers workspace
%

% d.e.cox@larc.nasa.gov
% $Id: expand.m 382 2007-07-25 19:16:00Z cox $

if ~isstruct(structure), 
  error('Input should be data structure'),
end
%
names=fieldnames(structure);
for i=[1:length(names)],
  if isstruct(structure.(names{i})),
    fprintf(1,'Skipping field: ''%s'',  Cannot expand multi-level structures\n',names{i});
  else
    assignin('caller',names{i},structure.(names{i}));
  end
end
