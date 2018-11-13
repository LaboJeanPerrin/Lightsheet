function UpdateVI(this, varargin)
% Update Labview VI

% Check vi state
if isempty(this.vi), return; end

% --- Set control values
this.vi.SetControlValue('Root path', get(this.UI.Root, 'string'));
tmp = get(this.UI.Study, 'string');
this.vi.SetControlValue('Study', tmp{get(this.UI.Study, 'value')});
this.vi.SetControlValue('Date', get(this.UI.Date, 'string'));
this.vi.SetControlValue('Run selected',this.Run.Name );