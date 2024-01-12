function expDes = runTrials(scr, const, expDes, my_key, aud)
% ----------------------------------------------------------------------
% expDes = runTrials(scr, const, expDes, my_key, aud)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw stimuli of each indivual trial and waiting for inputs
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% expDes : struct containg experimental design
% my_key : structure containing keyboard configurations
% aud : structure containing audio configurations
% ----------------------------------------------------------------------
% Output(s):
% resMat : experimental results (see below)
% expDes : struct containing all the variable design configurations.
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------

% Open video
if const.mkVideo
    open(const.vid_obj);
end

% Trial counter
t = expDes.trial;

% Compute and simplify var and rand
var1 = expDes.expMat(t, 5);  %extract task variable from experimental design matrix


% Check trial
if const.checkTrial && const.expStart == 0
    fprintf(1,'\n\n\t============= TRIAL %3.0f ==============\n',t);
    fprintf(1,'\n\tTask  =\t%s', ...
        const.task_txt{var1});
end

% Time settings
% Task 1 Fixation
task_1_1_nbf_on = 1;
task_1_1_nbf_off = task_1_1_nbf_on + const.fixtask.dur_frm - 1; %171
% Task 1 Pursuit
task_1_2_nbf_on = task_1_1_nbf_off + 1;
task_1_2_nbf_off = task_1_2_nbf_on + const.pursuit.dur_frm - 1; %2142
% Task 1 Free Viewing
task_1_3_nbf_on = task_1_2_nbf_off + 1;
task_1_3_nbf_off = task_1_3_nbf_on + const.picTask.dur_frm - 1; %3213

%Task 2 (Open)
task_2_nbf_on = 1;
task_2_nbf_off = task_2_nbf_on + const.triang.dur_frm - 1;

%Task 3 (Part Closed) 
task_3_nbf_on = 1;
task_3_nbf_off = task_3_nbf_on + const.triang_closed.dur_frm - 1;

 
% Wait first MRI trigger
if t == 1
    Screen('FillRect',scr.main,const.background_color);
    drawBullsEye(scr, const, scr.x_mid, scr.y_mid, 'conf');
    Screen('Flip',scr.main);
    
    first_trigger = 0;
    expDes.mri_band_val = my_key.first_val(3);
    while ~first_trigger
        if const.scanner == 0 || const.scannerTest
            first_trigger = 1;
            mri_band_val = -8;
        else
            keyPressed = 0;
            keyCode = zeros(1,my_key.keyCodeNum);
            for keyb = 1:size(my_key.keyboard_idx, 2)
                [keyP, keyC] = KbQueueCheck(my_key.keyboard_idx(keyb));
                keyPressed = keyPressed + keyP;
                keyCode = keyCode + keyC;
            end
            if const.scanner == 1
                input_return = [my_key.ni_session2.inputSingleScan,...
                    my_key.ni_session1.inputSingleScan];
                if input_return(my_key.idx_mri_bands) == ...
                        ~expDes.mri_band_val
                    keyPressed = 1;
                    keyCode(my_key.mri_tr) = 1;
                    expDes.mri_band_val = ~expDes.mri_band_val;
                    mri_band_val = input_return(my_key.idx_mri_bands);
                end
            end
            if keyPressed
                if keyCode(my_key.escape) && const.expStart == 0
                    overDone(const, my_key)
                elseif keyCode(my_key.mri_tr)
                    first_trigger = 1;
                end
            end
        end
    end

    % Write in edf file
    log_txt = sprintf('trial %i mri_trigger val = %i', t, ...
                mri_band_val);
    if const.tracker; Eyelink('message', '%s', log_txt); end
end

% Write in edf file
if const.tracker
    Eyelink('message', '%s', sprintf('trial %i started\n', t));
end




%-------------------------TASK 1--------------------------
%Fixation
if var1 == 1
    % Trial loop
    task_1_1_nbf = 0; 
    task_1_2_nbf = 0;
    task_1_3_nbf = 0;
 
    
    % Draw background
    Screen('FillRect', scr.main, const.background_color );

    const.passedLocs = 1;
    const.passedLocs = const.passedLocs + 1; currLoc = 0;
    %instructionsIm(scr,const,my_key,'Task_1_fixation',1); %show instructions

    while currLoc<=numel(const.fixtask.xy_trials)-1 %for the amount of generated locations
        currLoc = currLoc + 1; 
        cFrame = 0;
        
       % send trial info to eye tracker
        if const.tracker; Eyelink('Message',sprintf('Trial%d', currLoc)); end
        
        % show fixation sequence
        frames = cFrame+1:cFrame+const.fixtask.dur_sec*scr.hz;
        [const, cFrame, vbl_fix] = playGuidedViewingBullsEye(const, scr, currLoc, frames, 'fixation');
        % Flip count
        task_1_1_nbf = cFrame + 1 ;
        const.passedLocs = const.passedLocs + currLoc;
        
    end
    



%Smooth Pursuit

    const.passedLocs = const.passedLocs + 1; currLoc = 0;  %set current Location counter to 0 again, continue passedLocs counter
    instructionsIm(scr,const,my_key,'Task_1_smooth',1); %show instructions
    while currLoc<=numel(const.pursuit.xy_trials_pursuit)-1 %&& logs{1}.userQuit == 0 TODO:adapt    %while current Loc is smaller than 73, do the following
        currLoc = currLoc + 1; 
        cFrame = 0;    %play for each frame
        
        % send trial info to eye tracker
        if const.tracker; Eyelink('Message',sprintf('Trial%d', currLoc)); end
        
        % show pursuit sequence
        frames = cFrame+1:cFrame+const.pursuit.dur_sec*scr.hz;   %calculate number of frames
        [const, cFrame, vbl_pur] = playGuidedViewingBullsEye(const, scr, currLoc, frames, 'pursuit');
        %Flip count
        task_1_2_nbf = task_1_1_nbf + cFrame + 1;
        const.passedLocs = const.passedLocs + currLoc;
    end
    

    
    
    %Picture Viewing
    
    
    const = importPics(const,scr);          % load images for picture viewing
    
    const.passedLocs = const.passedLocs + 1; currLoc = 0; %set current trial counter to 0 again
    instructionsIm(scr,const,my_key,'Task_1_freeviewing',1); %show instructions
    while currLoc<numel(const.pics.id) %&& logs{1}.userQuit == 0 TODO: adaot
        currLoc = currLoc + 1; 
        cFrame = 0;
        
        % send trial info to eye tracker
        if const.tracker; Eyelink('Message',sprintf('Trial%d', currLoc)); end
        
        % draw image
        frames = cFrame+1:cFrame+const.picTask.dur_sec*scr.hz;
        [const, scr, vbl_pic] = playPictureViewing(const, scr, currLoc, frames);
        %Flip Count 
        task_1_3_nbf = task_1_2_nbf + cFrame + 1;
        const.passedLocs = const.passedLocs+ currLoc;
        
    end

    if task_1_1_nbf == task_1_1_nbf_off 
        vbl = vbl_fix;
        trial_on = vbl;
        fprintf('task 1 fixation %i onset at %f', t, vbl);
        log_txt = sprintf('task 1 fixation %i onset at %f', t, vbl);
        if const.tracker; Eyelink('message','%s',log_txt); end
    elseif task_1_2_nbf == task_1_2_nbf_off
        vbl = vbl_pur;
        trial_on = vbl;
        log_txt = sprintf('task 1 pursuit %i onset at %f', t, vbl);
        fprintf('task 1 pursuit %i onset at %f', t, vbl);
        if const.tracker; Eyelink('message','%s',log_txt); end
    elseif task_1_3_nbf == task_1_3_nbf_off
        vbl = vbl_pic;
        trial_on = vbl;
        log_txt = sprintf('task 1 pursuit %i onset at %f', t, vbl);
        fprintf('task 1 pursuit %i onset at %f', t, vbl);
        if const.tracker; Eyelink('message','%s',log_txt); end
    end
    
end


    


    
%-----------------TASK  2 -------------------------------------
if var1 == 2
    task_2_nbf = 0; 
    const.passedLocs = 1;
    const.passedLocs = const.passedLocs + 1; currLoc = 0;
    
    const = generateRepeatedTriangle(const, scr, const.triang.dur_sec,const.triang.coords_all);
   
    while currLoc < numel(const.triang.xy_trials_triang)
        currLoc = currLoc + 1;
        cFrame = 0;  
    
        % send trial info to eye tracker
        % if settings.eyeTracking == 1; Eyelink('Message',sprintf('Tr%d', currTrial)); end
    
        % draw image
        frames = cFrame + 1 : cFrame + const.triang.dur_sec * scr.hz;
    
        % Display them
        [const, cFrame, vbl] = playGuidedViewingBullsEye(const, scr, currLoc, frames, 'triangle');
        task_2_nbf = cFrame + 1;
    end
    
    const.passedLocs = const.passedLocs + currLoc;

    if task_2_nbf == task_2_nbf_off 
    trial_on = vbl;
    fprintf('task 2 %i onset at %f', t, vbl);
    log_txt = sprintf('task 2  %i onset at %f', t, vbl);
    if const.tracker; Eyelink('message','%s',log_txt); end
    end
end
%-----------------TASK  3 -------------------------------------

if var1 == 3
    task_3_nbf = 0;
    const.passedLocs = 1;
    const.passedLocs = const.passedLocs + 1; currLoc = 0;
    
    const = generateRepeatedTriangle(const, scr, const.triang_closed.dur_sec, const.triang.coords_all);
    
    while currLoc < numel(const.triang.xy_trials_triang)
        currLoc = currLoc + 1;
        cFrame = 0;
    
        % send trial info to eye tracker
        % if settings.eyeTracking == 1; Eyelink('Message',sprintf('Tr%d', currTrial)); end
    
        % draw image
        frames = cFrame + 1 : cFrame + const.triang_closed.dur_sec * scr.hz;
    
        % Display them
        [const, cFrame, vbl] = playGuidedViewingBullsEye(const, scr, currLoc, frames, 'triangle');
        task_3_nbf = cFrame;
        
    end
    
    const.passedLocs = const.passedLocs + currLoc;
    if task_3_nbf == task_3_nbf_off 
    trial_on = vbl;
    fprintf('task 3 %i onset at %f', t, vbl);
    log_txt = sprintf('task 3  %i onset at %f', t, vbl);
    if const.tracker; Eyelink('message','%s',log_txt); end
    end
end

%---------------TASK 4 ----------------------------------------
if var1 == 4  


    %play sound
    WaitSecs(1.2);
    my_sound(4,aud);
    WaitSecs(1.2);
    my_sound(4,aud);
  
   
end  

instructionsIm(scr,const,my_key,'End_block',1); %show instructions


% Check keyboard
keyPressed = 0;
keyCode = zeros(1,my_key.keyCodeNum);
for keyb = 1:size(my_key.keyboard_idx,2)
    [keyP, keyC] = KbQueueCheck(my_key.keyboard_idx(keyb));
    keyPressed = keyPressed + keyP;
    keyCode = keyCode + keyC;
end

if const.scanner == 1 && ~const.scannerTest
    input_return = [my_key.ni_session2.inputSingleScan, ...
        my_key.ni_session1.inputSingleScan];
    
    % button press trigger
    if input_return(my_key.idx_button_left1) == ...
            my_key.button_press_val
        keyPressed = 1;
        keyCode(my_key.left1) = 1;
    elseif input_return(my_key.idx_button_left2) == ...
            my_key.button_press_val
        keyPressed = 1;
        keyCode(my_key.left2) = 1;
    elseif input_return(my_key.idx_button_left3) == ...
            my_key.button_press_val
        keyPressed = 1;
        keyCode(my_key.left3) = 1;
    elseif input_return(my_key.idx_button_right1) == ...
            my_key.button_press_val
        keyPressed = 1;
        keyCode(my_key.right1) = 1;
    elseif input_return(my_key.idx_button_right2) == ...
            my_key.button_press_val
        keyPressed = 1;
        keyCode(my_key.right2) = 1;
    elseif input_return(my_key.idx_button_right3) == ...
            my_key.button_press_val
        keyPressed = 1;
        keyCode(my_key.right3) = 1;
    end
    
    % mri trigger
    if input_return(my_key.idx_mri_bands) == ~expDes.mri_band_val
        keyPressed = 1;
        keyCode(my_key.mri_tr) = 1;
        expDes.mri_band_val = ~expDes.mri_band_val;
        mri_band_val = input_return(my_key.idx_mri_bands);
    end
end
% Deal with responses
if keyPressed
    if keyCode(my_key.mri_tr)
        % MRI triggers
        log_txt = sprintf('trial %i mri_trigger val = %i',t, ...
            mri_band_val);
        if const.tracker; Eyelink('message','%s',log_txt); end
    elseif keyCode(my_key.escape)
        % Escape button
        if const.expStart == 0; overDone(const, my_key);end
    end
end

expDes.expMat(t, 1) = 0; % to FIX
expDes.expMat(t, 2) = 0;

% Write in log/edf
if const.tracker
    Eyelink('message', '%s', sprintf('trial %i ended\n', t));
end

% When no response received
%if resp_int1 == 0
%    expDes.expMat(t, 9) = 0;
%    expDes.expMat(t, 10) = 0;
%end

%if resp_int2 == 0
%    expDes.expMat(t, 11) = 0;
%    expDes.expMat(t, 12) = 0;
%end

%if resp_conf == 0
%    expDes.expMat(t, 13) = 0;
%    expDes.expMat(t, 14) = 0;
%end

    
end