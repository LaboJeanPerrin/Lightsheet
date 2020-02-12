function init(this, varargin)
%[Lightsheet].init Initialization of the Lightsheet acquisition

% --- DAQ session
this.log('Initialize DAQ session');
fprintf('Initializing DAQ session ...');
tic

this.DaqDisable(true);

% --- Session
try
    this.Session = daq.createSession('ni');
catch
    this.log('Unable to initialize DAQ session. Running in debug mode.');
    this.DaqDisable(false);
end

% --- Channels
this.Channels = struct('Type', {}, 'Channel', {}, 'Range', {}, 'Name', {});

% Horizontal mirror
this.Channels(1).Name = 'HM';
this.Channels(1).Type = 'AO';
this.Channels(1).Channel = 2;
this.Channels(1).Range = [-5 5];

% Vertical Mirror
this.Channels(2).Name = 'VM';
this.Channels(2).Type = 'AO';
this.Channels(2).Channel = 3;
this.Channels(2).Range = [-10 10];

% Objective Piezo
this.Channels(3).Name = 'OP';
this.Channels(3).Type = 'AO';
this.Channels(3).Channel = 1;
this.Channels(3).Range = [-10 10];

% Camera
this.Channels(4).Name = 'Camera';
this.Channels(4).Type = 'DO';
this.Channels(4).Channel = 'Port0/Line0';

% Shutter
this.Channels(5).Name = 'Shutter';
this.Channels(5).Type = 'DO';
this.Channels(5).Channel = 'Port0/Line8';

% Run trig
this.Channels(6).Name = 'RunTrig';
this.Channels(6).Type = 'DO';
this.Channels(6).Channel = 'Port0/Line4';

% Digital stimuli
if this.NDS
    this.Channels(7).Type = 'DO';
    if this.NDS==1
        this.Channels(7).Channel = 'Port0/Line2';
    else
        this.Channels(7).Channel = ['Port0/Line2:' num2str(this.NDS+1)];
    end
    this.Channels(7).Name = 'Digital Stimuli';
end



if isa(this.Session, 'ni.daq.Device') || isa(this.Session, 'daq.ni.Session')
    
    % --- Rate
    this.Session.Rate = this.Rate;
    
    
    % Assign channels
    for i = 1:numel(this.Channels)
        switch this.Channels(i).Type
            case 'AO'
                addAnalogOutputChannel(this.Session, this.Device, this.Channels(i).Channel, 'Voltage');
                this.Session.Channels(i).Range = this.Channels(i).Range;
            case 'DO'
                addDigitalChannel(this.Session, this.Device, this.Channels(i).Channel, 'OutputOnly');
        end
        this.Session.Channels(i).Name = this.Channels(i).Name;
    end
    
    % --- Misc settings
    this.Session.IsContinuous = true;
    this.Session.NotifyWhenScansQueuedBelow = this.BlockSize*2;
    
end

fprintf(' %.02f sec\n', toc);