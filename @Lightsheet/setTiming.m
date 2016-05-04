function setTiming(this, varargin)

% === Inputs ==============================================================

try
    p = inputParser;
    addParameter(p, 'tag', '', @ischar);
    
    parse(p, varargin{:});
    in = p.Results;
catch
    in = struct('tag', '');
    try
        in.tag = get(varargin{1}, 'tag');
    catch
    end
end

% === Checks ==============================================================

% From NLayers, Exposure, Delay or DelayLong: set cycle time
if ismember(in.tag, {'NLayers', 'Exposure', 'Delay', 'DelayLong', 'All'})
    
    NLayers = str2double(get(this.UI.NLayers, 'String'));
    Exposure = str2double(get(this.UI.Exposure, 'String'));
    Delay = str2double(get(this.UI.Delay, 'String'));
    DelayLong = str2double(get(this.UI.DelayLong, 'String'));
    
    if NLayers==1
        CycleTime = NLayers*(Exposure + Delay);
    else
        CycleTime = NLayers*Exposure + (NLayers-1)*Delay + DelayLong;
    end
    
    set(this.UI.CycleTime, 'String', CycleTime);
    this.setTiming('tag', 'CycleTime');
    
end

% Number of frames (from NLayers and NCycles)
if ismember(in.tag, {'NLayers', 'NCycles', 'All'})
    
    NLayers = str2double(get(this.UI.NLayers, 'string'));
    NCycles = str2double(get(this.UI.NCycles, 'string'));
    
    set(this.UI.NFrames, 'string', NCycles*NLayers);
    
end

% From NFrames
if ismember(in.tag, {'NFrames'})
    
    NLayers = str2double(get(this.UI.NLayers, 'string'));
    NFrames = str2double(get(this.UI.NFrames, 'string'));
    
    set(this.UI.NCycles, 'string', round(NFrames/NLayers));
    this.setTiming('tag', 'NCycles');
    
end

% Run time
if ismember(in.tag, {'CycleTime', 'NCycles', 'All'})
    
    % Definitions
    CycleTime = str2double(get(this.UI.CycleTime, 'string'));
    NCycles = str2double(get(this.UI.NCycles, 'string'));
    
    % Get total time
    Time = NCycles*CycleTime/1000;
    
    % Get human-readable form
    h = floor(Time/3600);
    tmp = mod(Time, 3600);
    m = floor(tmp/60);
    s = ceil(mod(tmp, 60));
    
    % Update values
    set(this.UI.RunTime, 'string', Time);
    set(this.UI.RunTimeHuman, 'string', sprintf('%02ih %02im %02is', h, m, s));
    
end

% From RunTime
if ismember(in.tag, {'RunTime'})
    
    % Definitions
    CycleTime = str2double(get(this.UI.CycleTime, 'string'));
    RunTime = str2double(get(this.UI.RunTime, 'string'));
    
    set(this.UI.NCycles, 'string', round(RunTime/CycleTime*1000));
    this.setTiming('tag', 'NCycles');
    
end
