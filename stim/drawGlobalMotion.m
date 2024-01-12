function expDes = drawGlobalMotion(scr, const, expDes, mot_int, mot_nbf)
% ----------------------------------------------------------------------
% expDes = drawGlobalMotion(scr, const, expDes, mot_int, mot_nbf)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw global motion patterns
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% expDes : experimental structure
% mot_int: motion interval number
% mot_int: motion frame number
% ----------------------------------------------------------------------
% Output(s):
% expDes : experimental structure
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------

% Define motion
if mot_int == 1; dstRects = const.dstRects1;
elseif mot_int == 2; dstRects = const.dstRects2;
end
gabor_speed = squeeze(expDes.gabor_speed_incS(expDes.trial, ...
    mot_int, :));
if mot_nbf == 1
    expDes.mypars = const.mypars;
    expDes.mypars(1, :) = squeeze(expDes.gabor_phase_lst(expDes.trial, ...
        mot_int, :));
else
    expDes.mypars(1,:) = expDes.mypars(1, :) - gabor_speed';    
end
expDes.mypars(4,:) = const.contrast_vector(mot_nbf);

gabor_orient = squeeze(expDes.gabor_orient_degS(expDes.trial, ...
    mot_int, :));

% Draw motion
Screen('DrawTextures', scr.main, const.gabortex, [], dstRects,...
    gabor_orient, [], [], [], [], kPsychDontDoRotation, ...
    expDes.mypars);

end