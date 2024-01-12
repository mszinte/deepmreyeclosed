function [const, valid] = getFixLocations_pursuit(const, scr, valid)
% Pseudorandom walk for smooth pusuit task balancing eye-movement directions
% and speeds. MN, September 2021
%adapted SK, Dec 23


% get movement angles and amplitudes (in pixel coordinates)
mov_angles = repmat(const.pursuit.angles, 1, numel(const.pursuit.mov_amp));
mov_amp = const.pursuit.mov_amp *scr.units.pxPdeg; %convert amplitudes into pixel
mov_amp = ones(numel(const.pursuit.angles),numel(const.pursuit.mov_amp)).*mov_amp;
mov_amp = mov_amp(:)';     %one-dimensional array representing the scaled amplitudes for pursuit movements in pixel


% window for pursuit trajectory (fixation cross will not leave this window)


calib_win = [round((scr.x_mid - const.fixtask.win_sz_px)/1.25), round((scr.x_mid + const.fixtask.win_sz_px)/1.25); 0, round((scr.y_mid + const.fixtask.win_sz_py)/1.25)];
calib_win_middle = [(calib_win(1,1) + calib_win(1,2)) / 2, (calib_win(2,1) + calib_win(2,2)) / 2];
% create pursuit trajectory with defined movement angles & amplitudes within predefined window
const.pursuit.xy = [calib_win_middle]; % start in center of window

cTrial = 2; stuck = 0;
while cTrial <= (numel(const.pursuit.mov_amp)*numel(const.pursuit.angles)+1)   %nr trials: nr angles * nr amplitudes + 1 (original code 24 * 3 + 1 = 73)
    
    % if no solution can be found, step out and try again
    if stuck > 50
        return;
    end
    
    % select random angle x amplitude combo
    trial_id    = randi(numel(mov_angles)); %gets random index
    trial_angle = mov_angles(trial_id); %select random angle
    trial_amp   = mov_amp(trial_id);
    
    
    const.pursuit.xy(cTrial,1) = (const.pursuit.xy(cTrial-1,1)) + trial_amp * cos(trial_angle);
    const.pursuit.xy(cTrial,2) = (const.pursuit.xy(cTrial-1,2)) + trial_amp * sin(trial_angle);

    %disp(['Current Coordinates: (' num2str(const.pursuit.xy(cTrial, 1)) ', ' num2str(const.pursuit.xy(cTrial, 2)) ')']);

    
    % if fixation cross leaves calibration window, try selecting another angle & amplitude
    if const.pursuit.xy(cTrial,1) < calib_win(1,1) || const.pursuit.xy(cTrial,1)>calib_win(1,2) || ...
            const.pursuit.xy(cTrial,2)<calib_win(2,1) || const.pursuit.xy(cTrial,2)>calib_win(2,2)
        stuck = stuck+1;
        continue;
    else
        % if fixation cross is within calibration window, remove chosen angle from list
        mov_angles(trial_id) = [];
        mov_amp(trial_id)  = [];
        cTrial = cTrial + 1;
    end
end

fix_dur = round(const.pursuit.dur_sec*scr.hz);
% interpolate position inbetween screen locations
if isempty(mov_angles) && isempty(mov_amp)
    valid = 1;   %flag for when valid set of trajectories is obtained 
    for cTrial = 2:size(const.pursuit.xy,1)
        const.pursuit.xy_trials_pursuit{cTrial-1}(1,:) = linspace(const.pursuit.xy(cTrial-1,1), const.pursuit.xy(cTrial,1), fix_dur+1);
        const.pursuit.xy_trials_pursuit{cTrial-1}(2,:) = linspace(const.pursuit.xy(cTrial-1,2), const.pursuit.xy(cTrial,2), fix_dur+1);
    end
end

% add starting position as first trial

const.pursuit.xy_trials_pursuit = arrayfun(@(x) const.pursuit.xy_trials_pursuit{x}(:,2:end)', 1:numel(const.pursuit.xy_trials_pursuit), 'UniformOutput', false);
const.pursuit.xy_trials_pursuit = [{repmat(calib_win_middle, fix_dur, 1)}, const.pursuit.xy_trials_pursuit];
const.pursuit.xy_trials_pursuit = cellfun(@round, const.pursuit.xy_trials_pursuit, 'uni', 0);




end

