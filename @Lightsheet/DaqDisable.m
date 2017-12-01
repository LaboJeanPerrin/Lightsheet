function DaqDisable(this, state)

if state
    str = 'off';
else
    str = 'on';
end

% --- Top buttons
set(this.UI.Shutter, 'Enable', str);
set(this.UI.HM_Scan, 'Enable', str);
set(this.UI.Run, 'Enable', str);

% --- Control tab
set(this.UI.HM_Position_slider, 'Enable', str);
set(this.UI.HM_Position_min, 'Enable', str);
set(this.UI.HM_Position, 'Enable', str);
set(this.UI.HM_Center, 'Enable', str);
set(this.UI.HM_Position_max, 'Enable', str);
set(this.UI.HM_symmetrize, 'Enable', str);
set(this.UI.VM_Position_slider, 'Enable', str);
set(this.UI.VM_Position_min, 'Enable', str);
set(this.UI.VM_Position, 'Enable', str);
set(this.UI.VM_Position_max, 'Enable', str);
set(this.UI.VM_p100, 'Enable', str);
set(this.UI.VM_p10, 'Enable', str);
set(this.UI.VM_p1, 'Enable', str);
set(this.UI.VM_Center, 'Enable', str);
set(this.UI.VM_m1, 'Enable', str);
set(this.UI.VM_m10, 'Enable', str);
set(this.UI.VM_m100, 'Enable', str);
set(this.UI.VM_Invert, 'Enable', str);
set(this.UI.OP_Position_slider, 'Enable', str);
set(this.UI.OP_Position_min, 'Enable', str);
set(this.UI.OP_Position, 'Enable', str);
set(this.UI.OP_Position_max, 'Enable', str);
set(this.UI.OP_p100, 'Enable', str);
set(this.UI.OP_p10, 'Enable', str);
set(this.UI.OP_p1, 'Enable', str);
set(this.UI.OP_Center, 'Enable', str);
set(this.UI.OP_m1, 'Enable', str);
set(this.UI.OP_m10, 'Enable', str);
set(this.UI.OP_m100, 'Enable', str);
set(this.UI.Stim_1, 'Enable', str);
set(this.UI.Stim_2, 'Enable', str);
