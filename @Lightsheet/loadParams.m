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
     tmp = uigetfile('*.txt', 'Select a parameter file');
     if ischar(tmp)
        in.filename = tmp;
     else
         return
     end
end

% === Parameters update ===================================================

% --- Load
this.Parameters.load(in.filename);

% --- Update

this.Signals = this.Parameters.Signals;

% Check for sufficient DS lines
for i = numel(this.Signals.DS)+1:this.NDS
    this.Signals.DS(i).tstart = [];
    this.Signals.DS(i).tstop = [];
    this.Signals.DS(i).default = false;
end