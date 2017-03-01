function setWaveforms(this, varargin)

% === Inputs ==============================================================

try
    p = inputParser;
    addParameter(p, 'tag', '', @ischar);
    
    parse(p, varargin{:});
    in = p.Results;
catch
    in = struct('tag', '');
    try
        in.tag = get(varargin{1}, 'tag');
    catch
    end
end

% === Definitions =========================================================

Hmax = str2double(get(this.UI.HM_Position_max, 'String'));
Hmin = str2double(get(this.UI.HM_Position_min, 'String'));
Freq = str2double(get(this.UI.HM_Rate, 'String'));
VMPos = str2double(get(this.UI.VM_Position, 'String'));

Nlayers = str2double(get(this.UI.NLayers, 'String'));
Increment = str2double(get(this.UI.Increment, 'String'));
Height = str2double(get(this.UI.Height , 'String'));
list = get(this.UI.StepsShape, 'String');
StepsShape = list{get(this.UI.StepsShape, 'Value')};

dt = 1/this.Rate;
Exposure = str2double(get(this.UI.Exposure, 'String'))/1000;
Delay = str2double(get(this.UI.Delay, 'String'))/1000;
DelayLong = str2double(get(this.UI.DelayLong, 'String'))/1000;

Ratio = str2double(get(this.UI.StabRatio, 'String'))/100;
list = get(this.UI.StabShape, 'String');
StabShape = list{get(this.UI.StabShape, 'Value')};

% === Checks ==============================================================

% --- Multi-layer fields
if ismember(in.tag, {'NLayers', 'All'})
    
    NLayers = str2double(get(this.UI.NLayers, 'String'));
    if NLayers==1
        
        % Disable multi-layer fields
        set(this.UI.StepsShape, 'Enable', 'off');
        set(this.UI.Increment, 'Enable', 'off');
        set(this.UI.Height, 'Enable', 'off');
        set(this.UI.DelayLong, 'Enable', 'off');
        set(this.UI.StabShape, 'Enable', 'off');
        set(this.UI.StabRatio, 'Enable', 'off');
        
    else
        
        % Enable multi-layer fields
        set(this.UI.StepsShape, 'Enable', 'on');
        set(this.UI.Increment, 'Enable', 'on');
        set(this.UI.Height, 'Enable', 'on');
        set(this.UI.DelayLong, 'Enable', 'on');
        set(this.UI.StabShape, 'Enable', 'on');
        set(this.UI.StabRatio, 'Enable', 'on');
        
    end
    
end

% --- Set increments
if ismember(in.tag, {'Height'})
    
    NLayers = str2double(get(this.UI.NLayers, 'String'));
    Increment = str2double(get(this.UI.Increment, 'String'));
    Height = str2double(get(this.UI.Height, 'String'));
    
    set(this.UI.Increment, 'String', num2str(round(Height/(NLayers-1)*sign(Increment)*10)/10));
    
end

% --- Set total height
if ismember(in.tag, {'NLayers', 'StepsShape', 'Increment', 'Height', 'All'})

    if ismember(StepsShape, {'Sawtooth_steps', 'Triangle_steps'})
        NLayers = str2double(get(this.UI.NLayers, 'String'));
        Increment = str2double(get(this.UI.Increment, 'String'));
        set(this.UI.Height, 'String', num2str(abs((NLayers-1)*Increment)));
    end

end

% --- Set long delay
if ismember(in.tag, {'Delay', 'DelayLong', 'All'})
    
    Delay = str2double(get(this.UI.Delay, 'String'));
    DelayLong = str2double(get(this.UI.DelayLong, 'String'));
    
    if DelayLong<Delay
        DelayLong = Delay;
        set(this.UI.DelayLong, 'String', num2str(DelayLong));
    end
    
end

% --- Coerce stabilization ratio
if ismember(in.tag, {'StabRatio', 'All'})
    
    Ratio = str2double(get(this.UI.StabRatio, 'String'));
    
    if Ratio<0
        set(this.UI.StabRatio, 'String', '0');
    elseif Ratio>100
        set(this.UI.StabRatio, 'String', '100');
    end
    
end

% --- Update timing
if ismember(in.tag, {'NLayers', 'Exposure', 'Delay', 'DelayLong', 'All'})
    
    % Update timing
    this.setTiming('tag', in.tag);
    
end

% --- Steps shape
switch StepsShape
    
    case {'Sawtooth steps', 'Triangle steps'}
        set(this.UI.Increment, 'Enable', 'on');
        set(this.UI.StabShape, 'Enable', 'on');
        set(this.UI.StabRatio, 'Enable', 'on');
        
    case 'Sawtooth linear'
        set(this.UI.Increment, 'Enable', 'off');
        set(this.UI.StabShape, 'Enable', 'off');
        set(this.UI.StabRatio, 'Enable', 'off');
end

% === Waveform generation =================================================

this.Waveforms = struct();

% --- Horizontal Waveform

% Compute Waveform

switch get(get(this.UI.HM_Mode, 'SelectedTab'), 'Title')
    
    case 'Independent'
        
        t = 0:dt:1/Freq;
        if t(end)==1/Freq, t(end) = []; end
        
        list = get(this.UI.HM_Shape, 'String');
        switch list{get(this.UI.HM_Shape, 'Value')}
            
            case 'Sawtooth'
                tmp = (Hmax-Hmin)*(t*Freq) + Hmin;
                
            case 'Sine'
                tmp = (Hmax-Hmin)*(sin(2*pi*t*Freq)+1)/2 + Hmin;
                tmp(end) = [];
                
            case 'Triangle'
                tmp = (Hmax-Hmin)*2*[0 cumsum(sign(sin(2*pi*t*Freq)))]/numel(t) + Hmin;
                
        end
        
    case 'Slave'
        
        Np_Exposure = round(Exposure/dt);
        Np_delay = round(Delay/dt);
        tmp_OneLayer = [Hmin*ones(1,Np_delay) linspace(Hmin, Hmax, Np_Exposure) Hmax*ones(1,Np_delay) linspace(Hmax,Hmin,Np_Exposure)];
        tmp = repmat(tmp_OneLayer,1,Nlayers);
        
end

% BlockSize limitation
if numel(tmp)<=this.BlockSize
    Tmp = repmat(tmp, [1 ceil(this.BlockSize/numel(tmp))]);
else
    Tmp = tmp;
end

% Store Waveform
this.Waveforms.Horizontal = struct('dt', dt, ...
    'data', Tmp, ...
    'nSamples', numel(tmp), ...
    'NSamples', numel(Tmp), ...
    'CycleTime', numel(tmp)*dt, ...
    'WfmTime', numel(Tmp)*dt);

% --- Vertical Waveform

% Compute Waveform
tmp = [];

switch StepsShape
    
    case 'Sawtooth_steps'
        
        for j = 1:Nlayers
            
            % --- Plateau
            tmp = [tmp Increment*(j-1)*ones(1, round(Exposure/dt))];
            
            % --- Movement
            switch StabShape
                
                case 'Linear'
                    
                    if j<Nlayers
                        Np = round(Delay/dt);
                        Nm = round(Np*Ratio);
                        tmp = [tmp linspace(Increment*(j-1), Increment*j, Nm) Increment*j*ones(1,Np-Nm)];
                    else
                        if Nlayers==1
                            Np = round(Delay/dt);
                            Nm = round(Np*Ratio);
                        else
                            Np = round(DelayLong/dt);
                            Nm = round(Np*Ratio);
                        end
                        tmp = [tmp linspace(Increment*(j-1), 0, Nm) zeros(1,Np-Nm)];
                    end
            end
            
        end
        
    case 'Sawtooth_linear'

        tmp = [linspace(0, Height, round((Exposure*Nlayers + Delay*(Nlayers-1))/dt)) ...
               zeros(1, round(DelayLong/dt))];
        
    case 'Triangle_steps'
        
        IL = Config.interleave(Nlayers)-1;
        
        for j = 1:Nlayers
            
            % --- Plateau
            tmp = [tmp Increment*(IL(j))*ones(1,round(Exposure/dt))];
            
            % --- Movement
            switch StabShape
                
                case 'Linear'
                    
                    if j<Nlayers
                        Np = round(Delay/dt);
                        Nm = round(Np*Ratio);
                        tmp = [tmp linspace(Increment*IL(j), Increment*IL(j+1), Nm) Increment*IL(j+1)*ones(1,Np-Nm)];
                    else
                        if Nlayers==1
                            Np = round(Delay/dt);
                            Nm = round(Np*Ratio);
                        else
                            Np = round(DelayLong/dt);
                            Nm = round(Np*Ratio);
                        end
                        tmp = [tmp linspace(Increment*IL(j), 0, Nm) zeros(1, Np-Nm)];
                    end
            end
            
        end
        
end

% BlockSize limitation
if numel(tmp)<=this.BlockSize
    Tmp = repmat(tmp, [1 ceil(this.BlockSize/numel(tmp))]);
else
    Tmp = tmp;
end

% Store Waveform
this.Waveforms.Vertical = struct('dt', dt, ...
    'data', Tmp, ...
    'nSamples', numel(tmp), ...
    'NSamples', numel(Tmp), ...
    'CycleTime', numel(tmp)*dt, ...
    'WfmTime', numel(Tmp)*dt);

% --- Camera Waveform
tmp = [];
for j = 1:Nlayers
    tmp = [tmp ones(1,round(Exposure/dt)) zeros(1,round(Delay/dt))];
end

% BlockSize limitation
if numel(tmp)<=this.BlockSize
    Tmp = repmat(tmp, [1 ceil(this.BlockSize/numel(tmp))]);
else
    Tmp = tmp;
end

% Store Waveform
this.Waveforms.Camera = struct('dt', dt, ...
    'data', Tmp, ...
    'nSamples', numel(tmp), ...
    'NSamples', numel(Tmp), ...
    'CycleTime', numel(tmp)*dt, ...
    'WfmTime', numel(Tmp)*dt);

% --- Display -------------------------------------------------------------

% --- Axes
A = this.UI.Waveforms;
cla(A);
hold(A, 'on');
box(A, 'on');
grid(A, 'on');
xlabel(A, 'Time (s)');
ylabel(A, 'Position (µm)');

% --- Vertical Waveform
xv = (0:this.Waveforms.Vertical.nSamples-1)*this.Waveforms.Vertical.dt;
v = plot(A, xv, this.Waveforms.Vertical.data(1:this.Waveforms.Vertical.nSamples) + VMPos, '-');

% --- Horizontal Waveform
% xh = (0:this.Waveforms.Horizontal.nSamples-1)*this.Waveforms.Horizontal.dt;
% h = plot(A, xh, this.Waveforms.Horizontal.data(1:this.Waveforms.Horizontal.nSamples), '-', ...
%     'color', [1 1 1]*0.5);

% --- Camera Waveform
d = diff(this.Waveforms.Camera.data(1:this.Waveforms.Camera.nSamples));
I = find(d==1);
J = find(d==-1);
if numel(I)<numel(J)
    I = [1 I];
end
yL = get(A, 'Ylim');

for i = 1:numel(I)
    rectangle(A, 'Position', [xv(I(i)) yL(1)+(yL(2)-yL(1))/100 xv(J(i))-xv(I(i)) 49*(yL(2)-yL(1))/50], ...
        'Edgecolor', 'none', 'FaceColor', [0.902 0.933 0.8902]);
end

% --- Manage plot overlays
% uistack(h, 'top');
uistack(v, 'top');