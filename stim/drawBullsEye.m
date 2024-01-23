function drawBullsEye(scr, const, coordX, coordY)
% ----------------------------------------------------------------------
% drawBullsEye(scr, const, coordX, coordY)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw bull's eye target
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% coordX: bull's eye coordinate X
% coordY: bull's eye coordinate Y
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

Screen('FillOval', scr.main, const.fixation_color,...
    [coordX - const.fix_rad, coordY - const.fix_rad, ...
     coordX + const.fix_rad, coordY + const.fix_rad]);
    
end

