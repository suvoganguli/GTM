function removeAllCbs

% find the libaries that are being used in the model
info = libinfo(bdroot);
libs = unique({info.Library});

% remove built-in and libaries from the list
paths = cellfun(@which, libs,'UniformOutput', false);
removeBuiltins = @(p) ~strcmpi(matlabroot, p(1:length(matlabroot)));

idxKeep = cellfun(removeBuiltins, paths);
libs = libs(idxKeep);

% loop through the libraries
for libIdx = 1:length(libs)
  
  % load the current library and get all of its blocks
  load_system(libs{libIdx});
  set_param(libs{libIdx}, 'Lock', 'off'); % unlock library
  blks = find_system(libs{libIdx});
  
  % loop through the blocks in the library
  for blkIdx = 1:length(blks)
    try 
      % find out if block has a initialization function in the mask. If it
      % doesn't this will error out to the 'catch' part, and just not do
      % anything to the current block
      maskCB = get_param(blks{blkIdx},'MaskInitialization'); % save it
    
      % has one, so remove it from the initialization function
      set_param(blks{blkIdx}, 'MaskInitialization','');
      
      % append it to the model callback with
      mdlCB = get_param(bdroot, 'InitFcn');
      set_param(bdroot, 'InitFcn', cat(2,mdlCB,maskCB));
       
    % else
    catch
          % do nothing, but something else could be added here
    end
    
  end
  
  % save, lock, and close system 
  save_system(libs{libIdx});
  set_param(libs{libIdx}, 'Lock', 'on');
  close_system(libs{libIdx});
end