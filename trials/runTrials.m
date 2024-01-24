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
% expDes : struct containg experimental design
% my_key : structure containing keyboard configurations
% ----------------------------------------------------------------------
% Output(s):
% resMat : experimental results (see below)
% expDes : struct containing all the variable design configurations.
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------

trial_pursuit = 0;
for t = 1:const.nb_trials

    % Open video
    if const.mkVideo
        open(const.vid_obj);
    end
    
    % Compute and simplify var and rand
    task = expDes.expMat(t, 5);
    var1 = expDes.expMat(t, 6); 
    var2 = expDes.expMat(t,7);
    
   

    % Check trial
    if const.checkTrial && const.expStart == 0
        fprintf(1,'\n\n\t=================== TRIAL %3.0f ====================\n',t);
        fprintf(1,'\n\tTask =             \t%s', const.task_txt{task});
        if ~isnan(var1); fprintf(1,'\n\tTriangle rotation =\t%s', ...
                const.triangle_rotation_txt{var1}); end
        if ~isnan(var2); fprintf(1,'\n\tFixation position =\t%s', ...
                const.triangle_position_txt{var2}); end
    end
    
    % Timing
    switch task
        case 1
            iti_onset_nbf = 1;
            iti_offset_nbf = const.iti_dur_frm;
            trial_offset = iti_offset_nbf;
        case 2
            triang_open_onset_nbf = 1;
            triang_open_offset_nbf = const.triang_open_dur_frm;
            trial_offset = triang_open_offset_nbf;
        case 3
            triang_part_onset_nbf = 1;
            triang_part_offset_nbf = const.triang_part_dur_frm;
            trial_offset = triang_part_offset_nbf;
        case 4
            triang_closed_onset_nbf = 1;
            triang_closed_offset_nbf = const.triang_closed_dur_frm;
            trial_offset = triang_closed_offset_nbf;
    end
    
    % Compute coordinates inter trial interval
    if task == 1
        iti_x = scr.x_mid;
        iti_y = scr.y_mid;
    end

    % Compute coordinates triangle
    if task == 2 
        triang_coord = [const.triang_coords_up_left;const.triang_coords_up_right;...
                        const.triang_coords_middle; const.triang_coords_down_left;...
                        const.triang_coords_down_right];

        triang_x = triang_coord(var2,1); 
        triang_y = triang_coord(var2,2);
    end 

    % Compute coordinates triangle
    if task == 3
        triang_coord = [const.triang_coords_up_left;const.triang_coords_up_right;...
                        const.triang_coords_middle; const.triang_coords_down_left;...
                        const.triang_coords_down_right];

        triang_x = triang_coord(var2,1); 
        triang_y = triang_coord(var2,2);
    end
   
    

    % Wait first MRI trigger
    if t == 1
        Screen('FillRect',scr.main,const.background_color);
        drawBullsEye(scr, const, scr.x_mid, scr.y_mid);
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
    
    % Main diplay loop
    nbf = 0;
    soundInterval = 0; %initialize the sound counter
    playSound1 = 0; 
    playSound2 = 0;
    playSound3 = 0;

    while nbf < trial_offset
        % Flip count
        nbf = nbf + 1;
    
        Screen('FillRect', scr.main, const.background_color)
    
        % Inter-trial interval
        if task == 1
            if nbf >= iti_onset_nbf && nbf <= iti_offset_nbf 
                drawBullsEye(scr, const, iti_x, iti_y);
                playSound1 = 0;
                playSound2 = 0;
                playSound3 = 0;
            end
        end
        
        % Triangle eyes open
        if task == 2
            if nbf >= triang_open_onset_nbf && nbf <= triang_open_offset_nbf
                drawBullsEye(scr, const, triang_x, triang_y);
                playSound1 = 1;
                playSound2 = 0;
                playSound3 = 0;
            elseif nbf > triang_open_offset_nbf
                playSound1 = 0;
            end
        end
        
        % Triangle eyes partly closed
        if task == 3
            if nbf >= triang_part_onset_nbf && nbf <= triang_part_offset_nbf
                drawBullsEye(scr, const, triang_x, triang_y);
                playSound1 = 0;
                playSound2 = 1;
                playSound3 = 0;
            elseif nbf > triang_part_offset_nbf
                playSound2 = 0;
            end
        end
        
        % Freeview task
        if task == 4
            if nbf >= triang_closed_onset_nbf && nbf <= triang_closed_offset_nbf
                playSound1 = 0;
                playSound2 = 0;
                playSound3 = 1;
            elseif nbf > triang_closed_offset_nbf
                playSound3 = 0;
            end
                     
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
                overDone(const, my_key)
            end
        end
        
        % Create movie
        if const.mkVideo
            expDes.vid_num = expDes.vid_num + 1;
            image_vid = Screen('GetImage', scr.main);
            imwrite(image_vid,sprintf('%s_frame_%i.png', ...
                const.movie_image_file, expDes.vid_num))
            writeVideo(const.vid_obj,image_vid);
        end
        
        % flip screen
        vbl = Screen('Flip', scr.main);

        % Check if it's time to play the sound (every const.sound_interval_frm frames)
        if mod(nbf - 1, const.sound_interval_frm) == 0
            % Play sound 1, sound 2, and sound 3 sequentially
            if playSound1
                my_sound(1, aud);
                soundInterval = soundInterval + 1;
                playSound1 = 0;
                playSound2 = 1;
            elseif playSound2
                my_sound(2, aud);
                soundInterval = soundInterval + 1;
                playSound2 = 0;
                playSound3 = 1;
            elseif playSound3
                my_sound(3, aud);
                soundInterval = soundInterval + 1;
                playSound3 = 0;
                % Reset the sound counter after playing all three sounds
                if soundInterval == const.total_sound_intervals
                    soundInterval = 0;
                end
                % Set playSound1 to true to start the sequence again
                playSound1 = 1;
            end
        end
        
        % Save trials times
        if task == 1
            if nbf == iti_onset_nbf
                trial_on = vbl;
                log_txt = sprintf('iti %i onset at %f', t, vbl);
                if const.tracker; Eyelink('message','%s',log_txt); end
            elseif nbf == iti_offset_nbf
                log_txt = sprintf('iti %i offset at %f', t, vbl);
                if const.tracker; Eyelink('message','%s',log_txt); end
            end
        elseif task == 2
            if nbf == triang_open_onset_nbf
                trial_on = vbl;
                log_txt = sprintf('triangle open %i onset at %f', t, vbl);
                if const.tracker; Eyelink('message','%s',log_txt); end
            elseif nbf == triang_open_offset_nbf
                log_txt = sprintf('triangle open %i offset at %f', t, vbl);
                if const.tracker; Eyelink('message','%s',log_txt); end
            end
        elseif task == 3
            if nbf == triang_part_onset_nbf
                trial_on = vbl;
                log_txt = sprintf('triangle part open %i onset at %f', t, vbl);
                if const.tracker; Eyelink('message','%s',log_txt); end
            elseif nbf == triang_part_offset_nbf
                log_txt = sprintf('triangle part open %i offset at %f', t, vbl);
                if const.tracker; Eyelink('message','%s',log_txt); end
            end
        elseif task == 4
            if nbf == triang_closed_onset_nbf
                trial_on = vbl;
                log_txt = sprintf('triangle closed %i onset at %f', t, vbl);
                if const.tracker; Eyelink('message','%s',log_txt); end
            elseif nbf == triang_closed_offset_nbf
                log_txt = sprintf('triangle closed %i offset at %f', t, vbl);
                if const.tracker; Eyelink('message','%s',log_txt); end
            end
        end
    end
    expDes.expMat(t, 1) = trial_on;
    expDes.expMat(t, 2) = vbl - trial_on;
end

% Write in log/edf
if const.tracker
    Eyelink('message', '%s', sprintf('trial %i ended\n', t));
end
