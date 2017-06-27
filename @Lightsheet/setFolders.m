function out = setFolders(this, varargin)

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
    list = setdiff(list([D(3:end).isdir]), 'System Volume Information');
    
    if isempty(list)

        list = inputdlg(['No study folder could be found in the root path:' newline ...
            root char([10 10]) ...
            'To create a study folder, input the study name and click "OK".' newline], ...
            'Study', [1 50], ...
            {'Lightsheet'});
        
        if isempty(list)
            out = false;
            return
        end
            
        % Create study folder
        mkdir([root filesep list{1}]);
        
    end
    
    % Set studies
    set(this.UI.Study, 'String', list);
    
end

% --- Ouput
if nargout
    out = true;
end