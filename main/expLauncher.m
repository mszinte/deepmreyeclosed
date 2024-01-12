%% General experimenter launcher
%  =============================
% By: Martin SZINTE, modified by Sina Kling
% Projet: DeepMReye Calibration exp


% Version description
% -------------------
% Experiment in perfom different fixation tasks, some trials with eyes
% closed in order to get gaze data to train DeepMReye network

% TODO (Sina)
% -------------
% add logs 
% finish experimenta design

% First settings
Screen('CloseAll'); clear all; clear mex; clear functions; close all; ...
    home; AssertOpenGL;

% General settings
const.expName = 'Calibration';      % experiment name
const.expStart = 0;                    % Start of a recording (0 = NO, 1 = YES)
const.checkTrial = 0;                  % Print trial conditions (0 = NO, 1 = YES)
const.mkVideo = 0;                     % Make a video (0 = NO, 1 = YES)

% External controls
const.tracker = 0;                     % run with eye tracker (0 = NO, 1 = YES)
const.comp = 4;                        % run in which computer (1 = MRI; 2 = Can laptop; 3 = Diplay++; 4 = Monitor)
const.scanner = 0;                     % run in MRI scanner (0 = NO, 1 = YES)
const.scannerTest = 0;                 % fake scanner trigger (0 = NO, 1 = YES)
const.training = 0;                    % training session (0 = NO, 1 = YES)
const.run_total = 1;                   % number of run in total

% Desired screen setting
const.desiredFD = 60;          % Desired refresh rate
const.desiredRes = [2880, 1620];% [1920, 1080]Desired resolution



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