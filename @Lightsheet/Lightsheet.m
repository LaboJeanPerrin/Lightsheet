classdef Lightsheet < handle
    
% TO DO:
% - Signals
% - Run management (create folder, run list etc.)
% - Save parameters
% - Load parameters
% - Vert traj: Continuous Sawtooth 
%
% - Shortcut
% - Display status
% - Remaining time
% - Close shutter after run
% - Steps shape: add "Triangle"
% - Add other
%
% - Help
% - Documentation
% - Tooltips
% - Window manager: position, which tab is in front
% - Button appearance
    
    properties (Access = public)
        
        Version = '4.1';
        
        Device = 'Dev1';
        Rate = 100000;
        BlockSize
        Waveforms
        Memory
        Reference = 0;
        Status = 'Idle';
        NDS = 8;                        % Number of Digital Stimuli
        
        Session
        Channels
        DataRequiredListener
        ErrorListener
        
        Figures = struct();
        UI = struct();
                
        Run = [];
        Parameters
        Signals
        
    end
    
    methods
        
        % --- Constructor -------------------------------------------------
        function this = Lightsheet(varargin)
            
            close all
            clc
            
            % --- Parameters ----------------------------------------------
            tmp = inputParser;
            addParameter(tmp, 'grid', true, @islogical);
            
            parse(tmp, varargin{:});
            in = tmp.Results;
            
            % --- Acquisition settings ------------------------------------
            
            % --- Session
            this.Session = daq.createSession('ni');
            
            % --- Rate
            this.Session.Rate = this.Rate;
            
            % --- Channels
            this.Channels = struct('Type', {}, 'Channel', {}, 'Range', {}, 'Name', {});
            
            % Horizontal mirror
            this.Channels(1).Name = 'HM';
            this.Channels(1).Type = 'AO';
            this.Channels(1).Channel = 0;
            this.Channels(1).Range = [-5 5];
            
            % Vertical Mirror
            this.Channels(2).Name = 'VM';
            this.Channels(2).Type = 'AO';
            this.Channels(2).Channel = 1;
            this.Channels(2).Range = [-5 5];
            
            % Objective Piezo
            this.Channels(3).Name = 'OP';
            this.Channels(3).Type = 'AO';
            this.Channels(3).Channel = 2;
            this.Channels(3).Range = [-10 10];
            
            % Camera
            this.Channels(4).Type = 'DO';
            this.Channels(4).Channel = 'Port0/Line0';
            this.Channels(4).Name = 'Camera';
            
            % Shutter
            this.Channels(5).Type = 'DO';
            this.Channels(5).Channel = 'Port0/Line1';
            this.Channels(5).Name = 'Shutter';
            
            % Digital stimuli
            if this.NDS
                this.Channels(6).Type = 'DO';
                if this.NDS==1
                    this.Channels(6).Channel = 'Port0/Line2';
                else
                    this.Channels(6).Channel = ['Port0/Line2:' num2str(this.NDS+1)];
                end
                this.Channels(6).Name = 'Digital Stimuli';
            end
            
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
            this.BlockSize = floor(this.Rate/10);
            this.Session.IsContinuous = true;
            this.Session.NotifyWhenScansQueuedBelow = this.BlockSize;
            this.Memory = struct('HM', 0, 'VM', 0, 'OP', 0, 'Cam', 0, 'Sh', 0, 'DS', zeros(this.NDS,1));
            
            % --- User Interface ------------------------------------------
            % NB: Contain default values for all UI parameters.
            
            this.GUI('grid', in.grid);

            % --- Parameters ----------------------------------------------
            
            this.Parameters = Parameters;
            
            tmp = userpath;
            ConfName = [tmp(1:end-1) filesep 'Lightsheet' filesep 'Config.txt'];
            if exist(ConfName, 'file')
                this.loadParams(ConfName);
            end
            
            % --- Default values & Propagation ----------------------------
            
            this.setFolders('tag', 'All');
            this.refreshRuns();
            this.setPositions('tag', 'All');
            this.setWaveforms('tag', 'All');
            
            % --- Start DAQ session ---------------------------------------
            
            this.start
            
        end
    end
    
end