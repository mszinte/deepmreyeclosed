function drawBullsEye(scr, const, coordX, coordY, in_target)
% ----------------------------------------------------------------------
% drawBullsEye(scr, const, coordX, coordY, in_target)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw bull's eye target
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% coordX: bull's eye coordinate X
% coordY: bull's eye coordinate Y
% in_target: if 1 show center of bull's eye
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------

Screen('FillOval', scr.main, const.fixation_color,...
    [coordX - const.fix_out_rim_rad, coordY - const.fix_out_rim_rad,...
    coordX + const.fix_out_rim_rad, coordY + const.fix_out_rim_rad]);

Screen('FillOval', scr.main, const.background_color,...
    [coordX - const.fix_rim_rad, coordY - const.fix_rim_rad, ...
    coordX + const.fix_rim_rad, coordY + const.fix_rim_rad]);

if in_target
    Screen('FillOval', scr.main, const.fixation_color,...
        [coordX - const.fix_rad, coordY - const.fix_rad, ...
         coordX + const.fix_rad, coordY + const.fix_rad]);
end

end

