function load(this, varargin)

% === Inputs ==============================================================

try
    p = inputParser;
    addOptional(p, 'filename', '', @ischar);
    addParameter(p, 'LengthUnit', this.Units.Length, @(x) ismember(x, {'m', 'mm', 'um', 'µm'}));
    addParameter(p, 'TimeUnit', this.Units.Time, @(x) ismember(x, {'s', 'ms'}));
    addParameter(p, 'FrequencyUnit', this.Units.Frequency, @(x) ismember(x, {'Hz'}));
    parse(p, varargin{:});
    in = p.Results;
catch
    in = struct('filename', '', ...
        'LengthUnit', 'µm', ...
        'TimeUnit', 'ms', ...
        'FrequencyUnit', 'Hz');
end

% === Checks ==============================================================

if isempty(in.filename)
    tmp = uigetfile('*.txt', 'Select a parameter file');
    if ischar(tmp)
        in.filename = tmp;
    else
        return
    end
end

% === File parsing ========================================================

% --- Get file content ----------------------------------------------------
fid = fopen(in.filename);
tmp = textscan(fid, '%s', 'delimiter', '\n');
fclose(fid);
File = tmp{1};

% --- Initialization ------------------------------------------------------

this.Signals = struct();
this.Signals.DS = struct('tstart', {}, 'tstop', {}, 'default', {});

% --- Parse file ----------------------------------------------------------

mode = '';

for i = 1:numel(File)
    
    % --- Get line
    line = File{i};
    
    % --- Skip empty lines
    if isempty(line), continue; end
    
    % --- Comments
    if strcmp(line(1), '#')
        
        % Check for sections
        res = regexp(line, '^# === (.*) =+$', 'tokens');
        if ~isempty(res)
            mode = res{1}{1};
        end
        
        continue;
    end
    
    switch mode
        
        case 'Description'
            
            if isempty(this.Description)
                this.Description = line;
            else
                this.Description = [this.Description char(10) line];
            end
            
            if isempty(File{i+1}) % || ~strcmp(File{i+1}(1), '#')
                this.Description = [this.Description char(10)];
            end
            
        case 'Header'
            
            % Version
            res = regexp(line, '^Version\t+([\d\.]+)$', 'tokens');
            if ~isempty(res)
                this.Version = res{1}{1};
            end
            
            % Study
            res = regexp(line, '^Study\t+(.+)$', 'tokens');
            if ~isempty(res)
                this.Study = res{1}{1};
            end
            
            % Date
            res = regexp(line, '^Date\t+([\d\-]+)$', 'tokens');
            if ~isempty(res)
                this.Date = res{1}{1};
            end
            
            % Run
            res = regexp(line, '^Run\t+(.+)', 'tokens');
            if ~isempty(res)
                this.RunName = res{1}{1};
            end
            
        case 'Images'
            
            % Camera model
            res = regexp(line, '^Camera +(.+)', 'tokens');
            if ~isempty(res)
                this.CameraModel = strtrim(res{1}{1});
            end
            
            % Fluo mode
            res = regexp(line, '^Fluo mode +(.+)', 'tokens');
            if ~isempty(res)
                this.FluoMode = strtrim(res{1}{1});
            end
            
        case 'Mirrors & piezo'
            
            % --- Horizontal mirror
            
            % Minimum position
            res = regexp(line, '^HM lower\s+([\-\d\.]+)\s+(\S+)', 'tokens');
            if ~isempty(res)                
                this.HM_Position_min = convert(res, in.LengthUnit);
            end
            
            % Maximum position
            res = regexp(line, '^HM higher\s+([\-\d\.]+)\s+(\S+)', 'tokens');
            if ~isempty(res)                
                this.HM_Position_max = convert(res, in.LengthUnit);
            end
            
            % Position
            res = regexp(line, '^HM pos\s+([\-\d\.]+)\s+(\S+)', 'tokens');
            if ~isempty(res)                
                this.HM_Position = convert(res, in.LengthUnit);
            end
            
            % Coefficient
            res = regexp(line, '^HM coeff\s+([\-\d\.]+)\s+(\S+)', 'tokens');
            if ~isempty(res)                
                this.HM_um2V = convert(res, [in.LengthUnit '/V']);
            end
            
            % Symmetrize
            res = regexp(line, '^HM symmetrize\s+(.+)', 'tokens');
            if ~isempty(res)                
                switch res{1}{1}
                    case 'true'
                        this.HM_Symmetrize = true;
                    case 'false'
                        this.HM_Symmetrize = false;
                end
            end
            
            % --- Vertical mirror
            
            % Position
            res = regexp(line, '^VM pos\s+([\-\d\.]+)\s+(\S+)', 'tokens');
            if ~isempty(res)                
                this.VM_Position = convert(res, in.LengthUnit);
            end
            
            % Coefficient
            res = regexp(line, '^VM coeff\s+([\-\d\.]+)\s+(\S+)', 'tokens');
            if ~isempty(res)                
                this.VM_um2V = convert(res, [in.LengthUnit '/V']);
            end
            
            % --- Objective piezo
            
            % Position
            res = regexp(line, '^OP pos\s+([\-\d\.]+)\s+(\S+)', 'tokens');
            if ~isempty(res)                
                this.OP_Position = convert(res, in.LengthUnit);
            end
            
            % Coefficient
            res = regexp(line, '^OP coeff\s+([\-\d\.]+)\s+(\S+)', 'tokens');
            if ~isempty(res)                
                this.OP_um2V = convert(res, [in.LengthUnit '/V']);
            end
            
        case 'Light scan'
            
            % HM mode
            res = regexp(line, '^HM mode +(.+)', 'tokens');
            if ~isempty(res)
                this.HM_Mode = strtrim(res{1}{1});
            end
            
            % HM shape
            res = regexp(line, '^Scan shape +(.+)', 'tokens');
            if ~isempty(res)
                this.HM_Shape = strtrim(res{1}{1});
            end
            
            % HM rate
            res = regexp(line, '^HM rate\s+([\-\d\.]+)\s+(\S+)', 'tokens');
            if ~isempty(res)                
                this.HM_Rate = convert(res, in.FrequencyUnit);
            end
            
        case 'Layers'
            
            % Number of layers
            res = regexp(line, '^Number of layers\s+([\-\d\.]+)', 'tokens');
            if ~isempty(res)                
                this.NLayers = str2double(res{1}{1});
            end
            
            % Exposure
            res = regexp(line, '^Exposure\s+([\-\d\.]+)\s+(\S+)', 'tokens');
            if ~isempty(res)                
                this.Exposure = convert(res, in.TimeUnit);
            end
            
            % Delay
            res = regexp(line, '^Delay\s+([\-\d\.]+)\s+(\S+)', 'tokens');
            if ~isempty(res)                
                this.Delay = convert(res, in.TimeUnit);
            end
            
            % Delay Long
            res = regexp(line, '^DelayLong\s+([\-\d\.]+)\s+(\S+)', 'tokens');
            if ~isempty(res)                
                this.DelayLong = convert(res, in.TimeUnit);
            end
            
            % Steps shape
            res = regexp(line, '^Steps shape +(.+)', 'tokens');
            if ~isempty(res)
                this.StepsShape = strtrim(res{1}{1});
            end
            
            % Increments
            res = regexp(line, '^Increment\s+([\-\d\.]+)\s+(\S+)', 'tokens');
            if ~isempty(res)                
                this.Increment = convert(res, in.LengthUnit);
            end
            
            % Stab shape
            res = regexp(line, '^Stab shape +(.+)', 'tokens');
            if ~isempty(res)
                this.StabShape = strtrim(res{1}{1});
            end
            
            % Stab ratio
            res = regexp(line, '^Stab ratio\s+([\-\d\.]+)\s+%', 'tokens');
            if ~isempty(res)                
                this.StabRatio = str2double(res{1}{1});
            end
            
        case 'Timing'
            
            % Number of cycles
            res = regexp(line, '^Number of cycles\s+([\-\d\.]+)', 'tokens');
            if ~isempty(res)                
                this.NCycles = str2double(res{1}{1});
            end
            
            % Cycle time
            res = regexp(line, '^Cycle time\s+([\-\d\.]+)\s+(\S+)', 'tokens');
            if ~isempty(res)                
                this.CycleTime = convert(res, in.TimeUnit);
            end
            
            % Number of frames
            res = regexp(line, '^Number of frames\s+([\-\d\.]+)', 'tokens');
            if ~isempty(res)                
                this.NFrames = str2double(res{1}{1});
            end
            
            % Total time
            res = regexp(line, '^Total time\s+([\-\d\.]+)\s+(\S+)', 'tokens');
            if ~isempty(res)                
                this.RunTime = convert(res, in.TimeUnit);
            end
            
        case 'Signals'
            
            % Default values
            res = regexp(line, 'Default\tDS(\d+)\t([\d\.]+)', 'tokens');
            if ~isempty(res)
                j = str2double(res{1}{1});
                this.Signals.DS(j).default = logical(str2double(res{1}{2}));
                continue
            end
            
            % Digital signals
            res = regexp(line, 'DS(\d+)\t([\d\.]+)\t([\d\.]+)', 'tokens');
            if ~isempty(res)
                j = str2double(res{1}{1});
                this.Signals.DS(j).tstart(end+1) = str2double(res{1}{2});
                this.Signals.DS(j).tstop(end+1) = this.Signals.DS(j).tstart(end) + str2double(res{1}{3});
                continue
            end
            
            
    end
end

% --- Post-processing -----------------------------------------------------

if ~isempty(this.Description)
    this.Description = strtrim(this.Description);
end

end

% === Local functions =====================================================
function out = convert(res, target)

val = str2double(res{1}{1});
unit = res{1}{2};

switch unit
    
    % --- Length
    case 'm'
        switch target
            case 'm', out = val;
            case 'mm', out = val*1e3;
            case {'um', 'µm'}, out = val*1e6;
        end
    case 'mm'
        switch target
            case 'm', out = val*1e-3;
            case 'mm', out = val;
            case {'um', 'µm'}, out = val*1e3;
        end
    case {'um', 'µm'}
        switch target
            case 'm', out = val*1e-6;
            case 'mm', out = val*1e-3;
            case {'um', 'µm'}, out = val;
        end
       
    % --- Coefficients
    case 'm/V'
        switch target
            case 'm/V', out = val;
            case 'mm/V', out = val*1e3;
            case {'um/V', 'µm/V'}, out = val*1e6;
        end
    case 'mm/V'
        switch target
            case 'm/V', out = val*1e-3;
            case 'mm/V', out = val;
            case {'um/V', 'µm/V'}, out = val*1e3;
        end
    case {'um/V', 'µm/V'}
        switch target
            case 'm/V', out = val*1e-6;
            case 'mm/V', out = val*1e-3;
            case {'um/V', 'µm/V'}, out = val;
        end
     
    % --- Times
    case 's'
        switch target
            case 's', out = val;
            case 'ms', out = val*1e3;
        end
    case 'ms'
        switch target
            case 's', out = val*1e-3;
            case 'ms', out = val;
        end
        
    % --- Frequencies
    case 'Hz'
        switch target
            case 'Hz', out = val;
        end
        
end
end