%% General experimenter launcher
%  =============================
% By: Sina KLING
% Projet: DeepMReyeClosed

% Experimental design : ~7min
% Task 1: triangle with eyes open 
% Task 2: triangle with eyes partly closed
% Task 3: triangle with eyes closed

% TODO (Sina)
% ----------- 
% put sounds with video
% check in testing room
% see with eye tracker 
% analyse data of eye tracker
% test in scanner

% First settings
Screen('CloseAll'); clear all; clear mex; clear functions; close all; ...
    home; AssertOpenGL;

% General settings
const.expName = 'DeepMReyeClosed';      % experiment name
const.expStart = 0;                     % Start of a recording (0 = NO, 1 = YES)
const.checkTrial = 1;                   % Print trial conditions (0 = NO, 1 = YES)
const.mkVideo = 1;                      % Make a video (0 = NO, 1 = YES)

% External controls
const.tracker = 0;                      % run with eye tracker (0 = NO, 1 = YES)
const.comp = 1;                         % run in which computer (1 = MRI; 2 = Diplay++)
const.scanner = 1;                      % run in MRI scanner (0 = NO, 1 = YES)
const.scannerTest = 1;                  % fake scanner trigger (0 = NO, 1 = YES)
const.training = 0;                     % training session (0 = NO, 1 = YES)

% Desired screen setting
const.desiredFD = 120;                  % Desired refresh rate
const.desiredRes = [1920, 1080];        % Desired resolution

% Path
dir = which('expLauncher');
cd(dir(1:end-18));

% Add Matlab path
addpath('config', 'main', 'conversion', 'eyeTracking', 'instructions',...
    'trials', 'stim');

% Subject configuration
const = sbjConfig(const);

% Main run
main(const);