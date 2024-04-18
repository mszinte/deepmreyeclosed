function main(const)
% ----------------------------------------------------------------------
% main(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Launch all function of the experiment
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing a lot of constant configuration
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Edited by Sina KLING (sina.kling@outlook.de)
% ----------------------------------------------------------------------

tic;

% File director
const = dirSaveFile(const);

% Screen configurations
scr = scrConfig(const);

% Audio configurations
aud = audioConfig;

% Triggers and button configurations
my_key = keyConfig(const);

% Experimental constant
const = constConfig(scr, const, aud);

% Experimental design
expDes = designConfig(const);

% Open screen windows
[scr.main, scr.rect] = Screen('OpenWindow', scr.scr_num, ...
    const.background_color, [], scr.clr_depth, 2);
[~] = Screen('BlendFunction', scr.main, GL_SRC_ALPHA, ...
    GL_ONE_MINUS_SRC_ALPHA);
priorityLevel = MaxPriority(scr.main);Priority(priorityLevel);

% Open sound pointer
aud.master_main = PsychPortAudio('Open', [], aud.master_mode,...
    aud.master_reqlatclass, aud.master_rate ,aud.master_nChannels);
PsychPortAudio('Start', aud.master_main, aud.master_rep, ...
    aud.master_when, aud.master_waitforstart);
PsychPortAudio('Volume', aud.master_main, aud.master_globalVol);
aud.stim_handle = PsychPortAudio('OpenSlave', aud.master_main, ...
    aud.slaveStim_mode);

% Initialize eye tracker
if const.tracker
    eyetrack = initEyeLink(scr, const);
else
    eyetrack = [];
end

% Trial runner
const = runExp(scr, const, expDes, my_key, eyetrack, aud);

% End
overDone(const, my_key);

end