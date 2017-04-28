function out = muxer(this, varargin)

% Start timer
tic

% === INITIALIZATION ======================================================

persistent Nb;
if isempty(Nb), Nb = 0; end

% --- Get block number
N = this.Session.ScansOutputByHardware;

% --- First buffer
if ~N
    out = zeros(this.BlockSize*2, 5+this.NDS);
    Nb = 0;
    return
end

% --- ERROR
try
    if get(this.UI.Error, 'Value')
        set(this.UI.Error, 'Value', false);
        out = zeros(this.BlockSize, 5+this.NDS);
        pause(this.BlockSize/this.Rate);
        return
    end
catch
end

% --- Definitions
BlockTime = this.BlockSize/this.Rate;
Nb = Nb + 1;
t1 = Nb*BlockTime - this.Reference;
t2 = t1 + BlockTime;

% Positions
HMPos = str2double(get(this.UI.HM_Position, 'String'));
VMPos = str2double(get(this.UI.VM_Position, 'String'));
OPPos = str2double(get(this.UI.OP_Position, 'String'));

% --- Get status
state = this.Status;
if strcmp(this.Status, 'Idle') && get(this.UI.HM_Scan, 'Value')
    state = 'Scan';
end

% === HORIZONTAL MIRROR ===================================================

switch state
    
    case 'Idle'
        
        HM = linspace(this.Memory.HM, HMPos, this.BlockSize)';
        
    case {'Scan', 'Run'}
        
        dt = this.Waveforms.Horizontal.dt;
        
        Tw = this.Waveforms.Horizontal.NSamples*dt;
        Tw1 = mod(t1, Tw);
        Tw2 = mod(Tw1 + this.BlockSize*dt, Tw);
        
        i1 = round(Tw1/dt)+1;
        i2 = round(Tw2/dt);
        
        if Tw2>Tw1
            HM = this.Waveforms.Horizontal.data(i1:i2)';
        else
            HM = [this.Waveforms.Horizontal.data(i1:end) this.Waveforms.Horizontal.data(1:i2)]';
        end
        
end

% === VERTICAL MIRROR =====================================================

if t1<0
    
    % This may happen once when the reference is reset.
    % In this case, let's just wait for the next block.
    VM = VMPos*ones(this.BlockSize, 1);
    
else
    
    switch state
        
        case {'Idle', 'Scan'}
            
            VM = linspace(this.Memory.VM, VMPos, this.BlockSize)';
            
        case 'Run'
            
            % Number of layers
            NLayers = str2double(get(this.UI.NLayers, 'Value'));
            
            if NLayers==1
                
                VM = VMPos*ones(this.BlockSize, 1);
                
            else
                
                dt = this.Waveforms.Vertical.dt;
                NCycles = str2double(get(this.UI.NCycles, 'String'));
                
                if t1 == this.Waveforms.Vertical.CycleTime*NCycles
                    
                    set(this.UI.Run, 'Value', false);
                    this.startRun();
                    VM = VMPos*ones(this.BlockSize, 1);
                    
                else
                    
                    Tw = this.Waveforms.Vertical.NSamples*dt;
                    Tw1 = mod(t1, Tw);
                    Tw2 = mod(Tw1 + this.BlockSize*dt, Tw);
                    
                    % End of run
                    if t1+this.BlockSize*dt >= this.Waveforms.Vertical.CycleTime*NCycles
                        set(this.UI.Run, 'Value', false);
                        this.startRun();
                        Tw2 = mod(this.Waveforms.Vertical.CycleTime*NCycles, Tw);
                    end
                    
                    i1 = round(Tw1/dt)+1;
                    i2 = round(Tw2/dt);
                    
                    if Tw2>Tw1
                        VM = VMPos + this.Waveforms.Vertical.data(i1:i2)';
                    else
                        VM = VMPos + [this.Waveforms.Vertical.data(i1:end) this.Waveforms.Vertical.data(1:i2)]';
                    end
                    
                    % End of Run
                    if numel(VM)<this.BlockSize
                        VM = [VM ; VMPos*ones(this.BlockSize-numel(VM),1)];
                    end
                    
                end
            end
    end
end

% === OBJECTIVE PIEZO =====================================================

if t1<0
    
    % This may happen once when the reference is reset.
    % In this case, let's just wait for the next block.
    OP = OPPos*ones(this.BlockSize, 1);
    
else
    
    switch state
        
        case {'Idle', 'Scan'}
            
            OP = linspace(this.Memory.OP, OPPos, this.BlockSize)';
            
        case 'Run'
            
            if NLayers==1
                
                OP = OPPos*ones(this.BlockSize, 1);
                
            else
                
                if t1 == this.Waveforms.Vertical.CycleTime*NCycles
                    
                    OP = OPPos*ones(this.BlockSize, 1);
                    
                else
                    
                    if Tw2>Tw1
                        OP = OPPos + this.Waveforms.Vertical.data(i1:i2)';
                    else
                        OP = OPPos + [this.Waveforms.Vertical.data(i1:end) this.Waveforms.Vertical.data(1:i2)]';
                    end
                    
                    % End of Run
                    if numel(OP)<this.BlockSize
                        OP = [OP ; OPPos*ones(this.BlockSize-numel(OP),1)];
                    end
                    
                end
            end
    end
end

% === CAMERA ==============================================================

if t1<0
    
    % This may happen once when the reference is reset.
    % In this case, let's just wait for the next block.
    Cam = zeros(this.BlockSize, 1);
    
else
    
    switch state
        
        case {'Idle', 'Scan'}
            
            Cam = zeros(this.BlockSize, 1);
            
        case 'Run'
            
            if t1 == this.Waveforms.Vertical.CycleTime*NCycles
                
                Cam = zeros(this.BlockSize, 1);
                
            else
                
                 Tw = this.Waveforms.Camera.NSamples*dt;
                 Tw1 = mod(t1, Tw);
                 Tw2 = mod(Tw1 + this.BlockSize*dt, Tw);
                    
                 i1 = round(Tw1/dt)+1;
                 i2 = round(Tw2/dt);
                
                if Tw2>Tw1
                    
                    Cam = this.Waveforms.Camera.data(i1:i2)';
                                        
                else
                    Cam = [this.Waveforms.Camera.data(i1:end) this.Waveforms.Camera.data(1:i2)]';
                end
                
                % End of Run
                if numel(Cam)<this.BlockSize
                    Cam = [Cam ; zeros(this.BlockSize-numel(Cam),1)];
                end
                
            end
    end
end

% === SHUTTER =============================================================

if get(this.UI.Shutter, 'Value')
    Sh = ones(this.BlockSize, 1);
    Sh(end) = 0;
else
    Sh = zeros(this.BlockSize, 1);
end

% === DIGITAL STIMULI =====================================================

% Default states
DS = NaN(this.BlockSize, this.NDS);
for i = 1:this.NDS
    DS(:,i) = double(this.Signals.DS(i).default);
end

switch state
    
    case 'Run'
        
        for i = 1:this.NDS
            
            % Stimuli times
            ts = this.Signals.DS(i).tstart;
            tf = this.Signals.DS(i).tstop;
            d = double(this.Signals.DS(i).default);
            
            % Initial state
            DS(:,i) = d;
            
            % Conditions
            C1 = ts>=t1 & tf<=t2;
            C2 = ts<=t1 & tf>=t1 & tf<=t2;
            C3 = ts>=t1 & ts<=t2 & tf>=t2;
            C4 = ts<=t1 & tf>=t2;
            I = find(C1 | C2 | C3 | C4,  1, 'first');
            
            if ~isempty(I)
                i1 = max(1, round((ts(I)-t1)*this.Rate));
                i2 = min(round((tf(I)-t1)*this.Rate), this.BlockSize);
                DS(i1:i2,i) = 1-d;
            end
            
        end
end

% FORCE STIM
if get(this.UI.Stim, 'Value')
    tmp = ones(this.BlockSize, 1);
    tmp(end) = 0;
    DS(:,1) = tmp;
end

% === FINALIZATION ========================================================

% --- Update memory
this.Memory.HM = HM(end);
this.Memory.VM = VM(end);
this.Memory.OP = OP(end);
this.Memory.Cam = Cam(end);
this.Memory.Sh = Sh(end);
this.Memory.DS = DS(end,:);

% --- Vertical mirror inversion
if get(this.UI.VM_Invert, 'Value')
    pmax = str2double(get(this.UI.VM_Position_max, 'String'));
    VM = pmax - VM;
end

% --- Output Waveforms

% Conversion coefficients
HM_um2V = str2double(get(this.UI.HM_um2V, 'String'));
VM_um2V = str2double(get(this.UI.VM_um2V, 'String'));
OP_um2V = str2double(get(this.UI.OP_um2V, 'String'));

% fprintf('%s - %i - %f - %.01fms\n', state, Nb, t1, toc*1000);

try
    out = [HM/HM_um2V VM/VM_um2V OP/OP_um2V Cam Sh DS];
catch ME
    
    fprintf('Size of HM: %i, %i\n', size(HM));
    fprintf('Size of VM: %i, %i\n', size(VM));
    fprintf('Size of OP: %i, %i\n', size(OP));
    fprintf('Size of Cam: %i, %i\n', size(Cam));
    fprintf('Size of Sh: %i, %i\n', size(Sh));
    fprintf('Size of Sh: %i, %i\n', size(DS));
    
    rethrow(ME);
end
