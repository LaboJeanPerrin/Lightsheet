classdef Parameters < handle

    properties (Access = public)
               
        % --- Header
        Version
        Study
        Date
        RunName
        Description

        % --- Folders
        Root
        
        % --- Images
        CameraModel
        FluoMode
        
        % --- Mirrors & piezo
        HM_Position_min
        HM_Position_max
        HM_Position
        HM_um2V
        HM_Symmetrize
        
        VM_Position
        VM_um2V
        
        OP_Position
        OP_um2V
        
        % --- Light scan
        HM_Mode
        HM_Shape
        HM_Rate
        
        % --- Layers
        NLayers
        Exposure
        Delay
        
        DelayLong
        StepsShape
        Increment
        StabShape
        StabRatio
        
        % --- Timing
        NCycles
        CycleTime
        NFrames
        RunTime
        
        % --- Signals
        Signals
        
        % --- Units
        Units
        
    end
    
    methods
        
        % --- Constructor -------------------------------------------------
        function this = Parameters(varargin)
            
            % Default Units
            this.Units = struct('Length', '�m', ...
                'Time', 'ms', ...
                'Frequency', 'Hz', ...
                'Ratio', '%');
            
        end
        
    end
    
end