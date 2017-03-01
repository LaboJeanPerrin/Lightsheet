classdef Lightsheet < handle
    
% TO DO:
% - Signals
% - Run management (create folder, run list etc.)
% - Save parameters
% - Load parameters
% - Vert traj: Continuous Sawtooth 
%
% - Shortcuts
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
            
            % --- Cleanup the interface
            
            % Close existing occurences of Lightsheet
            close all
            
            % Clear command window
            clc
            
            % Minimize Matlab's main window
%             mainWindow = com.mathworks.mde.desk.MLDesktop.getInstance.getMainFrame;
%             mainWindow.setMinimized(true);

            % --- Define block size

            this.BlockSize = floor(this.Rate/10);

            % --- Parameters ----------------------------------------------
            tmp = inputParser;
            addParameter(tmp, 'grid', true, @islogical);
            
            parse(tmp, varargin{:});
            in = tmp.Results;
            
            % --- User Interface ------------------------------------------
            % NB: Contain default values for all UI parameters.
            
            this.GUI('grid', in.grid);
            drawnow;
            
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
            
            % --- Initialize and start DAQ --------------------------------
            
            this.init;
            this.Memory = struct('HM', 0, 'VM', 0, 'OP', 0, 'Cam', 0, 'Sh', 0, 'DS', zeros(this.NDS,1));
            this.start
            
        end
    end
    
end