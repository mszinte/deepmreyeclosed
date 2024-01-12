function [const, cFrame, vbl] = playGuidedViewingBullsEye(const, scr, currLoc, frames, flag)
% play fixation or smooth pursuit task
% MN, September 2021



% play all frames
for cFrame = frames
    
    % quit if user aborted experiment
   % [~, firstPress] = KbQueueCheck();
   % if firstPress(my_key.escape) && const.expStart == 0 
   %                 overDone(const, my_key) 
   % end
    
    % draw bullseye
    total_n_Locations =  currLoc+const.passedLocs; 
    if strcmp(flag, 'fixation')
    drawBullsEye(scr, const, const.fixtask.xy_trials{currLoc}(cFrame, 1), const.fixtask.xy_trials{currLoc}(cFrame, 2), 'int1');  

    elseif strcmp(flag, 'pursuit')
    drawBullsEye(scr, const, const.pursuit.xy_trials_pursuit{currLoc}(cFrame, 1), const.pursuit.xy_trials_pursuit{currLoc}(cFrame, 2), 'int1');  
    
    elseif strcmp(flag, 'triangle')
    drawBullsEye(scr, const, const.triang.xy_trials_triang{currLoc}(cFrame, 1), const.triang.xy_trials_triang{currLoc}(cFrame, 2), 'int1'); 

    elseif strcmp(flag, 'triangle_closed')
    drawBullsEye(scr, const, const.triang.xy_trials_triang{currLoc}(cFrame, 1), const.triang.xy_trials_triang{currLoc}(cFrame, 2), 'int1');
     % play sound
    WaitSecs(1.2);
    my_sound(4,aud);
    WaitSecs(1.2);
    my_sound(4,aud);




     

    end
    % finish drawing and flip to screen
    Screen('DrawingFinished', scr.main);
    vbl = Screen('Flip', scr.main);   %save timestamp
    
    
    % log scanner trigger
   % if firstPress(logs{1}.keys.scannerTriggerKey)
   %     logs{1}.tTriggers = [logs{1}.tTriggers, logs{total_n_Trial}.flips(cFrame,1)];
   % end
end

% add trial info to log file
%{total_n_Trial}.trialType = flag;   
%end

