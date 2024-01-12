function expDes = designConfig(const)
% ----------------------------------------------------------------------
% expDes = designConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Define experimental design
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% expDes : struct containg experimental design
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------


% Experimental variables
% Var 1: task
expDes.oneV = input(sprintf('\n\tTASK: '));
expDes.nb_var1 = length(const.task_lst); %number of levels in task variable

% Experimental loop
trialMat = zeros(const.nb_trials, expDes.nb_var1);
ii = 0;
for rep = 1:const.nb_repeat
    for var1 = 1:expDes.nb_var1
           ii = ii + 1;
            trialMat(ii, 1) = var1;
    end
end

for t_trial = 1:const.nb_trials
    %header: onset, duration, run num, trial num, task
    expDes.expMat(t_trial, :) = [NaN, NaN, const.runNum, t_trial, expDes.oneV];
    
    % 01: trial onset
    % 02: trial duration
    % 03: run number
    % 04: trial number
    % 05: var1: task

end
    


    
end




