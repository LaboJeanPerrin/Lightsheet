function loadParams(this, varargin)

% === Inputs ==============================================================

try
    p = inputParser;
    addOptional(p, 'filename', '', @ischar);
    
    parse(p, varargin{:});
    in = p.Results;
catch
    in = struct('filename', '');
end

% === Checks ==============================================================

if isempty(in.filename)
     [tmp, pname] = uigetfile('*.txt', 'Select a parameter file');
     if ischar(tmp)
        in.filename = [pname tmp];
     else
         return
     end
end

% === Parameters update ===================================================

% --- Load
this.Parameters.load(in.filename);
this.log(['Load parameter file (' in.filename ')']);

% --- Version Warning
switch this.Parameters.Version

    case '4.1'
        
        % --- Camera model ------------------------------------------------
        
        if ~isempty(this.Parameters.CameraModel)
            list = get(this.UI.Model, 'String');
            [~, cI] = ismember(this.Parameters.CameraModel, list);
            if ~isempty(cI)
                set(this.UI.Model, 'value', cI);
            end
        end
        
        % --- Folders -----------------------------------------------------
        
        if ~isempty(this.Parameters.Root)
            set(this.UI.Root, 'String', this.Parameters.Root);
        end
        
        % --- Settings ----------------------------------------------------
        
        % --- Horizontal Mirror
        
        if ~isempty(this.Parameters.HM_Position_min)
            set(this.UI.HM_Position_slider, 'Min', this.Parameters.HM_Position_min);
            set(this.UI.HM_Position_min, 'String', this.Parameters.HM_Position_min);
        end
        
        if ~isempty(this.Parameters.HM_Position_max)
            set(this.UI.HM_Position_slider, 'Max', this.Parameters.HM_Position_max);
            set(this.UI.HM_Position_max, 'String', this.Parameters.HM_Position_max);
        end
        
        if ~isempty(this.Parameters.HM_Position)
            set(this.UI.HM_Position_slider, 'Value', this.Parameters.HM_Position);
            set(this.UI.HM_Position, 'String', this.Parameters.HM_Position);
        end
        
        if ~isempty(this.Parameters.HM_Symmetrize)
            set(this.UI.HM_symmetrize, 'Value', this.Parameters.HM_Symmetrize);
        end
        
        % --- Acquisition -------------------------------------------------
        
        
        
        % --- Signals -----------------------------------------------------
        this.Signals = this.Parameters.Signals;
        
        % Fill the empty DS lines
        for i = numel(this.Signals.DS)+1:this.NDS
            this.Signals.DS(i).tstart = [];
            this.Signals.DS(i).tstop = [];
            this.Signals.DS(i).default = false;
        end
        
end