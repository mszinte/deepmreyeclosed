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
scr.scr_num = max(scr.all); %select biggest available screen to display




% Screen resolution (pixel) :
[scr.scr_sizeX, scr.scr_sizeY] = Screen('WindowSize', scr.scr_num);  %return width and hight of the screen in pixels


fprintf('Current Resolution: [%i, %i]\n', scr.scr_sizeX, scr.scr_sizeY);

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
    scr.disp_sizeX = 773;
    scr.disp_sizeY = 435;
    scr.dist = 120;
    scr.distTop = 1210;
    scr.distBot = 1210;
elseif const.comp == 2
    % Can laptop
    scr.disp_sizeX = 309;
    scr.disp_sizeY = 174;
    scr.dist = 42;
    scr.distTop = 450;
    scr.distBot = 450;
elseif const.comp == 3
    % Settings for Display ++ INT
    scr.disp_sizeX = 696;
    scr.disp_sizeY = 391;
    scr.dist = 120;
    scr.distTop = 1210;
    scr.distBot = 1210;
elseif const.comp == 4
    %settings for Monitor INT
    scr.disp_sizeX = 600;
    scr.disp_sizeY = 350;
    scr.dist = 40;
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

scr.x_mid_deg = pix2angle(scr,scr.x_mid);
scr.y_mid_deg = pix2angle(scr,scr.y_mid);


% Pixels size
scr.clr_depth = Screen('PixelSize', scr.scr_num);

% Frame rate (fps)
scr.frame_duration = 1/(Screen('FrameRate', scr.scr_num));
if scr.frame_duration == inf
    scr.frame_duration = 1/const.desiredFD;
elseif scr.frame_duration == 0
    scr.frame_duration = 1/const.desiredFD;
end

fprintf('Frame rate fps, frame duration: %i', scr.frame_duration)

% Frame rate (hertz)
scr.hz = 1/(scr.frame_duration);
fprintf('Current Frame rate (hertz): %i', scr.hz);
if (scr.hz >= 1.1 * const.desiredFD || scr.hz <= 0.9 * const.desiredFD) ...
        && const.expStart
    error('Restart the program and change the refresh rate to %i Hz',...
        const.desiredFD);
end


%Units settings from Matthias 

scr.scr_sizeX_cm = pix2cm(scr.scr_sizeX,scr);
scr.scr_sizeY_cm = pix2cm(scr.scr_sizeY,scr);

scr.units.ScrDiag_px   =   sqrt(scr.scr_sizeX^2 + scr.scr_sizeY^2); % screen diagonal in pixel
scr.units.ScrDiag_cm   =   sqrt(scr.scr_sizeX_cm^2 + scr.scr_sizeY_cm^2); % screen diagonal in cm
scr.units.pxPcm        =   scr.units.ScrDiag_px/scr.units.ScrDiag_cm; % pixel per cm
scr.units.pxPdeg       =   (scr.dist*tand(1))*scr.units.pxPcm; % pixel per degree

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