function newRun(this, varargin)

% --- File path and name

% Date path
slist = get(this.UI.Study, 'String');
dpath = [get(this.UI.Root, 'String') filesep ...
    slist{get(this.UI.Study, 'Value')} filesep ...
    get(this.UI.Date, 'String')];
if ~exist(dpath, 'dir'), mkdir(dpath); end

% Run path
D = dir([dpath filesep 'Run*']);
id = numel(D)+1;
rpath = [dpath filesep 'Run' num2str(id, '%02i')];
if ~exist(rpath, 'dir')
    mkdir([rpath filesep 'Images']);
end

% Refresh runs
this.refreshRuns;

% Select the last run
this.selectRun(id);

% jUIScrollPane = findjobj(this.UI.Runs);
% jUITable = jUIScrollPane.getViewport.getView;
% jUITable.changeSelection(id-1,0, false, false);