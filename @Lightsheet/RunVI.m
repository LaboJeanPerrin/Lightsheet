function RunVI(this, varargin)
% Run Labview VI

% --- Get the vi instance
this.vi = invoke(actxserver('LabVIEW.Application'), 'GetVIReference', get(this.UI.VIpath, 'string'));

this.vi.SetControlValue('Trig', false);

% --- Set control values
this.UpdateVI;

% --- Run VI
% Note: Run method first parameter
%   0 - wait for vi end (blocking)
%   1 - continue execution (non-blocking)

this.vi.Run(1);  


