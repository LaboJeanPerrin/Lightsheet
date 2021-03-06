function Error(this, Src, Event)

% --- Transitionnal GUI display
this.DaqDisable(true);

% --- Error log
log = 'ERROR';
log = [log char([13 10 9]) Event.Error.identifier];
log = [log char([13 10 9]) Event.Error.message];
this.log(log);

fprintf('~~~ ERROR ~~~\n');
fprintf('%s\n', Event.Error.message);

% --- Close DAQ session
this.log('Close DAQ session');
fprintf('Closing DAQ session ...');
tic

try
this.Session.stop();
catch
end
release(this.Session);

fprintf(' %.02f sec\n', toc);

% --- Restart DAQ session
this.init;
this.start;

% --- Back to normal GUI display
this.DaqDisable(false);
