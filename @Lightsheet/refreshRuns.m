function refreshRuns(this, varargin)

% --- Path
slist = get(this.UI.Study, 'String')
path = [get(this.UI.Root, 'String') filesep ...
    slist{get(this.UI.Study, 'Value')} filesep ...
    get(this.UI.Date, 'String')];

path
D = dir(path);
if isempty(D)
    warning('Lightsheet:EmptyDir', 'Empty directory.');
    return
end
D(1:2) = [];
Data = {};
for i = 1:numel(D)
    
     if ismember(D(i).name, {'log.txt'})
         continue
     end
    
    % Name
    Data{i,1} = D(i).name;
    
    % Parameters
    Data{i,2} = logical(exist([path filesep D(i).name filesep 'Parameters.txt'], 'file'));
    
    % Fluo
    Data{i,3} = false;
    Data{i,4} = false;
    Data{i,5} = false;
end

set(this.UI.Runs, 'Data', Data);

% Select the current
% if ~isempty(this.Run)
%     jUIScrollPane = findjobj(this.UI.Runs);
%     jUITable = jUIScrollPane.getViewport.getView;
%     jUITable.changeSelection(this.Run.Id-1,0, false, false);
% end