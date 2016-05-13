function log(this, text)
%[Lightsheet].log Text log

% --- Find log file
slist = get(this.UI.Study, 'String');
path = [get(this.UI.Root, 'String') filesep ...
    slist{get(this.UI.Study, 'Value')} filesep ...
    get(this.UI.Date, 'String')];

if ~exist(path, 'dir')
    mkdir(path);
end

% --- Get time

% --- Append to the log file
fid = fopen([path filesep 'log.txt'], 'a');
fprintf(fid, [char([13 10]) datestr(now, 'HH:MM:ss') ' - ' text]);
fclose(fid);
