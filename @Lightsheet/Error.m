function Error(this, Src, Event)

fprintf('\n------------------- Error detected\n\n');
disp(Event.Error)

% --- Transitionnal GUI display

set(this.UI.ErrorMessage, 'Visible', 'on');

% --- Close DAQ session
fprintf('Closing DAQ session ...');
tic

try
this.Session.stop();
catch
end
release(this.Session);

fprintf(' %.02f sec\n', toc);

% --- Error log

% --- Restart DAQ session
this.init;
this.start;

% --- Back to normal GUI display
set(this.UI.ErrorMessage, 'Visible', 'off');
