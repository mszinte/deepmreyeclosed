function scr = scrConfig(const)
% ----------------------------------------------------------------------
% scr = scrConfig(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Define screen settings
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% scr : struct containing screen configurations
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------

% Number of the exp screen
scr.all = Screen('Screens');
scr.scr_num = max(scr.all); 

% Screen resolution (pixel) :
[scr.scr_sizeX, scr.scr_sizeY] = Screen('WindowSize', scr.scr_num); 

if (scr.scr_sizeX ~= const.desiredRes(1) || scr.scr_sizeY ~= ...
        const.desiredRes(2)) && const.expStart
    error('Restart the program and change the resolution to [%i,%i]',...
        const.desiredRes(1),const.desiredRes(2));
end

% Overwrite if scanning
if const.scanner == 1 && ~const.scannerTest
    const.comp = 1;
end

% Size of the display
if const.comp == 1
    % Settings 3T MRI room projector
    scr.disp_sizeX = 781.9;
    scr.disp_sizeY = 440;
    scr.dist = 123;
    scr.distTop = 1230;
    scr.distBot = 1230;
elseif const.comp == 2
    % Settings for Display ++ INT
    scr.disp_sizeX = 696;
    scr.disp_sizeY = 391;
    scr.dist = 120;
    scr.distTop = 1210;
    scr.distBot = 1210;
end
scr.disp_sizeLeft = round(-scr.disp_sizeX/2);
scr.disp_sizeRight = round(scr.disp_sizeX/2);
scr.disp_sizeTop = round(scr.disp_sizeY/2);
scr.disp_sizeBot = round(-scr.disp_sizeY/2);
scr.x_mid = (scr.scr_sizeX/2.0);
scr.y_mid = (scr.scr_sizeY/2.0);
scr.mid = [scr.x_mid,scr.y_mid];


% Pixels size
scr.clr_depth = Screen('PixelSize', scr.scr_num);

% Frame rate (fps)
scr.frame_duration = 1/(Screen('FrameRate', scr.scr_num));
if scr.frame_duration == inf
    scr.frame_duration = 1/const.desiredFD;
elseif scr.frame_duration == 0
    scr.frame_duration = 1/const.desiredFD;
end


% Frame rate (hertz)
scr.hz = 1/(scr.frame_duration);
if (scr.hz >= 1.1 * const.desiredFD || scr.hz <= 0.9 * const.desiredFD) ...
        && const.expStart
    error('Restart the program and change the refresh rate to %i Hz',...
        const.desiredFD);
end


% Overal settings
if ~const.expStart
    Screen('Preference','VisualDebugLevel', 0);
    Screen('Preference','SyncTestSettings', 0.01, 50, 0.25);
else
    Screen('Preference','VisualDebugLevel', 0);
    Screen('Preference','SyncTestSettings', 0.01, 50, 0.25);
    Screen('Preference','SuppressAllWarnings', 1);
    Screen('Preference','Verbosity', 0);
end


end