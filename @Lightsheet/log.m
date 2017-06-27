function log(this, varargin)
%[Lightsheet].log Text log

persistent buffer;

% === Inputs ==============================================================

in = inputParser;
addRequired(in, 'text', @ischar);
addParameter(in, 'flush', false, @islogical);

parse(in, varargin{:});
in = in.Results;

% =========================================================================

% --- Flush buffer ?
if ~ischar(buffer) || in.flush
    buffer = '';
end

% --- Create the log text
if isempty(in.text)
    
    % Empty line ?
    logtxt = char([13 10]);    
    
else
    logtxt = sprintf([char([13 10]) '%s - %s'], datestr(now, 'HH:MM:ss'), in.text);
end

% --- Find the log file
slist = get(this.UI.Study, 'String');
slist = setdiff(slist, 'System Volume Information');

if isempty(get(this.UI.Root, 'String')) || isempty(slist)
    
    buffer = [buffer logtxt];
    
else
        
    path = [get(this.UI.Root, 'String') filesep ...
        slist{get(this.UI.Study, 'Value')} filesep ...
        get(this.UI.Date, 'String')];
    
    % --- Create log file ?
    if ~exist(path, 'dir')
        mkdir(path);
    end
    
    % --- Append to the log file
    fid = fopen([path filesep 'log.txt'], 'a');
    
    % Flush buffer ?
    if ~isempty(buffer)
        fprintf(fid, '%s', buffer);
        buffer = '';
    end
    
    fprintf(fid, '%s', logtxt);
    fclose(fid);
    
end