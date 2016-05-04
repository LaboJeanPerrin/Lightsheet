classdef Parameters < handle

    properties (Access = public)
        
        % --- General
        Version
        Study
        Date
        RunName
        Description

        % --- Images
        CameraModel
        FluoMode
        
        % --- Mirrors & piezo
        HM_Position_min
        HM_Position_max
        HM_um2V
        
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
        
    end
    
    methods
        
        % --- Constructor -------------------------------------------------
        function this = Parameters(varargin)
            
        end
        
    end
    
end