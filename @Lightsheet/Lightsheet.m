classdef Lightsheet < handle
    
    properties (Access = public)
        
        Version = '4.2';
        
        Device = 'Dev1';
        Rate = 100000;
        BlockSize
        Waveforms
        Memory
        Reference = 0;
        Status = 'Idle';
        NDS = 2;                        % Number of Digital Stimuli
        
        Session
        Channels
        DataRequiredListener
        ErrorListener
        
        Figures = struct();
        UI = struct();
                
        Run = [];
        Parameters
        Signals
        
        vi = [];
        
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
            
                        
            % --- Parameters ----------------------------------------------

            this.Parameters = Parameters;
            
            ConfName = [prefdir filesep 'Lightsheet_Config.txt'];            
            if exist(ConfName, 'file')
                this.loadParams(ConfName);
            else
                TempName = [fileparts(mfilename('fullpath')) filesep 'TEMPLATE_Config.txt'];
                copyfile(TempName, ConfName);
                
                fprintf('Please edit the configuration file and restart the program.\n');
                fprintf('\n\t--------------------------\n\n');
                edit(ConfName);
                return
                
            end
            
            % --- Update screen
            this.GUI('UpdateScreen');
            drawnow;
                              
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
            
%             this.refreshRuns();
            
            this.setPositions('tag', 'All');     
            this.setWaveforms('tag', 'StepsShape');
            this.setTiming('tag', 'All');
            
            % --- Initialize and start DAQ --------------------------------

            this.init;
            this.Memory = struct('HM', 0, 'VM', 0, 'OP', 0, 'Cam', 0, 'Sh', 0, 'DS', zeros(this.NDS,1), 'vCorr', 0);
            this.start;
            
        end
    end
    
end