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
    this.Reference = double(ceil(N/this.BlockSize)+1)*this.BlockSize/this.Rate + 2*this.BlockSize/this.Rate;
    
    % --- Log run start
    this.log('RUN START');
    
    % --- Set status
    this.Status = 'Run';
    
    % Check vi state
    if ~isempty(this.vi)
        this.vi.SetControlValue('Trig', true);
    end
    
else
    
    % --- Log run stop
    this.log('RUN STOP');
    
    % --- Set status
    this.Status = 'Idle';
    
end

