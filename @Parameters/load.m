function load(this, varargin)

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

mode = 'Default';

for i = 1:numel(File)
    
    % --- Get line
    line = File{i};
    
    % --- Skip empty lines
    if isempty(line), continue; end
    
    % --- Comments
    if strcmp(line(1), '#')
        
        % Check for the "signals" section
        res = regexp(line, '# --- (.*) ---', 'tokens');
        if ~isempty(res) && strcmp(res{1}{1}, 'Signals')
            mode = 'Signals';
        end
        
        continue;
    end
    
    switch mode
        
        case 'Default'
        
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