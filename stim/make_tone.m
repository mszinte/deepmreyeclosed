function tone = make_tone(aud, tone_freq, tone_dur)
% ----------------------------------------------------------------------
% tone = make_tone(aud, tone_freq, tone_dur)
% ----------------------------------------------------------------------
% Goal of the function :
% Play a wave file a specified number of time.
% ----------------------------------------------------------------------
% Input(s) :
% aud: sound configuration
% tone_freq: tone frequence list, 0 for no sound, (ex. [300, 0, 300])
% tone_dur: stimulus frequence list (ex. [0.2, 0.8, 0.2])
% ----------------------------------------------------------------------
% Output(s):
% tone : tone stimulus to play
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Edited by Sina KLING (sina.kling@outlook.de)
% ----------------------------------------------------------------------

% Compute ramped sound
stimAll = [];
rampAll = [];
for tStim = 1:max(size(tone_freq))
    for i = 1:aud.master_nChannels
        stim(i,:) = MakeBeep(tone_freq(tStim), tone_dur(tStim), ...
            aud.master_rate);
        ramp(i,:) = [aud.rampOffOn,...
                     ones(1,size(stim(i,:),2) - size(aud.rampOffOn,2) ...
                     - size(aud.rampOnOff,2)), ...
                     aud.rampOnOff];
    end
    stimAll = [stimAll,stim];stim =[];
    rampAll = [rampAll,ramp];ramp =[];
end

tone = stimAll.* rampAll;
%plot(1:size(tone,2),tone(1,:))

end
