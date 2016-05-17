function save(this, varargin)

% === Inputs ==============================================================

p = inputParser;
addRequired(p, 'filename', @ischar);

parse(p, varargin{:});
in = p.Results;

% =========================================================================

% Initalization
s = '';

% --- Description
sec('Description', '');
nl();
add(this.Description);
nl();

add('################################################');
add('#   DO NOT MODIFY THIS FILE BEYOND THIS POINT  #');
add('################################################');
nl();

sec('Header');
nl();

add(['Version'  char(9) this.Version]);
add(['Study'    char([9 9]) this.Study]);
add(['Date'     char([9 9]) this.Date]);
add(['Run'     char([9 9]) this.RunName]);
nl();

% --- Images
sec('Images');

T = {'Camera' this.CameraModel ; ...
     'Fluo mode' this.FluoMode};

addTable(T, {'Param' 'Value'});

% --- Mirrors & piezo 
sec('Mirrors & piezo');

T = {'HM lower' this.HM_Position_min 'µm' ; ...
     'HM higher' this.HM_Position_max 'µm' ; ...
     'HM coeff' this.HM_um2V 'µm/V' ; ...
     'VM pos' this.VM_Position 'µm' ; ...
     'VM coeff' this.VM_um2V 'µm/V' ; ...
     'OP pos' this.OP_Position 'µm' ; ...
     'OP coeff' this.OP_um2V 'µm/V'};
 
addTable(T, {'Param' 'Value' 'Unit'});

% --- Light scan
sec('Light scan');

T = {'HM mode' this.HM_Mode '' ; ...
     'Scan shape' this.HM_Shape '' ; ...
     'HM rate' this.HM_Rate 'Hz'};
 
addTable(T, {'Param' 'Value' 'Unit'});

% --- Layers
sec('Layers');

T = {'Number of layers' this.NLayers ''; ...
     'Exposure' this.Exposure 'ms'; ...
	 'Delay' this.Delay 'ms'};

if str2double(this.NLayers)>1
    
    T = [T ; {'DelayLong' this.DelayLong 'ms'; ...
        'Steps shape' this.StepsShape '' ; ...
        'Increment' this.Increment 'µm' ; ...
        'Stab shape' this.StabShape ''; ...
        'Stab ratio' this.StabRatio '%'}];
    
end

addTable(T, {'Param' 'Value' 'Unit'});

% --- Timing
sec('Timing');

T = {'Number of cycles' this.NCycles ''; ...
     'Cycle time' this.CycleTime 'ms'; ...
     'Number of frames' this.NFrames ''; ...
     'Total time' this.RunTime 's'};

addTable(T, {'Param' 'Value' 'Unit'});

% --- Signals
sec('Signals');
nl();

add('# Settings');

% Digital signals
T = cell(0,3);
for i = 1:numel(this.Signals.DS)
    if ~isempty(this.Signals.DS(i).tstart)
        T{i,1} = 'Default';
        T{i,2} = ['DS' num2str(i)];
        T{i,3} = num2str(this.Signals.DS(i).default);
    end
end

if ~isempty(T)
    addTable(T, {'Tag' 'Slot' 'Value'});
end

add('# Digital Signals');

% Digital signals
T = cell(0,3);
for i = 1:numel(this.Signals.DS)
    if ~isempty(this.Signals.DS(i).tstart)
        for j = 1:numel(this.Signals.DS(i).tstart)
   
            T{end+1,1} = ['DS' num2str(i)];
            T{end,2} = num2str(this.Signals.DS(i).tstart(j));
            T{end,3} = num2str(this.Signals.DS(i).tstop(j)-this.Signals.DS(i).tstart(j));
            
        end
        
    end
end

if ~isempty(T)
    addTable(T, {'Slot' 'Tstart (s)' 'Duration (s)'});
end

% --- Save file
fid = fopen(in.filename, 'w');
fprintf(fid, '%s', s);
fclose(fid);

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
    function sec(txt, first)
        if ~exist('first', 'var')
            first = char([13 10]); 
        end
        tmp = ['# === ' txt ' '];
        s = [s first tmp repmat('=', [1 48-numel(tmp)])];
    end

    % --- Create table
    function addTable(T, Titles)
        
        nl();
        
        % Default titles
        if ~exist('Titles', 'var'), Titles = {}; end
        
        if isempty(Titles)
            CS = max(cellfun(@numel, T)+2,[],1);
        else
            Titles{1} = ['# ' Titles{1}];
            cS = cellfun(@numel, T)+2;
            TS = cellfun(@numel, Titles)+2;
            CS = max(TS, max(cS,[], 1));
        end
        
        % Display Titles
        if ~isempty(Titles)
            Row = '';
            for u = 1:numel(Titles)
                Row = [Row Titles{u} repmat(' ', [1 CS(u)-numel(Titles{u})])];
            end
            add(Row);
            add(['# ' repmat('-', [1 numel(Row)-4])]);
        end
        
        % Display Rows
        for k = 1:size(T,1)
            Row = '';
            for u = 1:size(T,2)
                Row = [Row T{k,u} repmat(' ', [1 CS(u)-numel(T{k,u})])];
            end
            add(Row);
        end
        
        nl();
    end
end