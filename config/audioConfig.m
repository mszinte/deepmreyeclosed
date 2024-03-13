function aud = audioConfig
% ----------------------------------------------------------------------
% aud = audioConfig
% ----------------------------------------------------------------------
% Goal of the function :
% Define audio configuration
% ----------------------------------------------------------------------
% Input(s) :
% none
% ----------------------------------------------------------------------
% Output(s):
% aud : struct containing audio settings
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Edited by Sina KLING (sina.kling@outlook.de)
% ----------------------------------------------------------------------


% Master
aud.master_mode = 1+8;       	% mode of operation
aud.master_reqlatclass = 1;     % try to get the lowest latency 
aud.master_nChannels = 2;       % number of audio channels to use (2 = stereo)
aud.master_rate = 44100;        % master rate in samples per second (Hz);
aud.master_rep = 0;             % repetition of the sound data
aud.master_when = 0;            % time the device should start
aud.master_waitforstart = 0;    % wait until device has really started
aud.master_globalVol = 0.3;     % volume 

% Slaves
aud.slaveStim_mode = 1;         % mode of operation (1 = sound playback only)
aud.slave_rep = 1;              % repetitions
aud.slave_when = 0;             % time the device should start
aud.slave_waitforstart = 0;     % wait until device has really started
aud.activeChannels = [1;2];
InitializePsychSound(1);        % Initialize Sounddriver:

% Sound settings
aud.rampDur = 0.005;
aud.ramp_sampleLenght = 1;
aud.rampOffOn = makeOffOnRamp(aud.rampDur,aud.ramp_sampleLenght,aud.master_rate);
aud.rampOnOff = makeOnOffRamp(aud.rampDur,aud.ramp_sampleLenght,aud.master_rate);


end