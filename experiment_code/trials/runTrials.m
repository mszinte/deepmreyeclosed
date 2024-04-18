function expDes = runTrials(scr, const, expDes, my_key, aud)
% ----------------------------------------------------------------------
% expDes = runTrials(scr, const, expDes, my_key)
% ----------------------------------------------------------------------
% Goal of the function :
% Draw stimuli of each indivual trial and waiting for inputs
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% expDes : struct contain experimental design and trial specs
% my_key : structure containing keyboard configurations
% ----------------------------------------------------------------------
% Output(s):
% expDes : struct contain experimental design and trial specs
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% Edited by Sina KLING (sina.kling@outlook.de)
% ----------------------------------------------------------------------

for t = 1:const.nb_trials

    % Open video
    if const.mkVideo
        open(const.vid_obj);
    end
    
    % Compute and simplify var and rand
    task = expDes.expMat(t, 5);
    var1 = expDes.expMat(t, 6);
    
    % Check trial
    if const.checkTrial && const.expStart == 0
        fprintf(1,'\n\n\t=================== TRIAL %3.0f ====================\n',t);
        fprintf(1,'\n\tTask =            \t%s', const.task_txt{task});
        if ~isnan(var1); fprintf(1,'\n\tFixation position =\t%s', ...
                const.fix_coords_txt{var1}); end
    end
    
    % Timing
    if task == 1
        trial_offset_nbf = const.iti_dur_frm;
    else
        trial_offset_nbf = const.trial_dur_frm;
    end
    
    % Compute fixation coordinates
    fix_coords = const.fix_coords(var1, :);
    
    % Load the sound
    if task == 1
        PsychPortAudio('FillBuffer',aud.stim_handle, const.iti_tones);
        if const.mkVideo
            expDes.vid_audio_mat = [expDes.vid_audio_mat, const.iti_tones];
        end
    else
        PsychPortAudio('FillBuffer', aud.stim_handle, const.trial_tones);
        if const.mkVideo
            expDes.vid_audio_mat = [expDes.vid_audio_mat, const.trial_tones];
        end
    end
    
    % Wait first MRI trigger
    if t == 1
        Screen('FillRect',scr.main,const.background_color);
        drawBullsEye(scr, const, scr.x_mid, scr.y_mid, 0);
        Screen('Flip',scr.main);
    
        first_trigger = 0;
        expDes.mri_band_val = my_key.first_val(end);
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
                        overDone(const, my_key);
                    elseif keyCode(my_key.mri_tr)
                        first_trigger = 1;
                        mri_band_val = -8;
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
    
    % Main diplay loop
    nbf = 0;
    play_sound = 0;
    while nbf < trial_offset_nbf
        % Flip count
        nbf = nbf + 1;
        Screen('FillRect', scr.main, const.background_color)
    
        % Inter-trial interval / eyes open / eyes blink
        if task == 1 || task == 2 
            drawBullsEye(scr, const, fix_coords(1), fix_coords(2), 1);
        elseif task == 3
            drawBullsEye(scr, const, fix_coords(1), fix_coords(2), 0);
        elseif task == 4
            % eyes closed no dot
        elseif task == 5 
            % eyes open no stimulus no dot
        end

        % Play sound
        if ~play_sound
            PsychPortAudio('Start', aud.stim_handle, aud.slave_rep, aud.slave_when, aud.slave_waitforstart);
            
            play_sound = 1;
        end

        % Check keyboard
        keyPressed = 0;
        keyCode = zeros(1,my_key.keyCodeNum);
        for keyb = 1:size(my_key.keyboard_idx,2)
            [keyP, keyC] = KbQueueCheck(my_key.keyboard_idx(keyb));
            keyPressed = keyPressed + keyP;
            keyCode = keyCode + keyC;
        end
        if keyPressed
            if keyCode(my_key.escape) && const.expStart == 0
                overDone(const, my_key);
            end
        end
        
        % flip screen
        vbl = Screen('Flip', scr.main);
        
        % Create movie
        if const.mkVideo
            if mod(nbf, const.TR_frm) == 1
                expDes.vid_num = expDes.vid_num + 1;
                image_vid = Screen('GetImage', scr.main);
                imwrite(image_vid,sprintf('%s_frame_%i.png', ...
                    const.movie_image_file, expDes.vid_num))
                writeVideo(const.vid_obj,image_vid);
            end
        end
        
        if nbf == 1
            trial_on = vbl;
        end
    end
    expDes.expMat(t, 1) = trial_on;
    expDes.expMat(t, 2) = vbl - trial_on;
    
    % Write in log/edf
    if const.tracker
        Eyelink('message', '%s', sprintf('trial %i ended\n', t));
    end
end

end