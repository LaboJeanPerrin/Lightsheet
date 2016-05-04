function setFolders(this, varargin)

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

if ismember(in.tag, {'Root', 'All'})
    
    % Get root folder
    root = get(this.UI.Root, 'String');
    
    % Get Studies
    D = dir(root);
    list = {D(3:end).name};
    list = list([D(3:end).isdir]);
    
    % Set studies
    set(this.UI.Study, 'string', list);
    
end