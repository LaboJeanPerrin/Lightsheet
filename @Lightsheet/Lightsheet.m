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
            tmp = fileparts(fileparts(mfilename('fullpath')));
            
            ConfName = [tmp filesep 'Config.txt'];
            if exist(ConfName, 'file')
                this.loadParams(ConfName);
            end
            
            % --- Check for the Root folder
            if isempty(get(this.UI.Root, 'String'))
                while true
                    
                    tmp = inputdlg('Data root directory:', 'Input requested', [1 50]);
                    
                    % Cancel > Stop
                    if isempty(tmp)
                        delete(this.Figures.Main);
                        return
                    end
                    
                    if ~isempty(tmp{1})
                        set(this.UI.Root, 'String', tmp{1});
                        break;
                    end
                end
            end
                     
            % --- Default values & Propagation ----------------------------
            
            if ~this.setFolders('tag', 'All')
                delete(this.Figures.Main);
                return
            end
            
            % this.refreshRuns();
            this.setPositions('tag', 'All');
            this.setWaveforms('tag', 'StepsShape');
            this.setTiming('tag', 'All');
            
            % --- Initialize and start DAQ --------------------------------
                        
            this.init;
            this.Memory = struct('HM', 0, 'VM', 0, 'OP', 0, 'Cam', 0, 'Sh', 0, 'DS', zeros(this.NDS,1));
            this.start;
            
        end
    end
    
end