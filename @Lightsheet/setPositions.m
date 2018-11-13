function setPositions(this, varargin)

persistent OP_prev

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

% === Checks ==============================================================

% --- Coefficients
 
if ismember(in.tag, {'All'})
 
    set(this.UI.HM_um2V, 'String', num2str(this.Parameters.HM_um2V));
 
    set(this.UI.VM_um2V, 'String', num2str(this.Parameters.VM_um2V));
 
    set(this.UI.OP_um2V, 'String', num2str(this.Parameters.OP_um2V));
 
end

% --- HM position

% From slider
if ismember(in.tag, {'HM_Position_slider', 'All'})
    
    HMPos = get(this.UI.HM_Position_slider, 'Value');
    set(this.UI.HM_Position, 'String', num2str(round(HMPos)));

end

% From center button
if ismember(in.tag, {'HM_Center'})
    
    pmin = str2double(get(this.UI.HM_Position_min, 'String'));
    pmax = str2double(get(this.UI.HM_Position_max, 'String'));
    
    set(this.UI.HM_Position, 'String', (pmin+pmax)/2);
    set(this.UI.HM_Position_slider, 'Value', (pmin+pmax)/2);
    
end

% From position
if ismember(in.tag, {'HM_Position', 'All'})
    
    HMPos = str2double(get(this.UI.HM_Position, 'String'));
    set(this.UI.HM_Position_slider, 'Value', HMPos);

end

% From symmetrize
if ismember(in.tag, {'HM_symmetrize'})
    
    if get(this.UI.HM_symmetrize, 'Value')
        set(this.UI.HM_Position_min, 'Enable', 'off');
        pmin = -str2double(get(this.UI.HM_Position_max, 'String'));
        set(this.UI.HM_Position_min, 'String', pmin);
        set(this.UI.HM_Position_slider, 'Min', pmin);
        
        % Update waveforms
        this.setWaveforms
        
    else
        set(this.UI.HM_Position_min, 'Enable', 'on');
    end

end

% From min-max horizontal positions, or horizontal coefficient
if ismember(in.tag, {'HM_Position_max', 'HM_Position_min', 'HM_um2V', 'All'})
    
    pos = str2double(get(this.UI.HM_Position, 'String'));
    p1 = str2double(get(this.UI.HM_Position_min, 'String'));
    p2 = str2double(get(this.UI.HM_Position_max, 'String'));
    pmin = min(p1, p2);
    pmax = max(p1, p2);
    
    % Update pmin if symetrize
    if get(this.UI.HM_symmetrize, 'Value')
        pmin = -pmax;
    end
    
    % Coerce horizontal position
    if pos<pmin
        set(this.UI.HM_Position, 'String', pmin); 
        set(this.UI.HM_Position_slider, 'Value', pmin); 
    end
    
    if pos>pmax
        set(this.UI.HM_Position, 'String', pmax); 
        set(this.UI.HM_Position_slider, 'Value', pmax); 
    end

    % Update limits
    set(this.UI.HM_Position_min, 'String', pmin);
    set(this.UI.HM_Position_max, 'String', pmax);
    set(this.UI.HM_Position_slider, 'Min', pmin, 'Max', pmax);
    
    % Update waveforms
    if ~ismember(in.tag, {'All'})
        this.setWaveforms;
    end

end

% --- VM position

% From slider
if ismember(in.tag, {'VM_Position_slider', 'All'})
    
    VMPos = get(this.UI.VM_Position_slider, 'Value');
    set(this.UI.VM_Position, 'String', num2str(round(VMPos)));

end

% From position
if ismember(in.tag, {'VM_Position', 'All'})
    
    VMPos = str2double(get(this.UI.VM_Position, 'String'));
    set(this.UI.VM_Position_slider, 'Value', VMPos);

end

% From +100 increment button
if ismember(in.tag, {'VM_p100'})
    
    p = str2double(get(this.UI.VM_Position, 'String'));
    pmax = str2double(get(this.UI.VM_Position_max, 'String'));
    q = min(pmax, p+100);
    set(this.UI.VM_Position, 'String', q);
    set(this.UI.VM_Position_slider, 'Value', q);
    
end
    
% From +10 increment button
if ismember(in.tag, {'VM_p10'})
    
    p = str2double(get(this.UI.VM_Position, 'String'));
    pmax = str2double(get(this.UI.VM_Position_max, 'String'));
    q = min(pmax, p+10);
    set(this.UI.VM_Position, 'String', q);
    set(this.UI.VM_Position_slider, 'Value', q);
    
end
    
% From +1 increment button
if ismember(in.tag, {'VM_p1'})
    
    p = str2double(get(this.UI.VM_Position, 'String'));
    pmax = str2double(get(this.UI.VM_Position_max, 'String'));
    q = min(pmax, p+1);
    set(this.UI.VM_Position, 'String', q);
    set(this.UI.VM_Position_slider, 'Value', q);
    
end
   
% From center button
if ismember(in.tag, {'VM_Center'})
    
    pmin = str2double(get(this.UI.VM_Position_min, 'String'));
    pmax = str2double(get(this.UI.VM_Position_max, 'String'));
    
    set(this.UI.VM_Position, 'String', (pmin+pmax)/2);
    set(this.UI.VM_Position_slider, 'Value', (pmin+pmax)/2);
    
end
    
% From -1 increment button
if ismember(in.tag, {'VM_m1'})
    
    p = str2double(get(this.UI.VM_Position, 'String'));
    pmin = str2double(get(this.UI.VM_Position_min, 'String'));
    q = max(pmin, p-1);
    set(this.UI.VM_Position, 'String', q);
    set(this.UI.VM_Position_slider, 'Value', q);
    
end

% From -10 increment button
if ismember(in.tag, {'VM_m10'})
    
    p = str2double(get(this.UI.VM_Position, 'String'));
    pmin = str2double(get(this.UI.VM_Position_min, 'String'));
    q = max(pmin, p-10);
    set(this.UI.VM_Position, 'String', q);
    set(this.UI.VM_Position_slider, 'Value', q);
    
end

% From -100 increment button
if ismember(in.tag, {'VM_m100'})
    
    p = str2double(get(this.UI.VM_Position, 'String'));
    pmin = str2double(get(this.UI.VM_Position_min, 'String'));
    q = max(pmin, p-100);
    set(this.UI.VM_Position, 'String', q);
    set(this.UI.VM_Position_slider, 'Value', q);
    
end

% --- OP position

% Default previous value
if isempty(OP_prev)
    OP_prev = str2double(get(this.UI.OP_Position, 'String'));
end

% From slider
if ismember(in.tag, {'OP_Position_slider', 'All'})
    
    p = get(this.UI.OP_Position_slider, 'Value');
    set(this.UI.OP_Position, 'String', num2str(round(p)));

end

% From position
if ismember(in.tag, {'OP_Position', 'All'})
    
    p = str2double(get(this.UI.OP_Position, 'String'));
    set(this.UI.OP_Position_slider, 'Value', p);

end

% From +100 increment button
if ismember(in.tag, {'OP_p100'})
    
    p = str2double(get(this.UI.OP_Position, 'String'));
    pmax = str2double(get(this.UI.OP_Position_max, 'String'));
    q = min(pmax, p+100);
    set(this.UI.OP_Position, 'String', q);
    set(this.UI.OP_Position_slider, 'Value', q);
    
end
    
% From +10 increment button
if ismember(in.tag, {'OP_p10'})
    
    p = str2double(get(this.UI.OP_Position, 'String'));
    pmax = str2double(get(this.UI.OP_Position_max, 'String'));
    q = min(pmax, p+10);
    set(this.UI.OP_Position, 'String', q);
    set(this.UI.OP_Position_slider, 'Value', q);
    
end
    
% From +1 increment button
if ismember(in.tag, {'OP_p1'})
    
    p = str2double(get(this.UI.OP_Position, 'String'));
    pmax = str2double(get(this.UI.OP_Position_max, 'String'));
    q = min(pmax, p+1);
    set(this.UI.OP_Position, 'String', q);
    set(this.UI.OP_Position_slider, 'Value', q);
    
end
   
% From center button
if ismember(in.tag, {'OP_Center'})
    
    pmin = str2double(get(this.UI.OP_Position_min, 'String'));
    pmax = str2double(get(this.UI.OP_Position_max, 'String'));
    
    set(this.UI.OP_Position, 'String', (pmin+pmax)/2);
    set(this.UI.OP_Position_slider, 'Value', (pmin+pmax)/2);
    
end
    
% From -1 increment button
if ismember(in.tag, {'OP_m1'})
    
    p = str2double(get(this.UI.OP_Position, 'String'));
    pmin = str2double(get(this.UI.OP_Position_min, 'String'));
    q = max(pmin, p-1);
    set(this.UI.OP_Position, 'String', q);
    set(this.UI.OP_Position_slider, 'Value', q);
    
end

% From -10 increment button
if ismember(in.tag, {'OP_m10'})
    
    p = str2double(get(this.UI.OP_Position, 'String'));
    pmin = str2double(get(this.UI.OP_Position_min, 'String'));
    q = max(pmin, p-10);
    set(this.UI.OP_Position, 'String', q);
    set(this.UI.OP_Position_slider, 'Value', q);
    
end

% From -100 increment button
if ismember(in.tag, {'OP_m100'})
    
    p = str2double(get(this.UI.OP_Position, 'String'));
    pmin = str2double(get(this.UI.OP_Position_min, 'String'));
    q = max(pmin, p-100);
    set(this.UI.OP_Position, 'String', q);
    set(this.UI.OP_Position_slider, 'Value', q);
    
end

% Lock VM on OP ?
if get(this.UI.Lock, 'Value')
    
    p = str2double(get(this.UI.VM_Position, 'String'));
    pmin = str2double(get(this.UI.VM_Position_min, 'String'));
    pmax = str2double(get(this.UI.VM_Position_max, 'String'));
    dp = str2double(get(this.UI.OP_Position, 'String')) - OP_prev;
    q = min(pmax, max(pmin, p+dp));
    set(this.UI.VM_Position, 'String', q);
    set(this.UI.VM_Position_slider, 'Value', q);
    
end

% Update OP_prev
OP_prev = str2double(get(this.UI.OP_Position, 'String'));
