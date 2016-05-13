function startRun(this, varargin)

% Check value
if get(this.UI.Run, 'Value')
    
    % --- Save parameters
    this.saveParams;
    
    % --- Set reference
    
    % Get block number
    N = this.Session.ScansOutputByHardware;
    if ~N, return; end
    
    % Set reference
    this.Reference = double(ceil(N/this.BlockSize)+1)*this.BlockSize/this.Rate;
    
    % --- Set status
    this.Status = 'Run';
    
else
    
    % --- Set status
    this.Status = 'Idle';
    
end
