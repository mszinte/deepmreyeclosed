function eyetrack = initEyeLink(scr, const)
% ----------------------------------------------------------------------
% eyetrack = initEyeLink(scr, const)
% ----------------------------------------------------------------------
% Goal of the function :
% Initializes eyeLink-connection, creates edf-file
% and writes experimental parameters to edf-file
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% eyetrack : struct containing eyeyetrackink configurations
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------

% Modify different defaults settings :
eyetrack = EyelinkInitDefaults(scr.main);
eyetrack.msgfontcolour = WhiteIndex(eyetrack.window);
eyetrack.imgtitlecolour = WhiteIndex(eyetrack.window);
eyetrack.targetbeep = 0;
eyetrack.feedbackbeep = 0;
eyetrack.eyeimgsize = 50;
eyetrack.msgfontsize = 40;
eyetrack.imgtitlefontsize = 40;
eyetrack.displayCalResults = 1;
eyetrack.backgroundcolour = const.background_color;
eyetrack.fixation_outer_rim_rad = const.fix_out_rim_rad;
eyetrack.fixation_rim_rad = const.fix_rim_rad;
eyetrack.fixation_rad = const.fix_rad;
eyetrack.fixation_outer_rim_color = const.fixation_color;
eyetrack.fixation_rim_color = const.background_color;
eyetrack.fixation_color = const.fixation_color;
eyetrack.txtCol = 15;
eyetrack.bgCol = 0;

% Change button to use the button box in the scanner
eyetrack.uparrow = KbName('UpArrow');                                       % Pupil threshold increase
eyetrack.downarrow = KbName('DownArrow');                                   % Pupil threshold decrease
eyetrack.tkey = KbName('LeftArrow');                                        % Toggle Threshold coloring on or off
eyetrack.rightarrow = KbName('RightArrow');                                 % Seyetrackect eye, global or zoomed view for link
eyetrack.pluskey = KbName('=+');                                            % Corneal reflection threshold increase
eyetrack.minuskey = KbName('-_');                                           % Corneal reflection threshold decrease
eyetrack.returnkey = KbName('return');                                      % Show camera image
eyetrack.qkey = KbName('q');                                                % Toggle Ellipse and Centroid pupil center position algorithm
EyelinkUpdateDefaults(eyetrack);

% Initialization of the connection with the Eyeyetrackink Gazetracker.
if ~EyelinkInit(0)
    Eyelink('Shutdown');
    Screen('CloseAll');
    return;
end

% open file to record data to
res = Eyelink('Openfile', const.eyetrack_temp_file);
if res~=0
    fprintf('Cannot create EDF file ''%s'' ', ...
        const.eyetrack_temp_file);
    Eyelink('Shutdown');
    Screen('CloseAll');
    return;
end

% make sure we're still connected.
if Eyelink('IsConnected')~=1 
    fprintf('Not connected. exiting');
    Eyelink('Shutdown');
    Screen('CloseAll');
    return;
end

% Set parser
Eyelink('command', 'file_event_filter = LEFT,RIGHT,FIXATION,SACCADE,BLINK,MESSAGE,BUTTON');
Eyelink('command', 'file_sample_data  = LEFT,RIGHT,GAZE,AREA,GAZERES,STATUS,HTARGET');
Eyelink('command', 'link_event_filter = LEFT,RIGHT,FIXATION,FIXUPDATE,SACCADE,BLINK');
Eyelink('command', 'link_sample_data  = GAZE,GAZERES,AREA,HREF,VELOCITY,FIXAVG,STATUS');

% Screen settings
Eyelink('command','screen_pixel_coords = %d %d %d %d', 0, 0, ...
    scr.scr_sizeX-1, scr.scr_sizeY-1);
Eyelink('command','screen_phys_coords = %d %d %d %d', ...
    scr.disp_sizeLeft, scr.disp_sizeTop, scr.disp_sizeRight, ...
    scr.disp_sizeBot);
Eyelink('command','screen_distance = %d %d', scr.distTop, scr.distBot);
Eyelink('command','simulation_screen_distance = %d', scr.dist*10);

% Tracking mode and settings
Eyelink('command','enable_automatic_calibration = YES');
Eyelink('command','pupil_size_diameter = YES');
Eyelink('command','heuristic_filter = 1 1');
Eyelink('command','saccade_velocity_threshold = 30');
Eyelink('command','saccade_acceleration_threshold = 9500');
Eyelink('command','saccade_motion_threshold = 0.15');
Eyelink('command','use_ellipse_fitter =  NO');
Eyelink('command','sample_rate = %d',1000);

% % Eyetracker calibration and validation
Eyelink('command', 'calibration_type = HV13');
Eyelink('command', 'generate_default_targets = NO');

Eyelink('command', 'randomize_calibration_order 1');
Eyelink('command', 'randomize_validation_order 1');
Eyelink('command', 'cal_repeat_first_target 1');
Eyelink('command', 'val_repeat_first_target 1');

Eyelink('command', 'calibration_samples=14');
Eyelink('command', 'calibration_sequence=0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12');
Eyelink('command', sprintf('calibration_targets = %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i',const.calibCoord));

Eyelink('command', 'validation_samples=14');
Eyelink('command', 'validation_sequence=0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12');
Eyelink('command', sprintf('validation_targets = %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i %i,%i',const.validCoord));

%% make sure we're still connected.
if Eyelink('IsConnected')~=1
    fprintf('Not connected. exiting');
    Eyelink('Shutdown');
    Screen('CloseAll');
    return;
end

end