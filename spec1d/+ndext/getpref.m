function rPref = getpref(prefName)
% returns specnd global preferences
%
% rPref = ndext.getpref
%
% Returns the names, values and labels of each preferences. Default values
% are returned, where no value is saved. rPref is a struct with field names
% 'name', 'label' and 'val'. Each field is a cell.
%
% rPref = ndext.getpref(pName)
%
% Returns only the requested specnd preference name, value and label. Each
% field contains the requested value.
%
% rPref = ndext.getpref('default')
%
% Returns the default names, values and labels of each preferences.
%
% See also ndext.setpref.
%
% Branched from specnd 
%
% default values
dn = { 'libroot'                  'experimental' 'doLog'};
dv = { fileparts(fileparts(pwd))  0              1};
dl = {...
    'Where Spectra files are stored'...
    'Enable experiemntal features'...
    'Log all interactions'
    };

dPref = struct('val',{},'name',{},'label',{});

[dPref(1:numel(dv),1).name] = dn{:};
[dPref(:).label]          = dl{:};
[dPref(:).val]            = dv{:};

% get stored preferences
sPref = getpref('mtools');

if (nargin>0)
    if strcmp(prefName,'default')
        % return default preference values
        rPref = dPref;
        return
    end
    
    % if a specific value is requested, check if it exist in the default value
    % list
    
    iPref = find(strcmp(prefName,{dPref(:).name}),1);
    if isempty(iPref)
        error('spectra:getndpref:WrongName','The requested spectra preference does not exist!');
    end
    
    % if a specific value is requested and it exists, return it
    rPref = dPref(iPref);
    
    if isfield(sPref,prefName)
        rPref.val = sPref.(prefName);
    end
    
    return
else
    % return all stored values
    rPref = dPref;
    % overwrite default values for existing preferences
    if ~isempty(sPref)
        fPref = fieldnames(sPref);
        for ii = 1:numel(fPref)
            rPref(strcmp(fPref{ii},{dPref(:).name})).val = sPref.(fPref{ii});
        end
    end
    
end

end