function GUI(this, varargin)

% --- Parameters ----------------------------------------------------------

TitleColor = [0.125 0.125 0.25];

% --- Figure definition ---------------------------------------------------

this.Figures.Main = figure('Visible','off');
set(this.Figures.Main, 'name', ['Lightsheet v' this.Version], 'NumberTitle', 'off');
set(this.Figures.Main, 'menubar', 'none');
set(this.Figures.Main, 'units', 'pixel');
set(this.Figures.Main, 'CloseRequestFcn', @this.stop);

% Set window position
set(0,'units','pixels') ;
monitors = get(0, 'MonitorPositions');
screen = monitors(2,:);
bb = 40;
pos = [screen(1) screen(4)/2+bb screen(2)+screen(3)/2 screen(4)/2-bb];

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

% --- Main Tab Widget -----------------------------------------------------

this.UI.MainTab = uitabgroup(this.Figures.Main, ...
    'Units', 'pixel', ...
    'Tag', 'MainTab', ...
    'Position', [10 10 940 440]);

Tab_Settings = uitab(this.UI.MainTab, ...
    'Title', 'Settings', ...
    'Tag', 'Settings', ...
    'BackgroundColor', [1 1 1]);

Tab_Control = uitab(this.UI.MainTab, ...
    'Title', 'Control', ...
    'Tag', 'Control', ...
    'BackgroundColor', [1 1 1]);

Tab_Acquisition = uitab(this.UI.MainTab, ...
    'Title', 'Acquisition', ...
    'Tag', 'Acquisition', ...
    'BackgroundColor', [1 1 1]);

this.UI.MainTab.SelectedTab = Tab_Control;

% === Settings tab ========================================================

% --- Camera --------------------------------------------------------------

xCam = 10;
yCam = 305;

% --- Decoration
annotation(Tab_Settings, 'rectangle', ...
    'Units', 'pixel', ...
    'LineStyle', 'none', ...
    'FaceColor', [1 1 1]*0.94, ...
    'Position', [xCam yCam 150 100]);

uicontrol(Tab_Settings, 'Style', 'text', ...
    'String', 'Camera', ...
    'Position', [xCam yCam+75 150 20], ...
    'FontWeight', 'bold', ...
    'ForegroundColor', TitleColor, ...
    'HorizontalAlignment', 'center');

% Model
this.UI.Model = uicontrol(Tab_Settings, 'Style', 'popupmenu', ...
    'Tag', 'Model', ...
    'String', {'PCO.edge 5.5' ; 'PCO.edge 4.2' ; 'Hamamatsu ORCA Flash 4.0'}, ...
    'Position', [xCam+10 yCam+45 130 20]);

% Fluo mode
this.UI.FluoMode = uicontrol(Tab_Settings, 'Style', 'popupmenu', ...
    'Tag', 'FluoMode', ...
    'String', {'Single fluo'}, ...
    'Position', [xCam+10 yCam+15 130 20]);

% --- Data path -----------------------------------------------------------

xPath = 168;
yPath = 305;

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
    'String', '', ...
    'HorizontalAlignment', 'left', ...
    'Position', [xPath+70 yPath+50 405 20], ...
    'Callback', @this.UpdateVI);

% --- Study

% Text
uicontrol(Tab_Settings, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Study', ...
    'Position', [xPath+10 yPath+17 50 20]);

% Study
this.UI.Study = uicontrol(Tab_Settings, 'Style', 'popupmenu', ...
    'Tag', 'Study', ...
    'String', {'-'}, ...
    'Position', [xPath+70 yPath+20 150 20], ...
    'Callback', @this.UpdateVI);

% --- Date

% Text
uicontrol(Tab_Settings, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Date', ...
    'Position', [xPath+250 yPath+17 30 20]);

% Date
this.UI.Date = uicontrol(Tab_Settings, 'Style', 'edit', ...
    'Tag', 'Date', ...
    'String', datestr(now, 'yyyy-mm-dd'), ...
    'Position', [xPath+285 yPath+20 100 20], ...
    'Enable', 'off');

% --- VI instantiation ----------------------------------------------------

xVI = 10;
yVI = 178;

% --- Decoration

annotation(Tab_Settings, 'rectangle', ...
    'Units', 'pixel', ...
    'LineStyle', 'none', ...
    'FaceColor', [1 1 1]*0.94, ...
    'Position', [xVI yVI 915 120]);

uicontrol(Tab_Settings, 'Style', 'text', ...
    'String', 'NI Labview VI', ...
    'Position', [xVI yVI+95 915 20], ...
    'FontWeight', 'bold', ...
    'ForegroundColor', TitleColor, ...
    'HorizontalAlignment', 'center');

% --- VI file

% Text
uicontrol(Tab_Settings, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'VI path', ...
    'Position', [xVI yVI+65 45 20]);

% Path
this.UI.VIpath = uicontrol(Tab_Settings, 'Style', 'edit', ...
    'Tag', 'VIpath', ...
    'String', 'C:\Users\FLASH 4.0\Documents\Science\Programing\Labview\RLS\Motor\Motor.vi', ...
    'HorizontalAlignment', 'left', ...
    'Position', [xVI+50 yVI+67 700 20]);

% Launch
this.UI.VIrun = uicontrol(Tab_Settings, ...
    'Style', 'pushbutton', ...
    'Tag', 'VIrun', ...
    'String', 'Run', ...
    'Position', [xVI+760 yVI+65 90 25], ...
    'Callback', @this.RunVI);

% % % % --- TCP command
% % % 
% % % % Text
% % % uicontrol(Tab_Settings, 'Style', 'text', 'HorizontalAlignment', 'right', ...
% % %     'String', 'Command', ...
% % %     'Position', [xVI yVI+15 55 20]);
% % % 
% % % % TCP Command
% % % this.UI.TCPcommand = uicontrol(Tab_Settings, 'Style', 'edit', ...
% % %     'Tag', 'TCPcommand', ...
% % %     'String', 'test_command_tcp', ...
% % %     'HorizontalAlignment', 'left', ...
% % %     'Position', [xVI+60 yVI+18 300 20]);
% % % 
% % % % Send
% % % this.UI.TCPsend = uicontrol(Tab_Settings, ...
% % %     'Style', 'pushbutton', ...
% % %     'Tag', 'TCPsend', ...
% % %     'String', 'Send', ...
% % %     'Position', [xVI+370 yVI+15 90 25], ...
% % %     'Callback', @(src,event) this.TCP.write(this.TCP,src,get(this.UI.TCPcommand, 'string')));

% === Control tab =========================================================

% --- Horizontal mirror ---------------------------------------------------

% --- Decoration

annotation(Tab_Control, 'rectangle', ...
    'Units', 'pixel', ...
    'LineStyle', 'none', ...
    'FaceColor', [1 1 1]*0.94, ...
    'Position', [10 335 420 70]);

uicontrol(Tab_Control, 'Style', 'text', ...
    'String', 'Horizontal mirror position (�m)', ...
    'Position', [20 380 400 20], ...
    'FontWeight', 'bold', ...
    'ForegroundColor', TitleColor, ...
    'HorizontalAlignment', 'center');

% HM position slider
this.UI.HM_Position_slider = uicontrol(Tab_Control, 'Style', 'slider', ...
    'Tag', 'HM_Position_slider', ...
    'Min', -1, 'Max', 1, 'Value', 0, ...
    'Position', [20 371 400 10], ...
    'Callback', @this.setPositions);

% HM minimal position 
this.UI.HM_Position_min = uicontrol(Tab_Control, 'Style', 'edit', ...
    'Tag', 'HM_Position_min', ...
    'String', -1, ...
    'Position', [20 345 40 20], ...
    'Callback', @this.setPositions);

% HM position 
this.UI.HM_Position = uicontrol(Tab_Control, 'Style', 'edit', ...
    'Tag', 'HM_Position', ...
    'String', 0, ...
    'Position', [200 345 40 20], ...
    'Callback', @this.setPositions);

% HM center
this.UI.HM_Center = uicontrol(Tab_Control, ...
    'Tag', 'HM_Center', ...
    'Style', 'pushbutton', ...
    'String', 'Center', ...
    'Position', [245 345 50 20], ...
    'Callback', @this.setPositions);

% HM maximal position 
this.UI.HM_Position_max = uicontrol(Tab_Control, 'Style', 'edit', ...
    'Tag', 'HM_Position_max', ...
    'String', 1, ...
    'Position', [380 345 40 20], ...
    'Callback', @this.setPositions);

% HM symmetrize
this.UI.HM_symmetrize = uicontrol(Tab_Control, 'Style', 'checkbox', ...
    'Tag', 'HM_symmetrize', ...
    'String', 'Symmetrize', ...
    'Position', [65 343 75 20], ...
    'Callback', @this.setPositions);

% --- Vertical Mirror -----------------------------------------------------

% --- Decoration
annotation(Tab_Control, 'rectangle', ...
    'Units', 'pixel', ...
    'LineStyle', 'none', ...
    'FaceColor', [1 1 1]*0.94, ...
    'Position', [10 10 205 315]);

uicontrol(Tab_Control, 'Style', 'text', ...
    'String', 'Vertical mirror position (�m)', ...
    'Position', [10 300 205 20], ...
    'FontWeight', 'bold', ...
    'ForegroundColor', TitleColor, ...
    'HorizontalAlignment', 'center');

% VM Slider
this.UI.VM_Position_slider = uicontrol(Tab_Control, 'Style', 'slider', ...
    'Tag', 'VM_Position_slider', ...
    'Min', 0, 'Max', 400, 'Value', 200, ...
    'Position', [20 20 10 275], ...
    'Callback', @this.setPositions);

% VM minimal position 
this.UI.VM_Position_min = uicontrol(Tab_Control, 'Style', 'edit', ...
    'Tag', 'VM_Position_min', ...
    'String', 0, ...
    'Position', [35 20 40 20], ...
    'Enable', 'off');

% VM position 
this.UI.VM_Position = uicontrol(Tab_Control, 'Style', 'edit', ...
    'Tag', 'VM_Position', ...
    'String', 200, ...
    'Position', [35 147.5 40 20], ...
    'Callback', @this.setPositions);

% VM maximal position 
this.UI.VM_Position_max = uicontrol(Tab_Control, 'Style', 'edit', ...
    'Tag', 'VM_Position_max', ...
    'String', 400, ...
    'Position', [35 275 40 20], ...
    'Enable', 'off');

% VM +100
this.UI.VM_p100 = uicontrol(Tab_Control, ...
    'Tag', 'VM_p100', ...
    'Style', 'pushbutton', ...
    'String', '+100 �m', ...
    'Position', [112.5 235 50 25], ...
    'Callback', @this.setPositions);

% VM +10
this.UI.VM_p10 = uicontrol(Tab_Control, ...
    'Tag', 'VM_p10', ...
    'Style', 'pushbutton', ...
    'String', '+10 �m', ...
    'Position', [112.5 205 50 25], ...
    'Callback', @this.setPositions);

% VM +1
this.UI.VM_p1 = uicontrol(Tab_Control, ...
    'Tag', 'VM_p1', ...
    'Style', 'pushbutton', ...
    'String', '+1 �m', ...
    'Position', [112.5 175 50 25], ...
    'Callback', @this.setPositions);

% VM Center
this.UI.VM_Center = uicontrol(Tab_Control, ...
    'Tag', 'VM_Center', ...
    'Style', 'pushbutton', ...
    'String', 'Center', ...
    'Position', [100 145 75 25], ...
    'Callback', @this.setPositions);

% VM -1
this.UI.VM_m1 = uicontrol(Tab_Control, ...
    'Tag', 'VM_m1', ...
    'Style', 'pushbutton', ...
    'String', '-1 �m', ...
    'Position', [112.5 115 50 25], ...
    'Callback', @this.setPositions);

% VM -10
this.UI.VM_m10 = uicontrol(Tab_Control, ...
    'Tag', 'VM_m10', ...
    'Style', 'pushbutton', ...
    'String', '-10 �m', ...
    'Position', [112.5 85 50 25], ...
    'Callback', @this.setPositions);

% VM -100
this.UI.VM_m100 = uicontrol(Tab_Control, ...
    'Tag', 'VM_m100', ...
    'Style', 'pushbutton', ...
    'String', '-100 �m', ...
    'Position', [112.5 55 50 25], ...
    'Callback', @this.setPositions);

% Invert VM
this.UI.VM_Invert = uicontrol(Tab_Control, 'Style', 'checkbox', ...
    'Tag', 'VM_Invert', ...
    'String', 'Invert ?', ...
    'Position', [110 20 75 20]);

% --- Objective piezo -----------------------------------------------------

% --- Decoration
annotation(Tab_Control, 'rectangle', ...
    'Units', 'pixel', ...
    'LineStyle', 'none', ...
    'FaceColor', [1 1 1]*0.94, ...
    'Position', [225 10 205 315]);

uicontrol(Tab_Control, 'Style', 'text', ...
    'String', 'Objective piezo position (�m)', ...
    'Position', [225 300 205 20], ...
    'FontWeight', 'bold', ...
    'ForegroundColor', TitleColor, ...
    'HorizontalAlignment', 'center');

% OP Slider
this.UI.OP_Position_slider = uicontrol(Tab_Control, 'Style', 'slider', ...
    'Tag', 'OP_Position_slider', ...
    'Min', 0, 'Max', 400, 'Value', 200, ...
    'Position', [235 20 10 275], ...
    'Callback', @this.setPositions);

% OP minimal position 
this.UI.OP_Position_min = uicontrol(Tab_Control, 'Style', 'edit', ...
    'Tag', 'OP_Position_min', ...
    'String', 0, ...
    'Position', [255 20 40 20], ...
    'Enable', 'off');

% OP position 
this.UI.OP_Position = uicontrol(Tab_Control, 'Style', 'edit', ...
    'Tag', 'OP_Position', ...
    'String', 200, ...
    'Position', [255 147.5 40 20], ...
    'Callback', @this.setPositions);

% OP maximal position 
this.UI.OP_Position_max = uicontrol(Tab_Control, 'Style', 'edit', ...
    'Tag', 'OP_Position_max', ...
    'String', 400, ...
    'Position', [255 275 40 20], ...
    'Enable', 'off');

% OP +100
this.UI.OP_p100 = uicontrol(Tab_Control, ...
    'Tag', 'OP_p100', ...
    'Style', 'pushbutton', ...
    'String', '+100 �m', ...
    'Position', [332.5 235 50 25], ...
    'Callback', @this.setPositions);

% OP +10
this.UI.OP_p10 = uicontrol(Tab_Control, ...
    'Tag', 'OP_p10', ...
    'Style', 'pushbutton', ...
    'String', '+10 �m', ...
    'Position', [332.5 205 50 25], ...
    'Callback', @this.setPositions);

% OP +1
this.UI.OP_p1 = uicontrol(Tab_Control, ...
    'Tag', 'OP_p1', ...
    'Style', 'pushbutton', ...
    'String', '+1 �m', ...
    'Position', [332.5 175 50 25], ...
    'Callback', @this.setPositions);

% OP Center
this.UI.OP_Center = uicontrol(Tab_Control, ...
    'Tag', 'OP_Center', ...
    'Style', 'pushbutton', ...
    'String', 'Center', ...
    'Position', [320 145 75 25], ...
    'Callback', @this.setPositions);

% OP -1
this.UI.OP_m1 = uicontrol(Tab_Control, ...
    'Tag', 'OP_m1', ...
    'Style', 'pushbutton', ...
    'String', '-1 �m', ...
    'Position', [332.5 115 50 25], ...
    'Callback', @this.setPositions);

% OP -10
this.UI.OP_m10 = uicontrol(Tab_Control, ...
    'Tag', 'OP_m10', ...
    'Style', 'pushbutton', ...
    'String', '-10 �m', ...
    'Position', [332.5 85 50 25], ...
    'Callback', @this.setPositions);

% OP -100
this.UI.OP_m100 = uicontrol(Tab_Control, ...
    'Tag', 'OP_m100', ...
    'Style', 'pushbutton', ...
    'String', '-100 �m', ...
    'Position', [332.5 55 50 25], ...
    'Callback', @this.setPositions);

% Lock VM on OP ?
this.UI.Lock = uicontrol(Tab_Control, 'Style', 'checkbox', ...
    'Tag', 'Lock', ...
    'String', 'Lock VM on OP ?', ...
    'Position', [310 20 110 20]);

% --- Coefficients --------------------------------------------------------

xCoeff = 440;
yCoeff = 265;

% --- Decoration
annotation(Tab_Control, 'rectangle', ...
    'Units', 'pixel', ...
    'LineStyle', 'none', ...
    'FaceColor', [1 1 1]*0.94, ...
    'Position', [xCoeff yCoeff 150 140]);

uicontrol(Tab_Control, 'Style', 'text', ...
    'String', 'Coefficients (�m > V)', ...
    'Position', [xCoeff yCoeff+115 150 20], ...
    'FontWeight', 'bold', ...
    'ForegroundColor', TitleColor, ...
    'HorizontalAlignment', 'center');

% --- Horizontal mirror

% Text
uicontrol(Tab_Control, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Horizontal mirror', ...
    'Position', [xCoeff+5 yCoeff+82 90 20]);

% Edit
this.UI.HM_um2V = uicontrol(Tab_Control, 'Style', 'edit', ...
    'Tag', 'HM_um2V', ...
    'String', 975, ...
    'Position', [xCoeff+100 yCoeff+85 40 20], ...
    'Callback', @this.setPositions);

% --- Vertical mirror

% Text
uicontrol(Tab_Control, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Vertical mirror', ...
    'Position', [xCoeff+5 yCoeff+57 90 20]);

% Edit
this.UI.VM_um2V = uicontrol(Tab_Control, 'Style', 'edit', ...
    'Tag', 'VM_um2V', ...
    'String', 131, ...
    'Position', [xCoeff+100 yCoeff+60 40 20], ...
    'Callback', @this.setPositions);

% --- Objective piezo

% Text
uicontrol(Tab_Control, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Objective piezo', ...
    'Position', [xCoeff+5 yCoeff+32 90 20]);

% Edit
this.UI.OP_um2V = uicontrol(Tab_Control, 'Style', 'edit', ...
    'Tag', 'OP_um2V', ...
    'String', 40, ...
    'Position', [xCoeff+100 yCoeff+35 40 20], ...
    'Callback', @this.setPositions);

% --- Corrections ---------------------------------------------------------

xCorr = 440;
yCorr = 198;

% --- Decoration
annotation(Tab_Control, 'rectangle', ...
    'Units', 'pixel', ...
    'LineStyle', 'none', ...
    'FaceColor', [1 1 1]*0.94, ...
    'Position', [xCorr yCorr 150 60]);

uicontrol(Tab_Control, 'Style', 'text', ...
    'String', 'Corrections (�m)', ...
    'Position', [xCorr yCorr+35 150 20], ...
    'FontWeight', 'bold', ...
    'ForegroundColor', TitleColor, ...
    'HorizontalAlignment', 'center');

% --- Vertical correction

% Text
uicontrol(Tab_Control, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Vertical (HM & OP)', ...
    'Position', [xCorr+2 yCorr+2 97 20]);

% Edit
this.UI.CorrVert = uicontrol(Tab_Control, 'Style', 'edit', ...
    'Tag', 'CorrVert', ...
    'String', 0, ...
    'Position', [xCorr+100 yCorr+5 40 20], ...
    'Enable', 'off');

% --- Buttons -------------------------------------------------------------

% --- EZ Stimulus
this.UI.Stim = uicontrol(Tab_Control, ...
    'Style', 'togglebutton', ...
    'Tag', 'Stim', ...
    'String', 'Stim', ...
    'Position', [830 367 100 40]);

% --- Error
% % % this.UI.Error = uicontrol(Tab_Control, 'Style', 'togglebutton', ...
% % %     'String', 'ERROR', ...
% % %     'Tag', 'Error', ...
% % %     'Position', [830 367 100 40]);

% === Acquisition Tab =====================================================

% --- Waveforms -----------------------------------------------------------

this.UI.Waveforms = axes(Tab_Acquisition, ...
    'Units', 'pixel', ...
    'Position', [60 220 290 180], ...
    'FontSize', 8);

% --- Horizontal trajectory -----------------------------------------------

xHSM = 400;
yHSM = 185;

% --- Decoration
annotation(Tab_Acquisition, 'rectangle', ...
    'Units', 'pixel', ...
    'LineStyle', 'none', ...
    'FaceColor', [1 1 1]*0.94, ...
    'Position', [xHSM yHSM 220 220]);

uicontrol(Tab_Acquisition, 'Style', 'text', ...
    'String', 'Horizontal trajectory', ...
    'Position', [xHSM yHSM+190 220 20], ...
    'FontWeight', 'bold', ...
    'ForegroundColor', TitleColor, ...
    'HorizontalAlignment', 'center');

this.UI.HM_Mode = uitabgroup(Tab_Acquisition, ...
    'Tag', 'HM_Mode', ...
    'Units', 'pixel', ...
    'Position', [xHSM+10 yHSM+35 200 150], ...
    'SelectionChangedFcn', @this.setWaveforms);

Tab_Independent = uitab(this.UI.HM_Mode, ...
    'Tag', 'Independent', ...
    'Title', 'Independent', ...
    'BackgroundColor', [1 1 1]);

Tab_Slave = uitab(this.UI.HM_Mode, ...
    'Tag', 'Slave', ...
    'Title', 'Slave', ...
    'BackgroundColor', [1 1 1]);

this.UI.HM_Mode.SelectedTab = Tab_Slave;

% --- Display horizontal trajectory ?
this.UI.DispHM = uicontrol(Tab_Acquisition, 'Style', 'checkbox', ...
    'Tag', 'DispHM', ...
    'String', 'Display horizontal trajectory ?', ...
    'Position', [xHSM+10 yHSM+10 200 20], ...
    'Callback', @this.setWaveforms);

% --- INDEPENDENT ---

% --- Shape

% Text
uicontrol(Tab_Independent, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Scan shape', ...
    'BackgroundColor', [1 1 1], ...
    'Position', [10 80 60 20]);

% Shape
this.UI.HM_Shape = uicontrol(Tab_Independent, 'Style', 'popupmenu', ...
    'Tag', 'HM_Shape', ...
    'String', {'Sine', 'Sawtooth', 'Triangle'}, ...
    'Value', 3, ...
    'Position', [75 85 80 20], ...
    'Callback', @this.setWaveforms);

% --- Frequency

% Text
uicontrol(Tab_Independent, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Frequency (Hz)', ...
    'BackgroundColor', [1 1 1], ...
    'Position', [10 47 80 20]);

% Rate
this.UI.HM_Rate = uicontrol(Tab_Independent, 'Style', 'edit', ...
    'Tag', 'HM_Rate', ...
    'String', 200.5, ...
    'Position', [95 50 50 20], ...
    'Callback', @this.setWaveforms);

% --- SLAVE ---

% --- Delay before

% Text
uicontrol(Tab_Slave, 'Style', 'text', 'HorizontalAlignment', 'Left', ...
    'String', 'Delay before                    ms', ...
    'BackgroundColor', [1 1 1], ...
    'Position', [10 82 200 20]);

% Delay before
this.UI.DelayBefore = uicontrol(Tab_Slave, 'Style', 'edit', ...
    'Tag', 'DelayBefore', ...
    'String', 5, ...
    'Position', [80 85 50 20], ...
    'Callback', @this.setWaveforms);

% --- Delay after

% Text
uicontrol(Tab_Slave, 'Style', 'text', 'HorizontalAlignment', 'left', ...
    'String', 'Delay after                       ms', ...
    'BackgroundColor', [1 1 1], ...
    'Position', [10 57 200 20]);

% Delay before
this.UI.DelayAfter = uicontrol(Tab_Slave, 'Style', 'edit', ...
    'Tag', 'DelayAfter', ...
    'String', 5, ...
    'Position', [80 60 50 20], ...
    'Callback', @this.setWaveforms);


% --- Vertical trajectory -------------------------------------------------

xTraj = 10;
yTraj = 10;

% --- Decoration
annotation(Tab_Acquisition, 'rectangle', ...
    'Units', 'pixel', ...
    'LineStyle', 'none', ...
    'FaceColor', [1 1 1]*0.94, ...
    'Position', [xTraj yTraj 380 165]);

uicontrol(Tab_Acquisition, 'Style', 'text', ...
    'String', 'Vertical trajectory', ...
    'Position', [xTraj yTraj+135 380 20], ...
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
    'String', {'Sawtooth steps', 'Triangle steps', 'Sawtooth', 'Triangle'}, ...
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
    'Position', [xTraj+217 yTraj+107 110 20]);

% Exposure
this.UI.Exposure = uicontrol(Tab_Acquisition, 'Style', 'edit', ...
    'Tag', 'Exposure', ...
    'String', 40, ...
    'Position', [xTraj+270 yTraj+110 40 20], ...
    'Callback', @this.setWaveforms);

% --- Delay

% Text
uicontrol(Tab_Acquisition, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Delay                ms', ...
    'Position', [xTraj+217 yTraj+82 110 20]);

% Delay
this.UI.Delay = uicontrol(Tab_Acquisition, 'Style', 'edit', ...
    'Tag', 'Delay', ...
    'String', 10, ...
    'Position', [xTraj+270 yTraj+85 40 20], ...
    'Callback', @this.setWaveforms);

% --- Long delay

% Text
uicontrol(Tab_Acquisition, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Long delay                ms', ...
    'Position', [xTraj+207 yTraj+57 120 20]);

% Long delay
this.UI.DelayLong = uicontrol(Tab_Acquisition, 'Style', 'edit', ...
    'Tag', 'DelayLong', ...
    'String', 10, ...
    'Position', [xTraj+270 yTraj+60 40 20], ...
    'Callback', @this.setWaveforms);

% --- Stabilization shape

% Text
uicontrol(Tab_Acquisition, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Stabilization shape', ...
    'Position', [xTraj+164 yTraj+32 100 20]);

% Stab. shape
this.UI.StabShape = uicontrol(Tab_Acquisition, 'Style', 'popupmenu', ...
    'Tag', 'StabShape', ...
    'String', {'Linear', 'Parabolic'}, ...
    'Position', [xTraj+270 yTraj+36 60 20], ...
    'Callback', @this.setWaveforms);

% --- Stabilization ratio

% Text
uicontrol(Tab_Acquisition, 'Style', 'text', 'HorizontalAlignment', 'right', ...
    'String', 'Stabilization ratio (%)', ...
    'Position', [xTraj+145 yTraj+7 120 20]);

% Stab. ratio
this.UI.StabRatio = uicontrol(Tab_Acquisition, 'Style', 'edit', ...
    'Tag', 'StabRatio', ...
    'String', 50, ...
    'Position', [xTraj+270 yTraj+10 40 20], ...
    'Callback', @this.setWaveforms);

% --- Timing summary ------------------------------------------------------

xSum = 400;
ySum = 10;

% --- Decoration
annotation(Tab_Acquisition, 'rectangle', ...
    'Units', 'pixel', ...
    'LineStyle', 'none', ...
    'FaceColor', [1 1 1]*0.94, ...
    'Position', [xSum ySum 220 165]);

uicontrol(Tab_Acquisition, 'Style', 'text', ...
    'String', 'Timing summary', ...
    'Position', [xSum ySum+135 220 20], ...
    'FontWeight', 'bold', ...
    'ForegroundColor', TitleColor, ...
    'HorizontalAlignment', 'center');

% --- Number of cycles

% Text
uicontrol(Tab_Acquisition, 'Style', 'text', 'HorizontalAlignment', 'center', ...
    'String', 'Number of cycles', ...
    'Position', [xSum ySum+103 125 20]);

% Number of cycles
this.UI.NCycles = uicontrol(Tab_Acquisition, 'Style', 'edit', ...
    'Tag', 'NCycles', ...
    'String', 100, ...
    'Position', [xSum+25 ySum+85 70 20], ...
    'Callback', @this.setTiming);

% --- Cycle time

% Text
uicontrol(Tab_Acquisition, 'Style', 'text', 'HorizontalAlignment', 'center', ...
    'String', 'Cycle time (ms)', ...
    'Position', [xSum+112 ySum+103 100 20]);

% Cycle time
this.UI.CycleTime = uicontrol(Tab_Acquisition, 'Style', 'edit', ...
    'Tag', 'CycleTime', ...
    'String', 10, ...
    'Position', [xSum+125 ySum+85 70 20], ...
    'Enable', 'off');

% --- Total acquisition time

% Text
uicontrol(Tab_Acquisition, 'Style', 'text', 'HorizontalAlignment', 'center', ...
    'String', 'Run time (s)', ...
    'Position', [xSum+112 ySum+53 100 20]);

% Run time
this.UI.RunTime = uicontrol(Tab_Acquisition, 'Style', 'edit', ...
    'Tag', 'RunTime', ...
    'String', 10, ...
    'Position', [xSum+125 ySum+35 70 20], ...
    'Callback', @this.setTiming);

% Run time (human-readable)
this.UI.RunTimeHuman = uicontrol(Tab_Acquisition, 'Style', 'text', ...
    'Tag', 'RunTimeHuman', ...
    'HorizontalAlignment', 'center', ...
    'String', '00h 00m 10s', ...
    'Position', [xSum+125 ySum+12 70 20], ...
    'ForegroundColor', [1 1 1]*0.4);

% --- Total number of frames

% Text
uicontrol(Tab_Acquisition, 'Style', 'text', 'HorizontalAlignment', 'center', ...
    'String', 'Total number of frames', ...
    'Position', [xSum ySum+53 125 20]);

% Number of frames
this.UI.NFrames = uicontrol(Tab_Acquisition, 'Style', 'edit', ...
    'Tag', 'NFrames', ...
    'String', 1000, ...
    'Position', [xSum+25 ySum+35 70 20], ...
    'Callback', @this.setTiming);

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

% === Error message =======================================================
% % % 
% % % % this.UI.ErrorMessage = uipanel(this.Figures.Main, ...
% % % %     'Position',[0 0 1 1], ...
% % % %     'Visible', 'on');
% % % 
% % % this.UI.ErrorMessage = uipanel(this.Figures.Main, ...
% % %     'Position',[0.9 0.9 0.1 0.1], ...
% % %     'Visible', 'on');
% % % 
% % % Html = '<html><body style="background: rgb(52,69,87);">';
% % % Html = [Html '<div style="height: 100px;">&nbsp;</div>'];
% % % Html = [Html '<center><span>'];
% % % Html = [Html '<p style="font-family: Arial; font-size:18px; color: white; margin-bottom: 30px;">Loading DAQ control</p>'];
% % % Html = [Html '<img src="file:' fileparts(fileparts(mfilename('fullpath'))) filesep 'Icons' filesep 'spinner.gif" width="200" height="150">'];
% % % Html = [Html '</span></center>'];
% % % Html = [Html '</body></html>'];
% % %  
% % % % Create a figure with a scrollable JEditorPane
% % % je = javax.swing.JEditorPane('text/html', Html);
% % % jp = javax.swing.JScrollPane(je);
% % % [~, hcontainer] = javacomponent(jp, [], this.UI.ErrorMessage);
% % % set(hcontainer, 'units', 'normalized', 'position', [0,0,1,1]);

% === Listeners ===========================================================

% Sliders
addlistener(this.UI.HM_Position_slider, 'ContinuousValueChange', @this.setPositions);
addlistener(this.UI.VM_Position_slider, 'ContinuousValueChange', @this.setPositions);
addlistener(this.UI.OP_Position_slider, 'ContinuousValueChange', @this.setPositions);

% --- Display -------------------------------------------------------------

set(this.Figures.Main, 'visible', 'on');