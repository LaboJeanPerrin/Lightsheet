function selectRun(this, varargin)

if isnumeric(varargin{1})
    
    % Get identifier
    id = varargin{1};
    
    % Set Run
    this.Run = struct('Id', id, 'Name', ['Run ' num2str(id, '%02i')]);
    
else
    
    if isempty(varargin{2}.Indices), return; end
    
    % Get identifier
    id = varargin{2}.Indices(1);
    
    % Set Run
    this.Run = struct('Id', id, 'Name', varargin{1}.Data{id,1});
    
end

% Set run path
slist = get(this.UI.Study, 'String');
this.Run.Path = [get(this.UI.Root, 'String') filesep ...
    slist{get(this.UI.Study, 'Value')} filesep ...
    get(this.UI.Date, 'String') filesep ...
    this.Run.Name];

if ~isempty(this.vi)
    this.vi.SetControlValue('Run selected', this.Run.Name );
end