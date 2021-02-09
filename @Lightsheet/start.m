function start(this, varargin)
%[Lightsheet].start start the Lightsheet acquisition

if isa(this.Session, 'ni.daq.Device') || isa(this.Session, 'daq.ni.Session')
    
    % --- DAQ session
    this.log('Start DAQ session');
    fprintf('Starting DAQ session ...');
    tic
    
    % Queue first block
    queueOutputData(this.Session, this.muxer);
    prepare(this.Session);
    
    % Listener to queue blocks on demand
    this.DataRequiredListener = addlistener(this.Session, 'DataRequired', ...
        @(src,event) src.queueOutputData(this.muxer));

    % Listener to get input data
    lh = addlistener(this.Session,'DataAvailable',@(src,event)setInputData(src,event,this));

    
    % Error handling
    this.ErrorListener = addlistener(this.Session, 'ErrorOccurred', @this.Error);
    
    % Start session
    this.Session.startBackground();
    
    fprintf(' %.02f sec\n', toc);
    
    
end

% User interface
this.DaqDisable(false);

% set(this.UI.ErrorMessage, 'Visible', 'off');

  function setInputData(src,event,this)
    this.InputData = event.Data;
  end


end
