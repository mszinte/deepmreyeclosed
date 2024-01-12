function drawBullsEye(scr, const, coordX, coordY, type)
% ----------------------------------------------------------------------
% drawBullsEye(scr, const, coordX, coordY, type)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw bull's eye target
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% coordX: bull's eye coordinate X
% coordY: bull's eye coordinate Y
% type : bull's eye type ('conf': confidence judgment period, 
%                         'int1': 1st-interval motion judgment period, 
%                         'int2': 2nd-interval motion judgment period)
% ----------------------------------------------------------------------
% Output(s):
% none
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------

if strcmp(type, 'conf')
    % full dot
    Screen('FillOval', scr.main, const.fixation_color-const.background_color,...
        [coordX - const.fix_out_rim_rad, coordY - const.fix_out_rim_rad,...
        coordX + const.fix_out_rim_rad, coordY + const.fix_out_rim_rad]);

else
    % two rings bull's eye
    Screen('FillOval', scr.main, const.fixation_color-const.background_color,...
        [coordX - const.fix_out_rim_rad, coordY - const.fix_out_rim_rad,...
        coordX + const.fix_out_rim_rad, coordY + const.fix_out_rim_rad]);
    
    Screen('FillOval', scr.main, -(const.fixation_color-const.background_color),...
        [coordX - const.fix_rim_rad, coordY - const.fix_rim_rad, ...
        coordX + const.fix_rim_rad, coordY + const.fix_rim_rad]);
    
    Screen('FillOval', scr.main, const.fixation_color-const.background_color,...
        [coordX - const.fix_rad, coordY - const.fix_rad, ...
        coordX + const.fix_rad, coordY + const.fix_rad]);
    
end
end

