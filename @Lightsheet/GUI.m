function GUI(this, varargin)

% --- Parameters ----------------------------------------------------------

TitleColor = [0.125 0.125 0.25];

% --- Figure definition ---------------------------------------------------

this.Figures.Main = figure('Visible','off');
set(this.Figures.Main, 'name', ['Lightsheet v' this.Version], 'NumberTitle', 'off');
set(this.Figures.Main, 'menubar', 'none');
set(this.Figures.Main, 'units', 'pixel');
set(this.Figures.Main, 'CloseRequestFcn', @this.stop);

% Get screen size
set(0,'units','pixels')  
screen = get(0,'screensize');
bb = 40;
th = 30;

pos = screen + [-screen(3)-1 bb 0 -bb-th];          % Fullscreen, left screen
% pos = pos + [0 0 -pos(3)/2 0];                    % Left panel
pos = pos + [0 pos(4)/2 -pos(3)/2 -pos(4)/2];       % Top-left corner

set(this.Figures.Main, 'Position', pos);

% === Widgets =============================================================

% --- Top buttons ---------------------------------------------------------

% --- Shutter
this.UI.Shutter = uicontrol(this.Figures.Main, ...
    'Style', 'togglebutton', ...
    'Tag', 'Shutter', ...
    'String', 'Shutter', ...
    'Position', [10 455 100 40]);

% --- Load parameters
this.UI.Load = uicontrol(this.Figures.Main, ...
    'Style', 'pushbutton', ...
    'Tag', 'Load', ...
    'String', 'Load parameters', ...
    'Position', [120 455 100 40], ...
    'Callback', @this.loadParams);

% --- HM Scan
this.UI.HM_Scan = uicontrol(this.Figures.Main, ...
    'Style', 'togglebutton', ...
    'Tag', 'HM_Scan', ...
    'String', 'HM Scan', ...
    'Position', [230 455 100 40]);

% --- Run
this.UI.Run = uicontrol(this.Figures.Main, ...
    'Style', 'togglebutton', ...
    'Tag', 'Run', ...
    'String', 'Run', ...
    'Position', [340 455 100 40], ...
    'Callback', @this.startRun);

% % % % --- Start
% % % this.UI.start = uicontrol(this.Figures.Main, 'Style', 'pushbutton', ...
% % %     'String', 'START', ...
% % %     'Tag', 'Start', ...
% % %     'Position', [740 455 100 40], ...
% % %     'Callback', @this.start);

% % % % --- Stop
% % % this.UI.stop = uicontrol('Style', 'pushbutton', ...
% % %     'String', 'STOP', ...
% % %     'Tag', 'Stop', ...
% % %     'Position', [850 455 100 40], ...
% % %     'Callback', @(src, event) this.stop);

% --- Main Tab Widget -----------------------------------------------------

this.UI.MainTab = uitabgroup(this.Figures.Main, ...
    'Units', 'pixel', ...
    'Tag', 'MainTab', ...
    'Position', [10 10 940 440]);

Tab_Acquisition = uitab(this.UI.MainTab, ...
    'Title', 'Acquisition', ...
    'Tag', 'Acquisition', ...
    'BackgroundColor', [1 1 1]);

Tab_Settings = uitab(this.UI.MainTab, ...
    'Title', 'Settings', ...
    'Tag', 'Settings', ...
    'BackgroundColor', [1 1 1]);

% === Settings tab ========================================================

% --- Horizontal mirror ---------------------------------------------------

% --- Decoration

annotation(Tab_Settings, 'rectangle', ...
    'Units', 'pixel', ...
    'LineStyle', 'none', ...
    'FaceColor', [1 1 1]*0.94, ...
    'Position', [10 335 420 70]);

uicontrol(Tab_Settings, 'Style', 'text', ...
    'String', 'Horizontal mirror position (�m)', ...
    'Position', [20 380 400 20], ...
    'FontWeight', 'bold', ...
    'ForegroundColor', TitleColor, ...
    'HorizontalAlignment', 'center');

% HM position slider
this.UI.HM_Position_slider = uicontrol(Tab_Settings, 'Style', 'slider', ...
    'Tag', 'HM_Position_slider', ...
    'Min', -500, 'Max', 500, 'Value', 0, ...
    'Position', [20 371 400 10], ...
    'Callback', @this.setPositions);

% HM minimal position 
this.UI.HM_Position_min = uicontrol(Tab_Settings, 'Style', 'edit', ...
    'Tag', 'HM_Position_min', ...
    'String', -500, ...
    'Position', [20 345 40 20], ...
    'Callback', @this.setPositions);

% HM position 
this.UI.HM_Position = uicontrol(Tab_Settings, 'Style', 'edit', ...
    'Tag', 'HM_Position', ...
    'String', 0, ...
    'Position', [200 345 40 20], ...
    'Callback', @this.setPositions);

% HM center
this.UI.HM_Center = uicontrol(Tab_Settings, ...
    'Tag', 'HM_Center', ...
    'Style', 'pushbutton', ...
    'String', 'Center', ...
    'Position', [245 345 50 20], ...
    'Callback', @this.setPositions);

% HM maximal position 
this.UI.HM_Position_max = uicontrol(Tab_Settings, 'Style', 'edit', ...
    'Tag', 'HM_Position_max', ...
    'String', 500, ...
    'Position', [380 345 40 20], ...
    'Callback', @this.setPositions);

% HM symmetrize
this.UI.HM_symmetrize = uicontrol(Tab_Settings, 'Style', 'checkbox', ...
    'Tag', 'HM_symmetrize', ...
    'String', 'Symmetrize', ...
    'Position', [65 343 75 20], ...
    'Callback', @this.setPositions);

% --- Vertical Mirror -----------------------------------------------------

% --- Decoration
annotation(Tab_Settings, 'rectangle', ...
    'Units', 'pixel', ...
    'LineStyle', 'none', ...
    'FaceColor', [1 1 1]*0.94, ...
    'Position', [10 10 205 315]);

uicontrol(Tab_Settings, 'Style', 'text', ...
    'String', 'Vertical mirror position (�m)', ...
    'Position', [10 300 205 20], ...
    'FontWeight', 'bold', ...
    'ForegroundColor', TitleColor, ...
    'HorizontalAlignment', 'center');

% VM Slider
this.UI.VM_Position_slider = uicontrol(Tab_Settings, 'Style', 'slider', ...
    'Tag', 'VM_Position_slider', ...
    'Min', 0, 'Max', 400, 'Value', 200, ...
    'Position', [20 20 10 275], ...
    'Callback', @this.setPositions);

% VM minimal position 
this.UI.VM_Position_min = uicontrol(Tab_Settings, 'Style', 'edit', ...
    'Tag', 'VM_Position_min', ...
    'String', 0, ...
    'Position', [35 20 40 20], ...
    'Enable', 'off');

% VM position 
this.UI.VM_Position = uicontrol(Tab_Settings, 'Style', 'edit', ...
    'Tag', 'VM_Position', ...
    'String', 200, ...
    'Position', [35 147.5 40 20], ...
    'Callback', @this.setPositions);

% VM maximal position 
this.UI.VM_Position_max = uicontrol(Tab_Settings, 'Style', 'edit', ...
    'Tag', 'VM_Position_max', ...
    'String', 400, ...
    'Position', [35 275 40 20], ...
    'Enable', 'off');

% VM +100
this.UI.VM_p100 = uicontrol(Tab_Settings, ...
    'Tag', 'VM_p100', ...
    'Style', 'pushbutton', ...
    'String', '+100 �m', ...
    'Position', [112.5 235 50 25], ...
    'Callback', @this.setPositions);

% VM +10
this.UI.VM_p10 = uicontrol(Tab_Settings, ...
    'Tag', 'VM_p10', ...
    'Style', 'pushbutton', ...
    'String', '+10 �m', ...
    'Position', [112.5 205 50 25], ...
    'Callback', @this.setPositions);

% VM +1
this.UI.VM_p1 = uicontrol(Tab_Settings, ...
    'Tag', 'VM_p1', ...
    'Style', 'pushbutton', ...
    'String', '+1 �m', ...
    'Position', [112.5 175 50 25], ...
    'Callback', @this.setPositions);

% VM Center
this.UI.VM_Center = uicontrol(Tab_Settings, ...
    'Tag', 'VM_Center', ...
    'Style', 'pushbutton', ...
    'String', 'Center', ...
    'Position', [100 145 75 25], ...
    'Callback', @this.setPositions);

% VM -1
this.UI.VM_m1 = uicontrol(Tab_Settings, ...
    'Tag', 'VM_m1', ...
    'Style', 'pushbutton', ...
    'String', '-1 �m', ...
    'Position', [112.5 115 50 25], ...
    'Callback', @this.setPositions);

% VM -10
this.UI.VM_m10 = uicontrol(Tab_Settings, ...
    'Tag', 'VM_m10', ...
    'Style', 'pushbutton', ...
    'String', '-10 �m', ...
    'Position', [112.5 85 50 25], ...
    'Callback', @this.setPositions);

% VM -100
this.UI.VM_m100 = uicontrol(Tab_Settings, ...
    'Tag', 'VM_m100', ...
    'Style', 'pushbutton', ...
    'String', '-100 �m', ...
    'Position', [112.5 55 50 25], ...
    'Callback', @this.setPositions);

% Invert VM
this.UI.VM_Invert = uicontrol(Tab_Settings, 'Style', 'checkbox', ...
    'Tag', 'VM_Invert', ...
    'String', 'Invert ?', ...
    'Position', [110 20 75 20]);

% --- Objective piezo -----------------------------------------------------

% --- Decoration
annotation(Tab_Settings, 'rectangle', ...
    'Units', 'pixel', ...
    'LineStyle', 'none', ...
    'FaceColor', [1 1 1]*0.94, ...
    'Position', [225 10 205 315]);

uicontrol(Tab_Settings, 'Style', 'text', ...
    'String', 'Objective piezo position (�m)', ...
    'Position', [225 300 205 20], ...
    'FontWeight', 'bold', ...
    'ForegroundColor', TitleColor, ...
    'HorizontalAlignment', 'center');

% OP Slider
this.UI.OP_Position_slider = uicontrol(Tab_Settings, 'Style', 'slider', ...
    'Tag', 'OP_Position_slider', ...
    'Min', 0, 'Max', 400, 'Value', 200, ...
    'Position', [235 20 10 275], ...
    'Callback', @this.setPositions);

% OP minimal position 
this.UI.OP_Position_min = uicontrol(Tab_Settings, 'Style', 'edit', ...
    'Tag', 'OP_Position_min', ...
    'String', 0, ...
    'Position', [255 20 40 20], ...
    'Enable', 'off');

% OP position 
this.UI.OP_Position = uicontrol(Tab_Settings, 'Style', 'edit', ...
    'Tag', 'OP_Position', ...
    'String', 200, ...
    'Position', [255 147.5 40 20], ...
    'Callback', @this.setPositions);

% OP maximal position 
this.UI.OP_Position_max = uicontrol(Tab_Settings, 'Style', 'edit', ...
    'Tag', 'OP_Position_max', ...
    'String', 400, ...
    'Position', [255 275 40 20], ...
    'Enable', 'off');

% OP +100
this.UI.OP_p100 = uicontrol(Tab_Settings, ...
    'Tag', 'OP_p100', ...
    'Style', 'pushbutton', ...
    'String', '+100 �m', ...
    'Position', [332.5 235 50 25], ...
    'Callback', @this.setPositions);

% OP +10
this.UI.OP_p10 = uicontrol(Tab_Settings, ...
    'Tag', 'OP_p10', ...
    'Style', 'pushbutton', ...
    'String', '+10 �m', ...
    'Position', [332.5 205 50 25], ...
    'Callback', @this.setPositions);

% OP +1
this.UI.OP_p1 = uicontrol(Tab_Settings, ...
    'Tag', 'OP_p1', ...
    'Style', 'pushbutton', ...
    'String', '+1 �m', ...
    'Position', [332.5 175 50 25], ...
    'Callback', @this.setPositions);

% OP Center
this.UI.OP_Center = uicontrol(Tab_Settings, ...
    'Tag', 'OP_Center', ...
    'Style', 'pushbutton', ...
    'String', 'Center', ...
    'Position', [320 145 75 25], ...
    'Callback', @this.setPositions);

% OP -1
this.UI.OP_m1 = uicontrol(Tab_Settings, ...
    'Tag', 'OP_m1', ...
    'Style', 'pushbutton', ...
    'String', '-1 �m', ...
    'Position', [332.5 115 50 25], ...
    'Callback', @this.setPositions);

% OP -10
this.UI.OP_m10 = uicontrol(Tab_Settings, ...
    'Tag', 'OP_m10', ...
    'Style', 'pushbutton', ...
    'String', '-10 �m', ...
    'Position', [332.5 85 50 25], ...
    'Callback', @this.setPositions);

% OP -100
this.UI.OP_m100 = uicontrol(Tab_Settings, ...
    'Tag', 'OP_m100', ...
    'Style', 'pushbutton', ...
    'String', '-100 �m', ...
    'Position', [332.5 55 50 25], ...
    'Callback', @this.setPositions);

% Lock VM on OP ?
this.UI.Lock = uicontrol(Tab_Settings, 'Style', 'checkbox', ...
    'Tag', 'Lock', ...
    'String', 'Lock VM on OP ?', ...
    'Position', [310 20 110 20]);

% --- Coefficients --------------------------------------------------------

xCoeff = 440;
yCoeff = 265;

% --- Decoration
annotation(Tab_Settings, 'rectangle', ...
    'Units', 'pixel', ...
    'LineStyle', 'none', ...
    'FaceColor', [1 1 1]*0.94, ...
    'Position', [xCoeff yCoeff 150 140]);

uicontrol(Tab_Settings, 'Style', 'text', ...
    'String', 'Coefficients (�m > V)', ...
    'Position', [xCoeff yCoeff+115 150 20], ...
    'FontWeight', 'bold', ...
    'ForegroundColor', TitleColor, ...
    'HorizontalAlignment', 'center');

% --- Horizontal mirror

% Text
uicontrol(Tab_Settings, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Horizontal mirror', ...
    'Position', [xCoeff+5 yCoeff+82 90 20]);

% Edit
this.UI.HM_um2V = uicontrol(Tab_Settings, 'Style', 'edit', ...
    'Tag', 'HM_um2V', ...
    'String', 975, ...
    'Position', [xCoeff+100 yCoeff+85 40 20], ...
    'Callback', @this.setPositions);

% --- Vertical mirror

% Text
uicontrol(Tab_Settings, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Vertical mirror', ...
    'Position', [xCoeff+5 yCoeff+57 90 20]);

% Edit
this.UI.VM_um2V = uicontrol(Tab_Settings, 'Style', 'edit', ...
    'Tag', 'VM_um2V', ...
    'String', 131, ...
    'Position', [xCoeff+100 yCoeff+60 40 20], ...
    'Callback', @this.setPositions);

% --- Objective piezo

% Text
uicontrol(Tab_Settings, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Objective piezo', ...
    'Position', [xCoeff+5 yCoeff+32 90 20]);

% Edit
this.UI.OP_um2V = uicontrol(Tab_Settings, 'Style', 'edit', ...
    'Tag', 'OP_um2V', ...
    'String', 40, ...
    'Position', [xCoeff+100 yCoeff+35 40 20], ...
    'Callback', @this.setPositions);

% --- Camera --------------------------------------------------------------

xCam = 600;
yCam = 265;

% --- Decoration
annotation(Tab_Settings, 'rectangle', ...
    'Units', 'pixel', ...
    'LineStyle', 'none', ...
    'FaceColor', [1 1 1]*0.94, ...
    'Position', [xCam yCam 150 140]);

uicontrol(Tab_Settings, 'Style', 'text', ...
    'String', 'Camera', ...
    'Position', [xCam yCam+115 150 20], ...
    'FontWeight', 'bold', ...
    'ForegroundColor', TitleColor, ...
    'HorizontalAlignment', 'center');

% Model
this.UI.Model = uicontrol(Tab_Settings, 'Style', 'popupmenu', ...
    'Tag', 'Model', ...
    'String', {'PCO.edge 5.5' 'PCO.edge 4.2' 'Hamamatsu'}, ...
    'Position', [xCam+10 yCam+85 130 20]);

% Fluo mode
this.UI.FluoMode = uicontrol(Tab_Settings, 'Style', 'popupmenu', ...
    'Tag', 'FluoMode', ...
    'String', {'Single fluo'}, ...
    'Position', [xCam+10 yCam+55 130 20]);

% --- HM mode -------------------------------------------------------------

xHSM = 760;
yHSM = 265;

% --- Decoration
annotation(Tab_Settings, 'rectangle', ...
    'Units', 'pixel', ...
    'LineStyle', 'none', ...
    'FaceColor', [1 1 1]*0.94, ...
    'Position', [xHSM yHSM 170 140]);

uicontrol(Tab_Settings, 'Style', 'text', ...
    'String', 'Horizontal scan', ...
    'Position', [xHSM yHSM+115 170 20], ...
    'FontWeight', 'bold', ...
    'ForegroundColor', TitleColor, ...
    'HorizontalAlignment', 'center');

this.UI.HM_Mode = uitabgroup(Tab_Settings, ...
    'Tag', 'HM_Mode', ...
    'Units', 'pixel', ...
    'Position', [xHSM yHSM 170 115]);

Tab_Independent = uitab(this.UI.HM_Mode, ...
    'Tag', 'Independent', ...
    'Title', 'Independent', ...
    'BackgroundColor', [1 1 1]);

% --- Shape

% Text
uicontrol(Tab_Independent, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Scan shape', ...
    'BackgroundColor', [1 1 1], ...
    'Position', [10 50 60 20]);

% Shape
this.UI.HM_Shape = uicontrol(Tab_Independent, 'Style', 'popupmenu', ...
    'Tag', 'HM_Shape', ...
    'String', {'Sine', 'Sawtooth', 'Triangle'}, ...
    'Position', [75 55 80 20], ...
    'Callback', @this.setWaveforms);


% --- Frequency

% Text
uicontrol(Tab_Independent, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Frequency (Hz)', ...
    'BackgroundColor', [1 1 1], ...
    'Position', [10 17 80 20]);

% Rate
this.UI.HM_Rate = uicontrol(Tab_Independent, 'Style', 'edit', ...
    'Tag', 'HM_Rate', ...
    'String', 200, ...
    'Position', [95 20 50 20], ...
    'Callback', @this.setWaveforms);

% Tab_LineConfocal = uitab(this.UI.HM_Mode, ...
%     'Title', 'Line Confocal', ...
%     'BackgroundColor', [1 1 1]);

% --- Data path -----------------------------------------------------------

xPath = 440;
yPath = 155;

% --- Decoration
annotation(Tab_Settings, 'rectangle', ...
    'Units', 'pixel', ...
    'LineStyle', 'none', ...
    'FaceColor', [1 1 1]*0.94, ...
    'Position', [xPath yPath 485 100]);

uicontrol(Tab_Settings, 'Style', 'text', ...
    'String', 'Data path', ...
    'Position', [xPath yPath+75 485 20], ...
    'FontWeight', 'bold', ...
    'ForegroundColor', TitleColor, ...
    'HorizontalAlignment', 'center');

% --- Data root

% Text
uicontrol(Tab_Settings, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Root path', ...
    'Position', [xPath+10 yPath+47 50 20]);

% Path
this.UI.Root = uicontrol(Tab_Settings, 'Style', 'edit', ...
    'Tag', 'Root', ...
    'String', 'R:\_RAID_', ...
    'HorizontalAlignment', 'left', ...
    'Position', [xPath+70 yPath+50 405 20]);

% --- Study

% Text
uicontrol(Tab_Settings, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Study', ...
    'Position', [xPath+10 yPath+17 50 20]);

% Study
this.UI.Study = uicontrol(Tab_Settings, 'Style', 'popupmenu', ...
    'Tag', 'Study', ...
    'String', {'-', '--'}, ...
    'Position', [xPath+70 yPath+20 150 20]);

% --- Date

% Text
uicontrol(Tab_Settings, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Date', ...
    'Position', [xPath+250 yPath+17 30 20]);

% Date
this.UI.Date = uicontrol(Tab_Settings, 'Style', 'edit', ...
    'Tag', 'Date', ...
    'String', datestr(now, 'yyyy-mm-dd'), ...
    'Position', [xPath+285 yPath+20 100 20]);

% === Acquisition Tab =====================================================

% --- Sheet trajectory ----------------------------------------------------

xTraj = 10;
yTraj = 240;

% --- Decoration
annotation(Tab_Acquisition, 'rectangle', ...
    'Units', 'pixel', ...
    'LineStyle', 'none', ...
    'FaceColor', [1 1 1]*0.94, ...
    'Position', [xTraj yTraj 300 165]);

uicontrol(Tab_Acquisition, 'Style', 'text', ...
    'String', 'Sheet trajectory', ...
    'Position', [xTraj yTraj+135 300 20], ...
    'FontWeight', 'bold', ...
    'ForegroundColor', TitleColor, ...
    'HorizontalAlignment', 'center');

% --- Number of layers

% Text
uicontrol(Tab_Acquisition, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Number of layers', ...
    'Position', [xTraj+10 yTraj+97 85 20]);

% Number of layers
this.UI.NLayers = uicontrol(Tab_Acquisition, 'Style', 'edit', ...
    'Tag', 'NLayers', ...
    'String', 10, ...
    'Position', [xTraj+100 yTraj+100 40 20], ...
    'Callback', @this.setWaveforms);

% --- Vertical scan shape

% Text
uicontrol(Tab_Acquisition, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Steps shape', ...
    'Position', [xTraj+5 yTraj+57 65 20]);

% Scan shape
this.UI.StepsShape = uicontrol(Tab_Acquisition, 'Style', 'popupmenu', ...
    'Tag', 'StepsShape', ...
    'String', {'Sawtooth'}, ...
    'Position', [xTraj+73 yTraj+61 80 20], ...
    'Callback', @this.setWaveforms);

% --- z-Increment

% Text
uicontrol(Tab_Acquisition, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Increment                �m', ...
    'Position', [xTraj+10 yTraj+32 120 20]);

% Increment
this.UI.Increment = uicontrol(Tab_Acquisition, 'Style', 'edit', ...
    'Tag', 'Increment', ...
    'String', 8, ...
    'Position', [xTraj+73 yTraj+35 40 20], ...
    'Callback', @this.setWaveforms);

% --- Total height

% Text
uicontrol(Tab_Acquisition, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Total height                �m', ...
    'Position', [xTraj+10 yTraj+7 120 20]);

% Height
this.UI.Height = uicontrol(Tab_Acquisition, 'Style', 'edit', ...
    'Tag', 'Height', ...
    'String', '', ...
    'Position', [xTraj+73 yTraj+10 40 20], ...
    'Callback', @this.setWaveforms);

% --- Exposure

% Text
uicontrol(Tab_Acquisition, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Exposure                ms', ...
    'Position', [xTraj+177 yTraj+107 110 20]);

% Exposure
this.UI.Exposure = uicontrol(Tab_Acquisition, 'Style', 'edit', ...
    'Tag', 'Exposure', ...
    'String', 40, ...
    'Position', [xTraj+230 yTraj+110 40 20], ...
    'Callback', @this.setWaveforms);

% --- Delay

% Text
uicontrol(Tab_Acquisition, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Delay                ms', ...
    'Position', [xTraj+177 yTraj+82 110 20]);

% Delay
this.UI.Delay = uicontrol(Tab_Acquisition, 'Style', 'edit', ...
    'Tag', 'Delay', ...
    'String', 10, ...
    'Position', [xTraj+230 yTraj+85 40 20], ...
    'Callback', @this.setWaveforms);

% --- Long delay

% Text
uicontrol(Tab_Acquisition, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Long delay                ms', ...
    'Position', [xTraj+167 yTraj+57 120 20]);

% Long delay
this.UI.DelayLong = uicontrol(Tab_Acquisition, 'Style', 'edit', ...
    'Tag', 'DelayLong', ...
    'String', 10, ...
    'Position', [xTraj+230 yTraj+60 40 20], ...
    'Callback', @this.setWaveforms);

% --- Stabilization shape

% Text
uicontrol(Tab_Acquisition, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Stab. shape', ...
    'Position', [xTraj+147 yTraj+32 80 20]);

% Stab. shape
this.UI.StabShape = uicontrol(Tab_Acquisition, 'Style', 'popupmenu', ...
    'Tag', 'StabShape', ...
    'String', {'Linear'}, ...
    'Position', [xTraj+230 yTraj+36 60 20], ...
    'Callback', @this.setWaveforms);

% --- Stabilization ratio

% Text
uicontrol(Tab_Acquisition, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Stab. ratio (%)', ...
    'Position', [xTraj+150 yTraj+7 80 20]);

% Stab. ratio
this.UI.StabRatio = uicontrol(Tab_Acquisition, 'Style', 'edit', ...
    'Tag', 'StabRatio', ...
    'String', 50, ...
    'Position', [xTraj+230 yTraj+10 40 20], ...
    'Callback', @this.setWaveforms);

% --- Waveforms -----------------------------------------------------------

this.UI.Waveforms = axes(Tab_Acquisition, ...
    'Units', 'pixel', ...
    'Position', [50 45 255 180], ...
    'FontSize', 8);

% --- Timing summary ------------------------------------------------------

xSum = 320;
ySum = 240;

% --- Decoration
annotation(Tab_Acquisition, 'rectangle', ...
    'Units', 'pixel', ...
    'LineStyle', 'none', ...
    'FaceColor', [1 1 1]*0.94, ...
    'Position', [xSum ySum 300 165]);

uicontrol(Tab_Acquisition, 'Style', 'text', ...
    'String', 'Timing summary', ...
    'Position', [xSum ySum+135 300 20], ...
    'FontWeight', 'bold', ...
    'ForegroundColor', TitleColor, ...
    'HorizontalAlignment', 'center');

% --- Number of cycles

% Text
uicontrol(Tab_Acquisition, 'Style', 'text', 'HorizontalAlignment', 'center', ...
    'String', 'Number of cycles', ...
    'Position', [xSum+25 ySum+103 125 20]);

% Number of cycles
this.UI.NCycles = uicontrol(Tab_Acquisition, 'Style', 'edit', ...
    'Tag', 'NCycles', ...
    'String', 3, ...
    'Position', [xSum+50 ySum+85 70 20], ...
    'Callback', @this.setTiming);

% --- Cycle time

% Text
uicontrol(Tab_Acquisition, 'Style', 'text', 'HorizontalAlignment', 'center', ...
    'String', 'Cycle time (ms)', ...
    'Position', [xSum+155 ySum+103 125 20]);

% Cycle time
this.UI.CycleTime = uicontrol(Tab_Acquisition, 'Style', 'edit', ...
    'Tag', 'CycleTime', ...
    'String', 10, ...
    'Position', [xSum+180 ySum+85 70 20], ...
    'Enable', 'off');

% --- Total number of frames

% Text
uicontrol(Tab_Acquisition, 'Style', 'text', 'HorizontalAlignment', 'center', ...
    'String', 'Total number of frames', ...
    'Position', [xSum+25 ySum+53 125 20]);

% Number of frames
this.UI.NFrames = uicontrol(Tab_Acquisition, 'Style', 'edit', ...
    'Tag', 'NFrames', ...
    'String', 1000, ...
    'Position', [xSum+50 ySum+35 70 20], ...
    'Callback', @this.setTiming);

% --- Total acquisition time

% Text
uicontrol(Tab_Acquisition, 'Style', 'text', 'HorizontalAlignment', 'center', ...
    'String', 'Run time (s)', ...
    'Position', [xSum+155 ySum+53 125 20]);

% Run time
this.UI.RunTime = uicontrol(Tab_Acquisition, 'Style', 'edit', ...
    'Tag', 'RunTime', ...
    'String', 10, ...
    'Position', [xSum+180 ySum+35 70 20], ...
    'Callback', @this.setTiming);

% Run time (human-readable)
this.UI.RunTimeHuman = uicontrol(Tab_Acquisition, 'Style', 'text', ...
    'Tag', 'RunTimeHuman', ...
    'HorizontalAlignment', 'center', ...
    'String', '00h 00m 10s', ...
    'Position', [xSum+180 ySum+12 70 20], ...
    'ForegroundColor', [1 1 1]*0.4);

% --- Runs ----------------------------------------------------------------

xRun = 630;
yRun = 10;

% --- Decoration
annotation(Tab_Acquisition, 'rectangle', ...
    'Units', 'pixel', ...
    'LineStyle', 'none', ...
    'FaceColor', [1 1 1]*0.94, ...
    'Position', [xRun yRun 300 395]);

uicontrol(Tab_Acquisition, 'Style', 'text', ...
    'String', 'Runs', ...
    'Position', [xRun yRun+365 300 20], ...
    'FontWeight', 'bold', ...
    'ForegroundColor', TitleColor, ...
    'HorizontalAlignment', 'center');

% --- Refresh
this.UI.RefreshRuns = uicontrol(Tab_Acquisition, ...
    'Style', 'pushbutton', ...
    'Tag', 'RefreshRuns', ...
    'String', 'Refresh', ...
    'Position', [xRun+10 yRun+10 90 30], ...
    'Callback', @this.refreshRuns);

% --- New Run
this.UI.NewRun = uicontrol(Tab_Acquisition, ...
    'Style', 'pushbutton', ...
    'Tag', 'NewRun', ...
    'String', 'New Run', ...
    'Position', [xRun+105 yRun+10 90 30], ...
    'Callback', @this.newRun);

% --- Save params
this.UI.SaveParams = uicontrol(Tab_Acquisition, ...
    'Style', 'pushbutton', ...
    'Tag', 'SaveParam', ...
    'String', 'Save Parameters', ...
    'Position', [xRun+200 yRun+10 90 30], ...
    'Callback', @this.saveParams);

% --- Runs table
this.UI.Runs = uitable(Tab_Acquisition, ...
    'Tag', 'Runs', ...
    'Data', {}, ...
    'RowName', [], ...
    'ColumnName', {'' 'Params' 'Fluo' 'Behavior' 'Inputs'}, ...
    'ColumnWidth', {58 55 55 55 55}, ...
    'Position', [xRun+10 yRun+50 280 310], ...
    'CellSelectionCallback', @this.selectRun);


% === Listeners ===========================================================

% Sliders
addlistener(this.UI.HM_Position_slider, 'ContinuousValueChange', @this.setPositions);
addlistener(this.UI.VM_Position_slider, 'ContinuousValueChange', @this.setPositions);
addlistener(this.UI.OP_Position_slider, 'ContinuousValueChange', @this.setPositions);

% --- Display -------------------------------------------------------------

set(this.Figures.Main, 'visible', 'on');