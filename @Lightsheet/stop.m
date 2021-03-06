function stop(this, varargin)
%[Lightsheet].stop stops the Lightsheet acquisition

try
    
    if isa(this.Session, 'ni.daq.Device') || isa(this.Session, 'daq.ni.Session')
        
        % --- DAQ session
        this.log('Close DAQ session');
        fprintf('Closing DAQ session ...');
        tic
        
        this.Session.stop();
        release(this.Session);
        
        fprintf(' %.02f sec\n', toc);
        
    end
    
    
    
    % --- Main window
    this.log('Close Main window');
    fprintf('Closing Main window ...');
    tic
    
catch
end

delete(this.Figures.Main);

fprintf(' %.02f sec\n', toc);