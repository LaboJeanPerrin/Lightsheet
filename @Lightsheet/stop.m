function stop(this, varargin)
%[Lightsheet].stop stops the Lightsheet acquisition

% --- DAQ session
this.log('Close DAQ session');
fprintf('Closing DAQ session ...');
tic

this.Session.stop();
release(this.Session);

fprintf(' %.02f sec\n', toc);

% --- Main window
this.log('Close Main window');
fprintf('Closing Main window ...');
tic

delete(this.Figures.Main);

fprintf(' %.02f sec\n', toc);