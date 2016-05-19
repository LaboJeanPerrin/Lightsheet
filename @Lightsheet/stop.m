function stop(this, varargin)
%[Lightsheet].stop stops the Lightsheet acquisition

if isa(this.Session, 'ni.daq.Device')
    
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

delete(this.Figures.Main);

fprintf(' %.02f sec\n', toc);