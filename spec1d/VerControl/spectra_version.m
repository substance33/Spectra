function varargout = spectra_version()
% returns the installed version of Spectra
%
% SPECTRA_VERSION()
%

% $Name: Spectra$ ($Version: 3.0$)
% $Author: S. Ward$ ($Contact: simon.ward@psi.ch$)
% $Revision: 1147 $ ($Date: 08-Feb-2017 $)
% $License: GNU GENERAL PUBLIC LICENSE$

% This has been modified from the spinW help file. Thanks to Sandor Toth!
% read file header from spectra_version.m file
fid = fopen('spectra_version.m');

% first line
fgets(fid);
% skip comments
fLine = strtrim(fgets(fid));
while numel(fLine)>0 && strcmp(fLine(1),'%')
    fLine = strtrim(fgets(fid));
end
% skip empty lines
while numel(fLine)==0 || ~strcmp(fLine(1),'%')
    fLine = strtrim(fgets(fid));
end
% read version information
verLine = {fLine};
while numel(verLine{end})>0 && strcmp(verLine{end}(1),'%')
    verLine{end+1} = strtrim(fgets(fid)); %#ok<*AGROW>
end
verLine = verLine(1:end-1);
fclose(fid);

% read strings enclosed with $ signs
partStr = {};
for ii = 1:numel(verLine)
    verSel = verLine{ii};
    while sum(verSel=='$') > 1
        [~, verSel] = strtok(verSel,'$'); %#ok<*STTOK>
        [partStr{end+1}, verSel] = strtok(verSel,'$');
    end
    
end

nField = numel(partStr);
fieldName = cell(1,nField);
fieldVal = cell(1,nField);

verStruct = struct;

% extract values and save them into a structure
for ii = 1:nField
    [fieldName{ii}, fieldVal{ii}] = strtok(partStr{ii},':');
    fieldVal{ii} = strtrim(fieldVal{ii}(2:end));
    verStruct.(fieldName{ii}) = fieldVal{ii};
end


if nField == 0
    aDir = pwd;
    cd(sw_rootdir);
    [~, revNum] = system('git rev-list --count HEAD');
    revNum = strtrim(revNum);
    %[~, revNum] = system('svn info |grep Revision: |cut -c11-');
    cd(aDir);
    revNum = str2double(revNum)+1e3;
end

if nargout == 0
    if nField == 0
        if any(revNum)
            fprintf('This version of Spectra (rev. num. %d) is not released yet!\n',revNum);
        else
            fprintf('This version of Spectra is not released yet!\n');
        end
    else
        disp([verStruct.Name verStruct.Version ' (rev ' num2str(verStruct.Revision) ')']);
        onlineRev = sw_update;
        if onlineRev > str2num(verStruct.Revision) %#ok<ST2NM>
            disp(['Newer version of Spectra is available online (rev. num. ' num2str(onlineRev) '), use the spectra_update() function to download it!']);
        else
            disp('You have the latest version of Spectra!')
        end
    end
    fprintf(['MATLAB version: ' version '\n']);
    
else
    ver0 = struct;
    ver0.Name     = 'Spectra';
    ver0.Version  = '';
    ver0.Author   = 'S. Ward';
    ver0.Contact  = 'simon.ward@psi.ch';
    ver0.Revision = '';
    ver0.Date     = datestr(now,'dd-mmm-yyyy');
    ver0.License  = 'GNU GENERAL PUBLIC LICENSE';

    if nField == 0
        if any(revNum)
            ver0.Revision = num2str(revNum);
        end
        varargout{1} = ver0;
    else
        if isempty(fieldnames(verStruct))
            varargout{1} = ver0;
        else
            varargout{1} = verStruct;
        end
    end
end

end