function saveParams(this, varargin)

% --- Check that a run is selected
if isempty(this.Run)
    
    % Create new run ?
    switch questdlg('No run is selected. Would you like to create a new run ?', ...
        'Create run ?', 'Yes', 'No', 'Yes')
    
        case 'Yes'
            this.newRun;
            
        case 'No'
            return
    end
    
end

% --- Update Parameters object
this.Parameters.import_Lightsheet(this);

% --- Save Parameters file
this.Parameters.save([this.Run.Path filesep 'Parameters.txt']);

% --- Refresh Runs
this.refreshRuns;