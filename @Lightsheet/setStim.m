function setStim(this, varargin)

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
Graph_stim = this.UI.stim_time;
cla(Graph_stim, 'reset');
hold(Graph_stim, 'on');
box(Graph_stim, 'on');
grid(Graph_stim, 'on');
xlabel(Graph_stim, 'Time (s)');
ylabel(Graph_stim, 'Stim (A.U)');
%disp([0, str2double(get(this.UI.RunTime, 'String'))])
axis(Graph_stim, [0, str2double(get(this.UI.RunTime, 'String')),0,1]);


init = str2double(get(this.UI.init_time_offset, 'String'))/1000;
dt = str2double(get(this.UI.stim_duration, 'String'))/1000;
T = str2double(get(this.UI.intra_stim_duration, 'String'))/1000;
N = str2double(get(this.UI.nb_stim, 'String'));
dt_repet = str2double(get(this.UI.inter_duration, 'String'))/1000;
N_repet = str2double(get(this.UI.nb_of_repetitions, 'String'));
%time_offset = 0.011;%s
time_offset = str2double(get(this.UI.delay_trig,'String'))/1000;
%ADDED 27/06/2022
%SIGNALS STIM

%ADDED 04/08/2023 - added cycle relative stimulation

start_cycle = str2double(get(this.UI.starting_cycle, 'String'));
layer_num = str2double(strsplit(get(this.UI.layers_numbers, 'String'),','));
cycle_rep = str2double(get(this.UI.cycle_rep, 'String'));
dt_repet_cycle = str2double(get(this.UI.inter_duration_cycle, 'String'));
N_repet_cycle = str2double(get(this.UI.nb_of_repetitions_cycle, 'String'));

%converting start cycle in real time:
cycletime = str2double(get(this.UI.CycleTime, 'String'))/1000;
init_cycle = start_cycle*cycletime;

total_time_per_layer = (str2double(get(this.UI.Delay, 'String'))+str2double(get(this.UI.Exposure, 'String')))/1000;
        
% Fill the empty DS lines
for i = 1:1
    this.Signals.DS(i).tstart = [];
    this.Signals.DS(i).tstop = [];
    this.Signals.DS(i).default = false;
end


if ismember(in.tag, {'starting_cycle','layers_numbers','cycle_rep','nb_of_repetitions_cycle','inter_duration_cycle'})
    %disp('truc')
    %disp(this.Signals.DS(1))
    for j=1:1
        for jj=1:N_repet_cycle
            for kk = 1:cycle_rep
                for i=layer_num
                    disp(j*init_cycle + (i-1)*total_time_per_layer+ (kk-1)*cycletime)
                    %disp(['DS1 ' num2str(init*j + i * T) ' ' num2str(dt)])
                    this.Signals.DS(j).tstart(end+1) = (j*init_cycle + (i-1)*total_time_per_layer) + (kk-1)*cycletime + (jj-1)*dt_repet_cycle*cycletime;
                end
            end
        end
    end
    this.Signals.DS(1).tstop = this.Signals.DS(1).tstart+dt;
    disp(this.Signals.DS(j))
% for j=[1,2] %% for each cycle
%     for i=0:N-1
%         LS.Signals.DS(1).tstart(end+1) = init*j + time_offset + i * T;
%     end
% end
% 
% LS.Signals.DS(1).tstop = LS.Signals.DS(1).tstart

plot(Graph_stim, [this.Signals.DS(1).tstart;this.Signals.DS(1).tstart], repmat(ylim',1), '-k', 'color', [0 115 189]/255);
if dt>0.001
    plot(Graph_stim, [this.Signals.DS(1).tstop;this.Signals.DS(1).tstop], repmat(ylim',1), '-k', 'color', [115 0 189]/255);
end
if str2double(get(this.UI.RunTime, 'String')) < this.Signals.DS(1).tstart(end)
    text(Graph_stim,0.5,0.5,'Stim(s) outside RunTime !','Color','red','FontSize',14);
    %annotation(Graph_stim,'textbox',[.9 .5 .1 .2], 'String','Stim(s) outside RunTime !','EdgeColor','none');
    disp('out');
end
%xline(Graph_stim, [this.Signals.DS(1).tstart], 1, '-', 'color', [0 115 189]/255);
end

if ismember(in.tag, {'delay_trig', 'init_time_offset','stim_duration','intra_stim_duration','nb_stim','nb_of_repetitions','inter_duration'})
    %disp('truc')
    %disp(this.Signals.DS(1))
    for j=1:1
        for kk = 1:N_repet
            for i=0:N-1
            
                %disp(['DS1 ' num2str(init*j + i * T) ' ' num2str(dt)])
                this.Signals.DS(j).tstart(end+1) = (init*j + i * T + time_offset) + (kk-1)*dt_repet;
            end
        end
    end
    this.Signals.DS(1).tstop = this.Signals.DS(1).tstart+dt;
    disp(this.Signals.DS(j))
% for j=[1,2] %% for each cycle
%     for i=0:N-1
%         LS.Signals.DS(1).tstart(end+1) = init*j + time_offset + i * T;
%     end
% end
% 
% LS.Signals.DS(1).tstop = LS.Signals.DS(1).tstart

plot(Graph_stim, [this.Signals.DS(1).tstart;this.Signals.DS(1).tstart], repmat(ylim',1), '-k', 'color', [0 115 189]/255);
if dt>0.001
    plot(Graph_stim, [this.Signals.DS(1).tstop;this.Signals.DS(1).tstop], repmat(ylim',1), '-k', 'color', [115 0 189]/255);
end
if str2double(get(this.UI.RunTime, 'String')) < this.Signals.DS(1).tstart(end)
    text(Graph_stim,0.5,0.5,'Stim(s) outside RunTime !','Color','red','FontSize',14);
    %annotation(Graph_stim,'textbox',[.9 .5 .1 .2], 'String','Stim(s) outside RunTime !','EdgeColor','none');
    disp('out');
end
%xline(Graph_stim, [this.Signals.DS(1).tstart], 1, '-', 'color', [0 115 189]/255);
end
