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
% ----------------------------------------------------------------------

tic;

% File director
const = dirSaveFile(const);

% Screen configurations
scr = scrConfig(const);

% Triggers and button configurations
my_key = keyConfig(const);

% Experimental constant
const = constConfig(scr, const);

% Experimental design
expDes = designConfig(const);

% Audio configurations
aud = audioConfig;

% Open screen window
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');
PsychImaging('AddTask', 'General', 'NormalizedHighresColorRange');
[scr.main, scr.rect] = PsychImaging('OpenWindow', scr.scr_num, ...
    const.background_color);
 
Screen('BlendFunction', scr.main, GL_ONE, GL_ONE);
Priority(MaxPriority(scr.main));

% Open sound pointer
PsychPortAudio('GetDevices')
aud.master_main = PsychPortAudio('Open', [], aud.master_mode, ...
    aud.master_reqlatclass, aud.master_rate, aud.master_nChannels);
PsychPortAudio('Start', aud.master_main, aud.master_rep, ...
   aud.master_when, aud.master_waitforstart);
PsychPortAudio('Volume', aud.master_main, aud.master_globalVol);
aud.stim_handle = PsychPortAudio('OpenSlave', aud.master_main, ...
   aud.slaveStim_mode);

% Initialize eye tracker
if const.tracker
    eyetrack = initEyeLink(scr,const);
else
    eyetrack = [];
end

% Trial runner
const = runExp(scr, const, expDes, my_key, eyetrack, aud);

% End
overDone(const, my_key);

end