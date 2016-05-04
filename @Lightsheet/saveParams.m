function saveParams(this, varargin)

% --- Check that a run is selected
if isempty(this.Run)
    
    % Create new run ?
    switch questdlg('No run is selected. Would you like to create a new run ?', ...
        'Create run ?', 'Yes', 'No', 'Yes')
    
        case 'Yes'
            this.newRun;
            
        case 'No'
            return
    end
    
end

% --- Get file path
fname = [this.Run.Path filesep 'Parameters.txt'];

% --- File header
slist = get(this.UI.Study, 'String');
s = ['# ' slist{get(this.UI.Study, 'Value')} ' - ' ...
      get(this.UI.Date, 'String') ' - ' this.Run.Name];
nl();
add(['Version ' this.Version]);
nl();
add('###############################');
add('#   DO NOT MODIFY THIS FILE   #');
add('###############################');
nl();

% --- Images
sec('Images');

% Camera
list = get(this.UI.Model, 'String');
add(['Camera' char(9) list{get(this.UI.Model, 'Value')}]);

% Fluo mode
list = get(this.UI.FluoMode, 'String');
add(['Fluo mode' char(9) list{get(this.UI.FluoMode, 'Value')}]);
nl();

% --- Mirrors & piezo 
sec('Mirrors & piezo');

% Horizontal mirror
add(['HM lower' char(9) get(this.UI.HM_Position_min, 'String') ' µm']);
add(['HM higher' char(9) get(this.UI.HM_Position_max, 'String') ' µm']);
add(['HM coeff' char(9) get(this.UI.HM_um2V, 'String') ' µm/V']);
nl();

% Vertical mirror
add(['VM pos' char(9) get(this.UI.VM_Position, 'String') ' µm']);
add(['VM coeff' char(9) get(this.UI.VM_um2V, 'String') ' µm/V']);
nl();

% Objective piezo
add(['OP pos' char(9) get(this.UI.OP_Position, 'String') ' µm']);
add(['OP coeff' char(9) get(this.UI.OP_um2V, 'String') ' µm/V']);
nl();

% --- Light scan
sec('Light scan');

% HM mode
add(['HM mode' char(9) get(get(this.UI.HM_Mode, 'SelectedTab'), 'Title')]);

% Scan shape
list = get(this.UI.HM_Shape, 'String');
add(['Scan shape' char(9) list{get(this.UI.HM_Shape, 'Value')}]);

% HM frequency
add(['HM Frequency' char(9) get(this.UI.HM_Rate, 'String') ' Hz']);
nl();

% --- Layers
sec('Layers');

add(['Number of layers' char(9) get(this.UI.NLayers, 'String')]);
add(['Exposure' char(9) get(this.UI.Exposure, 'String') ' ms']);
add(['Delay' char(9) get(this.UI.Delay, 'String') ' ms']);

NLayers = str2double(get(this.UI.NLayers, 'String'));
if NLayers>1
    
    add(['DelayLong' char(9) get(this.UI.DelayLong, 'String') ' ms']);    
    
    % Steps shape
    list = get(this.UI.StepsShape, 'String');
    add(['Steps shape' char(9) list{get(this.UI.StepsShape, 'Value')}]);
    
    % Increments
    add(['Increment' char(9) get(this.UI.Increment, 'String') ' µm']);
    
    % Stabilization
    list = get(this.UI.StabShape, 'String');
    add(['Stab shape' char(9) list{get(this.UI.StabShape, 'Value')}]);
    add(['Stab Ratio' char(9) get(this.UI.StabRatio, 'String') ' %']);
    
end
nl();

% --- Timing
sec('Timing');

add(['Number of cycles' char(9) get(this.UI.NCycles, 'String')]);
add(['Cycle time' char(9) get(this.UI.CycleTime, 'String') ' ms']);
add(['Number of frames' char(9) get(this.UI.NFrames, 'String')]);
add(['Total time' char(9) get(this.UI.RunTime, 'String') ' s']);
nl();

% --- Inputs
% TO DO

% --- Commands
sec('Signals');

% --- Save file
fid = fopen(fname, 'w');
fprintf(fid, '%s', s);
fclose(fid);

% --- Refresh Runs
this.refreshRuns;

% === Nested functions ====================================================

    % --- Add text
    function add(txt)
        s = [s char([13 10]) txt];
    end

    % --- Add new line
    function nl()
        s = [s char([13 10])];
    end

    % --- Add section title
    function sec(txt)
        s = [s char([13 10]) '# --- ' txt ' ---'];
    end


end