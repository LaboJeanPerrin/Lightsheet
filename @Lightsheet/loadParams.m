function loadParams(this, varargin)

% === Inputs ==============================================================

try
    p = inputParser;
    addOptional(p, 'file', '', @ischar);
    
    parse(p, varargin{:});
    in = p.Results;
catch
    in = struct('file', '');
end

% === Checks ==============================================================

if isempty(in.file)
     tmp = uigetfile('*.txt', 'Select a parameter file');
     if ischar(tmp)
        in.file = tmp;
     else
         return
     end
end

% === File parsing ========================================================

% --- Get file content ----------------------------------------------------
fid = fopen(in.file);
tmp = textscan(fid, '%s', 'delimiter', '\n');
fclose(fid);
File = tmp{1};

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
        
            line
            res = regexp(line, '(\w*)\t(\w*)\t(\w*)', 'tokens');
            res{1}
            
            
    end
end