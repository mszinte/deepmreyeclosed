function expDes = designConfig(const)
% ----------------------------------------------------------------------
% expDes = designConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Define experimental design
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct of the screen settings
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% expDes : struct contain experimental design and trial specs
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Edited by Sina KLING (sina.kling@outlook.de)
% ----------------------------------------------------------------------

% Experimental condition
% 01 - inter-trial interval
% 02 - eyes open task
% 03 - eyes blink task
% 04 - eyes closed task

% Var 1: Fixation position
% Order defined in const, see const.fix_coords
% 01 (top_left)             02 (top_right)
%                03 (middle)
% 04 (bottom_left)          05 (bottom_right)

% Experimental loop
expDes.nb_var = 1;

% Eyes open experimental loop
ii = 0;
trialMat_eyes_open = zeros(const.nb_trials_eyes_open, expDes.nb_var+1) ...
    * nan;
for rep = 1:const.nb_repeat_eyes_open
    for var1 = const.fix_position_order
        ii = ii + 1;
        trialMat_eyes_open(ii, 1) = 2;          % condition
        trialMat_eyes_open(ii, 2) = var1;       % eye position
    end
end
trialMat_eyes_open = [1, 3; ...               % add intertrial interval
                      trialMat_eyes_open];  

% Eyes blink experimental loop
ii = 0;
trialMat_eyes_blink = zeros(const.nb_trials_eyes_blink, expDes.nb_var+1) ...
    * nan;
for rep = 1:const.nb_repeat_eyes_blink
    for var1 = const.fix_position_order
        ii = ii + 1;
        trialMat_eyes_blink(ii, 1) = 3;         % condition
        trialMat_eyes_blink(ii, 2) = var1;      % eye position
    end
end
trialMat_eyes_blink = [1, 3; ...              % add inter-trial interval
                       trialMat_eyes_blink];

% Eyes open no stimulus experimental loop
ii = 0;
trialMat_eyes_open_no = zeros(const.nb_trials_eyes_open_no, expDes.nb_var+1) ...
    * nan;
for rep = 1:const.nb_repeat_eyes_open_no
    for var1 = const.fix_position_order
        ii = ii + 1;
        trialMat_eyes_open_no(ii, 1) = 4;         % condition
        trialMat_eyes_open_no(ii, 2) = var1;      % eye position
    end
end
trialMat_eyes_open_no = [1, 3; ...              % add inter-trial interval
                        trialMat_eyes_open_no];


% Eyes closed experimental loop
ii = 0;
trialMat_eyes_close = zeros(const.nb_trials_eyes_close, expDes.nb_var+1) ...
    * nan;
for rep = 1:const.nb_repeat_eyes_close
    for var1 = const.fix_position_order
        ii = ii + 1;
        trialMat_eyes_close(ii, 1) = 5;         % condition
        trialMat_eyes_close(ii, 2) = var1;      % eye position
    end
end
trialMat_eyes_close = [1, 3; ...              % add inter-trial interval
                       trialMat_eyes_close; ...
                       1, 3];                 % add final interval


% Define main matrix
trialMat = [trialMat_eyes_open; ...
            trialMat_eyes_blink; ...
            trialMat_eyes_open_no; ...
            trialMat_eyes_close];


expDes.expMat = [zeros(const.nb_trials,2)*nan, ...
                 zeros(const.nb_trials,1)*0+const.runNum,...
                 [1:const.nb_trials]', ...
                 trialMat];

% 01 : onset
% 02 : duration
% 03 : run number
% 04 : trial number
% 05 : task
% 06 : fixation position

end