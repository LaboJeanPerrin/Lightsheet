function start(this, varargin)
%[Lightsheet].start start the Lightsheet acquisition

% --- DAQ session
fprintf('Starting DAQ session ...');
tic

% Queue first block
queueOutputData(this.Session, this.muxer);
prepare(this.Session);

% Listener to queue blocks on demand
this.DataRequiredListener = addlistener(this.Session, 'DataRequired', ...
    @(src,event) src.queueOutputData(this.muxer));

% Error handling
this.ErrorListener = addlistener(this.Session, 'ErrorOccurred', @this.Error); 

% Start session
this.Session.startBackground();

fprintf(' %.02f sec\n', toc);