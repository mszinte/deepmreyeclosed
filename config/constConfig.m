function const = constConfig(scr, const, aud)
% ----------------------------------------------------------------------
% const = constConfig(scr, const, aud)
% ----------------------------------------------------------------------
% Goal of the function :
% Define all constant configurations
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% aud : struct containing audio settings
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Edited by Sina KLING (sina.kling@outlook.de)
% ----------------------------------------------------------------------

% Randomization
[const.seed, const.whichGen] = ClockRandSeed;

% Colors
const.white = [255, 255, 255];
const.gray = [128 128 128];
const.black = [0,0,0];
const.fixation_color = const.white;
const.background_color = const.black; 

% Time parameters
const.TR_sec = 1.2;                                                                 % MRI time repetition in seconds
const.TR_frm = round(const.TR_sec/scr.frame_duration);                              % MRI time repetition in seconds in screen frames

%new stimulus time parameters
const.iti_dur_TR = 5;                                                               % Inter trial interval duration in scanner TR
const.iti_dur_sec = const.iti_dur_TR * const.TR_sec;                                % Inter trial interval duration in seconds
const.iti_dur_frm = round(const.iti_dur_sec / scr.frame_duration);                  % Inter trial interval in screen frames

const.trial_dur_TR = 3;                                                             % trial duration in scanner TR
const.trial_dur_sec = const.trial_dur_TR * const.TR_sec;                            % trial duration in seconds
const.trial_dur_frm = round(const.trial_dur_sec / scr.frame_duration);              % trial duration in screen frames

% Stim parameters
[const.ppd] = vaDeg2pix(1, scr);                                                    % one pixel per dva
const.dpp = 1/const.ppd;                                                            % degrees per pixel
const.window_sizeVal = 18;                                                          % side of the display window

% tasks
const.task_txt = {'inter-trial interval', ...
                  'eyes open', ...
                  'eyes blink', ...
                  'eyes open no dot', ...
                  'eyes close'};

% Fixation position
const.triangle_size = 18;                                                           % position triangle size in dva
const.triangle_size_px = vaDeg2pix(const.triangle_size, scr);                       % position triangle size in pixels

const.fix_middle_coords = [scr.x_mid, ...
                           scr.y_mid];
const.fix_bottom_right_coords = [scr.x_mid + const.triangle_size_px / 2, ...
                                 scr.y_mid + const.triangle_size_px / 2]; 
const.fix_bottom_left_coords = [scr.x_mid - const.triangle_size_px / 2, ...
                                scr.y_mid + const.triangle_size_px / 2];
const.fix_top_right_coords = [scr.x_mid + const.triangle_size_px / 2, ...
                              scr.y_mid - const.triangle_size_px / 2];
const.fix_top_left_coords = [scr.x_mid - const.triangle_size_px / 2, ... 
                             scr.y_mid - const.triangle_size_px / 2];
% 01 (top_left)             02 (top_right)
%                03 (middle)
% 04 (bottom_left)          05 (bottom_right)

const.fix_coords = [const.fix_top_left_coords; ...
                    const.fix_top_right_coords; ...
                    const.fix_middle_coords; ...
                    const.fix_bottom_left_coords; ...
                    const.fix_bottom_right_coords];
                
const.fix_coords_txt =  {'top left', ...
                         'top right', ... 
                         'middle', ...
                         'bottom left', ...
                         'bottom right'};

const.fix_position_order = [5, 4, 3, ...    % bottom right ==> bottom left  ==> middle
                            4, 1, 3, ...    % bottom left  ==> top left     ==> middle
                            1, 2, 3, ...    % top left     ==> top right    ==> middle
                            2, 5, 3];       % top right    ==> bottom right ==> middle 
                        
const.fix_steps = length(const.fix_position_order); 

% Trial settings
const.nb_repeat_eyes_open = 2;
const.nb_trials_eyes_open = const.fix_steps * const.nb_repeat_eyes_open;
const.TRs_eyes_open = const.nb_trials_eyes_open * const.trial_dur_TR;

const.nb_repeat_eyes_blink = 2;
const.nb_trials_eyes_blink = const.fix_steps * const.nb_repeat_eyes_blink;
const.TRs_eyes_blink = const.nb_trials_eyes_blink * const.trial_dur_TR;

const.nb_repeat_eyes_open_no = 2;
const.nb_trials_eyes_open_no = const.fix_steps * const.nb_repeat_eyes_open_no;
const.TRs_eyes_open_no = const.nb_trials_eyes_open_no * const.trial_dur_TR;

const.nb_repeat_eyes_close = 2;
const.nb_trials_eyes_close = const.fix_steps * const.nb_repeat_eyes_close;
const.TRs_eyes_close = const.nb_trials_eyes_close * const.trial_dur_TR;

const.nb_trials_iti = 5; % 4 iti and final one
const.TRs_iti = const.nb_trials_iti * const.iti_dur_TR;

const.nb_trials = const.nb_trials_eyes_open + const.nb_trials_eyes_blink + ...
                  const.nb_trials_eyes_open_no + const.nb_trials_eyes_close + ...
                  const.nb_trials_iti;

if const.audio_testing == 1
    const.nb_repeat_eyes_open = 1;
    const.nb_trials_eyes_open = const.fix_steps * const.nb_repeat_eyes_open;
    const.TRs_eyes_open = const.nb_trials_eyes_open * const.trial_dur_TR;
    
    const.nb_repeat_eyes_blink = 1;
    const.nb_trials_eyes_blink = const.fix_steps * const.nb_repeat_eyes_blink;
    const.TRs_eyes_blink = const.nb_trials_eyes_blink * const.trial_dur_TR;
    
    const.nb_repeat_eyes_open_no = 1;
    const.nb_trials_eyes_open_no = const.fix_steps * const.nb_repeat_eyes_open_no;
    const.TRs_eyes_open_no = const.nb_trials_eyes_open_no * const.trial_dur_TR;
    
    const.nb_repeat_eyes_close = 1;
    const.nb_trials_eyes_close = const.fix_steps * const.nb_repeat_eyes_close;
    const.TRs_eyes_close = const.nb_trials_eyes_close * const.trial_dur_TR;
    
    const.nb_trials_iti = 5; % 4 iti and final one
    const.TRs_iti = const.nb_trials_iti * const.iti_dur_TR;
    
    const.nb_trials = const.nb_trials_eyes_open + const.nb_trials_eyes_blink + ...
                      const.nb_trials_eyes_open_no + const.nb_trials_eyes_close + ...
                      const.nb_trials_iti;
end

% define total TR numbers and scan duration
if const.scanner
    const.TRs_total = const.TRs_eyes_open + const.TRs_eyes_blink + ...
                            const.TRs_eyes_open_no + const.TRs_eyes_close + ...
                            const.TRs_iti;
    fprintf(1,'\n\tScanner parameters: %1.0f TRs of %1.2f seconds for a total of %s\n',...
        const.TRs_total, const.TR_sec, ...
        datestr(seconds((const.TRs_total * const.TR_sec...
        )),'MM:SS'));
end

% Bulls-Eye configs
const.fix_out_rim_radVal = 0.25;                                            % radius of outer circle of fixation bull's eye in dva
const.fix_rim_radVal = 0.75*const.fix_out_rim_radVal;                       % radius of intermediate circle of fixation bull's eye in dva
const.fix_radVal = 0.25*const.fix_out_rim_radVal;                           % radius of inner circle of fixation bull's eye in dva
const.fix_out_rim_rad = vaDeg2pix(const.fix_out_rim_radVal, scr);           % radius of outer circle of fixation bull's eye in pixels
const.fix_rim_rad = vaDeg2pix(const.fix_rim_radVal, scr);                   % radius of intermediate circle of fixation bull's eye in pixels
const.fix_rad = vaDeg2pix(const.fix_radVal, scr);                           % radius of inner circle of fixation bull's eye in pixels

% Sounds configurations
const.sound_dur = 0.300;                                                    % tone duration in seconds

const.iti_tones_freq = [300, 0, 300, 0, 300, 0, 300, 0, 300, 0];            % iti tone frequency list
const.iti_tones_dur  = [const.sound_dur,...                                 % iti tone duration list
                       const.TR_sec - const.sound_dur, ...
                       const.sound_dur,...
                       const.TR_sec - const.sound_dur, ...
                       const.sound_dur,...
                       const.TR_sec - const.sound_dur, ...
                       const.sound_dur,...
                       const.TR_sec - const.sound_dur, ...
                       const.sound_dur,...
                       const.TR_sec - const.sound_dur];
const.iti_tones = make_tone(aud, const.iti_tones_freq, const.iti_tones_dur);% iti tone

const.trial_tones_freq = [440, 0, 660, 0, 880, 0];                          % trial tone frequency list
const.trial_tones_dur  = [const.sound_dur, ...                              % trial tone duration list
                         const.TR_sec - const.sound_dur, ...
                         const.sound_dur, ...
                         const.TR_sec - const.sound_dur, ...
                         const.sound_dur, ...
                         const.TR_sec - const.sound_dur];

const.trial_tones = make_tone(aud, const.trial_tones_freq, ...
                                  const.trial_tones_dur);                   % trial tone

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