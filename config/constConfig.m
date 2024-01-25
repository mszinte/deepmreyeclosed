function const = constConfig(scr, const)
% ----------------------------------------------------------------------
% const = constConfig(scr, const)
% ----------------------------------------------------------------------
% Goal of the function :
% Define all constant configurations
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------

% Randomization
[const.seed, const.whichGen] = ClockRandSeed;

% Colors
const.white = [255, 255, 255];
const.gray = [128 128 128];
const.fixation_color = const.white;
const.background_color = const.gray; 

% Time parameters
const.TR_sec = 1.2;                                                                  % MRI time repetition in seconds
const.TR_frm = round(const.TR_sec/scr.frame_duration);                               % MRI time repetition in seconds in screen frames

%new stimulus time parameters
const.iti_dur_TR = 5;                                                                % Inter trial interval duration in scanner TR
const.iti_dur_sec = const.iti_dur_TR * const.TR_sec;                                 % Inter trial interval duration in seconds
const.iti_dur_frm = round(const.iti_dur_sec / scr.frame_duration);                   % Inter trial interval in screen frames

const.triang_open_dur_TR = 1;                                                        % Triangle stimulus eyes open condition duration in scanner TR
const.triang_open_dur_sec = const.triang_open_dur_TR * const.TR_sec;                 % Triangle stimulus eyes open condition duration in seconds
const.triang_open_dur_frm = round(const.triang_open_dur_sec /scr.frame_duration);    % Triangle stimulus eyes open condition duration in screen frames   

const.triang_part_dur_TR = 3;                                                        % Triangle stimulus eyes partly closed condition duration in scanner TR
const.triang_part_dur_sec = const.triang_part_dur_TR * const.TR_sec;                 % Triangle stimulus eyes partly closed duration in seconds
const.triang_part_dur_frm = round(const.triang_part_dur_sec /scr.frame_duration);    % Triangle stimulus eyes partly closed duration in screen frames   

const.triang_closed_dur_TR = 1;                                                      % Triangle stimulus eyes closed condition duration in scanner TR
const.triang_closed_dur_sec = const.triang_closed_dur_TR * const.TR_sec;             % Triangle stimulus eyes closed condition duration in seconds
const.triang_closed_dur_frm = round(const.triang_closed_dur_sec ...
                              /scr.frame_duration);                                  % Triangle stimulus eyes closed condition duration in screen frames  


const.sound_interval_TR = 1;                                                        % Sound interval duration in scanner TR
const.sound_interval_sec = const.sound_interval_TR * const.TR_sec;                  % Sound interval duration in seconds
const.sound_interval_frm = round(const.sound_interval_sec /scr.frame_duration);     % Sound interval duration in screen frames   

const.total_sound_intervals = 3;


% Stim parameters
[const.ppd] = vaDeg2pix(1, scr);                                                     % one pixel per dva
const.dpp = 1/const.ppd;                                                             % degrees per pixel
const.window_sizeVal = 14;                                                           % side of the display window

% tasks
const.task_txt = {'inter-trial interval', 'triangle_open', 'triangle_part_closed', 'triangle_closed'};


% triangle task parameters
const.triang_size    = 14;
const.triang_size_px = vaDeg2pix(const.triang_size, scr);

const.triang_coords_middle = [scr.x_mid, scr.y_mid];
const.triang_coords_down_right = [scr.x_mid + const.triang_size_px /2, scr.y_mid + const.triang_size_px /2 ]; 
const.triang_coords_down_left = [scr.x_mid - const.triang_size_px /2, scr.y_mid + const.triang_size_px /2 ];
const.triang_coords_up_right = [scr.x_mid + const.triang_size_px /2, scr.y_mid - const.triang_size_px /2 ];
const.triang_coords_up_left = [scr.x_mid - const.triang_size_px /2, scr.y_mid - const.triang_size_px /2 ];


const.triang_coords_all = [const.triang_coords_middle;
                           const.triang_coords_down_right;
                           const.triang_coords_down_left;
                           const.triang_coords_middle;
                           const.triang_coords_down_left;
                           const.triang_coords_up_left;
                           const.triang_coords_middle;
                           const.triang_coords_up_left;
                           const.triang_coords_up_right;
                           const.triang_coords_middle;
                           const.triang_coords_up_right;
                           const.triang_coords_down_right;
                           ]; 




% Trial settings
const.nb_repeat_triang_open = 1;
const.nb_trials_triang_open = length(const.triang_coords_all) * const.nb_repeat_triang_open;
const.TRs_triang_open = const.nb_trials_triang_open * const.triang_open_dur_TR;

const.nb_repeat_triang_part = 1;
const.nb_trials_triang_part = length(const.triang_coords_all) * const.nb_repeat_triang_part;
const.TRs_triang_part = const.nb_trials_triang_part * const.triang_part_dur_TR;

const.nb_repeat_triang_closed = 1;
const.nb_trials_triang_closed = length(const.triang_coords_all) * const.nb_repeat_triang_closed;
const.TRs_triang_closed = const.nb_trials_triang_closed* const.triang_closed_dur_TR;

const.nb_trials_iti = 4; % 3 iti and final one
const.TRs_iti = const.nb_trials_iti * const.iti_dur_TR;

const.nb_trials = const.nb_trials_triang_open + const.nb_trials_triang_part + ...
    const.nb_trials_triang_closed + const.nb_trials_iti;


% Final triangle settings
const.triangle_position_order = repmat([5,4,3,4,1,3,1,2,3,2,5,3],1,const.nb_repeat_triang_open);

const.triangle_position_txt =  {'up_left', 'up_right', 'middle', 'down_left', 'down_right'};

const.triangle_rotation_txt = {'up', 'right', 'down', 'left'};



% Final sound settings 
const.sound_order = repmat((repmat([1,2,3],1,4)),1,const.nb_repeat_triang_open);


% define total TR numbers and scan duration
if const.scanner
    const.TRs_total = const.TRs_triang_open + const.TRs_triang_part + ...
                            const.TRs_triang_closed + const.TRs_iti;
    fprintf(1,'\n\tScanner parameters: %1.0f TRs of %1.2f seconds for a total of %s\n',...
        const.TRs_total, const.TR_sec, ...
        datestr(seconds((const.TRs_total*const.TR_sec...
        )),'MM:SS'));
end

% Bullseye configs
const.fix_out_rim_radVal = 0.25;                                            % radius of outer circle of fixation bull's eye in dva
const.fix_rim_radVal = 0.75*const.fix_out_rim_radVal;                       % radius of intermediate circle of fixation bull's eye in dva
const.fix_radVal = 0.25*const.fix_out_rim_radVal;                           % radius of inner circle of fixation bull's eye in dva
const.fix_out_rim_rad = vaDeg2pix(const.fix_out_rim_radVal, scr);           % radius of outer circle of fixation bull's eye in pixels
const.fix_rim_rad = vaDeg2pix(const.fix_rim_radVal, scr);                   % radius of intermediate circle of fixation bull's eye in pixels
const.fix_rad = vaDeg2pix(const.fix_radVal, scr);                           % radius of inner circle of fixation bull's eye in pixels

% Personalised eyelink calibrations
angle = 0:pi/3:5/3*pi;
 
% compute calibration target locations
const.calib_amp_ratio = 0.5;
[cx1, cy1] = pol2cart(angle, const.calib_amp_ratio);
[cx2, cy2] = pol2cart(angle + (pi / 6), const.calib_amp_ratio * 0.5);
cx = round(scr.x_mid + scr.x_mid * [0 cx1 cx2]);
cy = round(scr.y_mid + scr.x_mid * [0 cy1 cy2]);
 
% order for eyelink
const.calibCoord = round([cx(1), cy(1),...                                  % 1. center center
    cx(9), cy(9),...                                                        % 2. center up
    cx(13),cy(13),...                                                       % 3. center down
    cx(5), cy(5),...                                                        % 4. left center
    cx(2), cy(2),...                                                        % 5. right center
    cx(4), cy(4),...                                                        % 6. left up
    cx(3), cy(3),...                                                        % 7. right up
    cx(6), cy(6),...                                                        % 8. left down
    cx(7), cy(7),...                                                        % 9. right down
    cx(10), cy(10),...                                                      % 10. left up
    cx(8), cy(8),...                                                        % 11. right up
    cx(11), cy(11),...                                                      % 12. left down
    cx(12), cy(12)]);                                                       % 13. right down

% compute validation target locations (calibration targets smaller radius)
const.valid_amp_ratio = const.calib_amp_ratio * 0.8;
[vx1, vy1] = pol2cart(angle, const.valid_amp_ratio);
[vx2, vy2] = pol2cart(angle + pi /6, const.valid_amp_ratio * 0.5);
vx = round(scr.x_mid + scr.x_mid*[0 vx1 vx2]);
vy = round(scr.y_mid + scr.x_mid*[0 vy1 vy2]);

% order for eyelink
const.validCoord =round([vx(1), vy(1),...                                   % 1. center center
    vx(9), vy(9),...                                                        % 2. center up
    vx(13), vy(13),...                                                      % 3. center down
    vx(5), vy(5),...                                                        % 4. left center
    vx(2), vy(2),...                                                        % 5. right center
    vx(4), vy(4),...                                                        % 6. left up
    vx(3), vy(3),...                                                        % 7. right up
    vx(6), vy(6),...                                                        % 8. left down
    vx(7), vy(7),...                                                        % 9. right down
    vx(10), vy(10),...                                                      % 10. left up
    vx(8), vy(8),...                                                        % 11. right up
    vx(11), vy(11),...                                                      % 12. left down
    vx(12), vy(12)]);                                                       % 13. right down
end