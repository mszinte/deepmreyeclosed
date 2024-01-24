function expDes = designConfig(scr, const)
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
% expDes : struct containg experimental design
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------

% Experimental condition
% 01 - intertrial interval
% 02 - triangle eyes open task
% 03 - triangle eyes partly closed task
% 04 - triangle eyes closed task

% Experimental variables
% Var 1: triangle rotation condition 
expDes.oneV = [1:1:4]';
expDes.nb_var1 = length(expDes.oneV);
% 01: up 
% 02: right
% 03: down
% 04: left


% Var 2: triangle point location
expDes.twoV = [1:1:5]';
expDes.nb_var2 = length(expDes.twoV);
% 01 (up_left)           02 (up_right)
%             03 (middle)
% 04 (down_left)         05 (down_right)


% Experimental loop
expDes.nb_var = 2;



% Triangle eyes open point location experimental loop
ii = 0;
triang_location_order_open = repmat([3,5,4,3,4,1,3,1,2,3,2,5],1,const.nb_repeat_triang_open);

trialMat_triang_open = zeros(const.nb_trials_triang_open, expDes.nb_var+1)*nan;
for rep = 1:const.nb_repeat_triang_open
    for var1 = 1:expDes.nb_var1
        for var2 = 1:expDes.nb_var2-2  % will only need 3 out of the 5 possible positions
            ii = ii + 1;
            trialMat_triang_open(ii, 1) = 2;
            trialMat_triang_open(ii, 2) = var1;
            trialMat_triang_open(ii, 3) = nan; 
        end
    end
end


trialMat_triang_open = [1, nan, nan; % add intertrial interval
                        trialMat_triang_open];  
trialMat_triang_open(2:length(trialMat_triang_open),3) = triang_location_order_open;

% Triangle eyes open point location experimental loop
ii = 0;
triang_location_order_part = repmat([3,5,4,3,4,1,3,1,2,3,2,5],1,const.nb_repeat_triang_part);

trialMat_triang_part = zeros(const.nb_trials_triang_part, expDes.nb_var+1)*nan;
for rep = 1:const.nb_repeat_triang_part
    for var1 = 1:expDes.nb_var1
        for var2 = 1:expDes.nb_var2-2
            ii = ii + 1;
            trialMat_triang_part(ii, 1) = 3;
            trialMat_triang_part(ii, 2) = var1;
            trialMat_triang_part(ii, 3) = nan; %filled later
        end
    end
end

trialMat_triang_part = [1, nan, nan; % add intertrial interval
                        trialMat_triang_part];

trialMat_triang_part(2:length(trialMat_triang_part),3) = triang_location_order_part;

% Triangle eyes closed experimental loop
ii = 0;
trialMat_triang_closed = zeros(const.nb_trials_triang_closed, expDes.nb_var+1)*nan;
for rep = 1:const.nb_repeat_triang_closed
    for var1 = 1:expDes.nb_var1
        for var2 = 1:expDes.nb_var2-2
            ii = ii + 1;
            trialMat_triang_closed(ii, 1) = 4;
            trialMat_triang_closed(ii, 2) = nan; %nothing shown
            trialMat_triang_closed(ii, 3) = nan; %nothing shown
        end
    end
end

trialMat_triang_closed = [1, nan, nan; ... % add intertrial interval
                         trialMat_triang_closed; ...
                         1, nan, nan; % add end interval
                         ];    

% Define main matrix
trialMat = [trialMat_triang_open; ...
            trialMat_triang_part; ...
            trialMat_triang_closed];

expDes.expMat = [zeros(const.nb_trials,2)*nan, ...
    zeros(const.nb_trials,1)*0+const.runNum,...
    [1:const.nb_trials]',trialMat];

% 01 : onset
% 02 : duration
% 03 : run number
% 04 : trial number
% 05 : task
% 06 : triangle rotation number
% 07 : triangle fixation position

end