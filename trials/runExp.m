function const = runExp(scr, const, expDes, my_key, eyetrack, aud)
% ----------------------------------------------------------------------
% const = runExp(scr, const, expDes, my_key, eyetrack)
% ----------------------------------------------------------------------
% Goal of the function :
% Launch experiement instructions and connection with eyetracking.
% ----------------------------------------------------------------------
% Input(s) :
% scr : struct containing screen configurations
% const : struct containing constant configurations
% expDes : struct containg experimental design
% my_key : structure containing keyboard configurations
% eyetrack : structure containing eyetracking configurations
% aud : structure containing audio configurations
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------

% Configuration of videos
if const.mkVideo
    const.vid_folder = sprintf('others/movie/%s_v1-%i_v2-%i_r1-%i_r2-%i', ...
        const.task, expDes.oneV, expDes.oneR);
    if ~isfolder(const.vid_folder); mkdir(const.vid_folder); end
    const.movie_image_file = sprintf('%s/img', const.vid_folder);
    const.movie_file = sprintf('%s.mp4', const.vid_folder);
    expDes.vid_num = 0;
    const.vid_obj = VideoWriter(const.movie_file, 'MPEG-4');
    const.vid_obj.FrameRate = 60;
	const.vid_obj.Quality = 100;
end

% Special instruction for scanner
scanTxt = '';
if const.scanner && ~const.scannerTest
    scanTxt = '_Scanner';
end

% Save all config at start of the block
config.scr  = scr;
config.const = const;
config.expDes = expDes;
config.my_key = my_key;
config.eyetrack = eyetrack;
config.aud = aud;
save(const.mat_file,'config');

% First mouse config
if const.expStart
    HideCursor;
    for keyb = 1:size(my_key.keyboard_idx,2)
        KbQueueFlush(my_key.keyboard_idx(keyb));
    end
end

% Initial calibrations
if const.tracker
    fprintf(1,'\n\tCalibration instructions - press space or right1-\n');
    eyeLinkClearScreen(eyetrack.bgCol);
    eyeLinkDrawText(scr.x_mid, scr.y_mid, eyetrack.txtCol,...
        'CALIBRATION INSTRUCTION - PRESS SPACE');
    instructionsIm(scr, const, my_key, ...
        sprintf('Calibration%s', scanTxt), 0);
    calibresult = EyelinkDoTrackerSetup(eyetrack);
    if calibresult == eyetrack.TERMINATE_KEY
        return
    end
end

for keyb = 1:size(my_key.keyboard_idx, 2)
    KbQueueFlush(my_key.keyboard_idx(keyb));
end

% Start eyetracking
record = 0;
while ~record
    if const.tracker
        if ~record
            Eyelink('startrecording');
            key = 1;
            while key ~=  0
                key = EyelinkGetKey(eyetrack);
            end
            error = Eyelink('checkrecording');
            if error==0
                record = 1;
                Eyelink('message', 'RECORD_START');
                Eyelink('command', ...
                    sprintf('record_status_message ''RUN %i''',...
                    const.runNum));
            else
                record = 0;
                Eyelink('message', 'RECORD_FAILURE');
            end
        end
    else
        record = 1;
    end
end

% Task instructions 
fprintf(1,'\n\tTask instructions -press space or right1 button-');
if const.tracker
    eyeLinkClearScreen(eyetrack.bgCol);
    eyeLinkDrawText(scr.x_mid, scr.y_mid, eyetrack.txtCol, ...
        'TASK INSTRUCTIONS - PRESS SPACE')
end
instructionsIm(scr, const, my_key, ...
    sprintf('Task_%s', num2str(expDes.expMat(1, 5))), 0);
for keyb = 1:size(my_key.keyboard_idx, 2)
    KbQueueFlush(my_key.keyboard_idx(keyb));
end
fprintf(1,'\n\n\tBUTTON PRESSED BY SUBJECT\n');

% Write on eyetracking screen
if const.tracker
    drawTrialInfoEL(scr, const)
end


% Main trial loop
for trial = 1:const.nb_trials
    expDes.trial = trial;
    expDes = runTrials(scr, const, expDes, my_key, aud);
end

%tsv file
head_txt = {'onset', 'duration', 'run_number', 'trial_number', ...
    'task'};  

for head_num = 1:length(head_txt)
    behav_txt_head{head_num} = head_txt{head_num};
    behav_mat_res{head_num} = expDes.expMat(:,head_num);
end

% Write header
head_line = [];
for tab = 1:size(behav_txt_head,2)
    if tab == size(behav_txt_head,2)
        head_line = [head_line, sprintf('%s', behav_txt_head{tab})];
    else
        head_line = [head_line, sprintf('%s\t', behav_txt_head{tab})];
    end
end
fprintf(const.behav_file_fid,'%s\n', head_line);

for trial = 1:const.nb_trials
    trial_line = [];
    for tab = 1:size(behav_mat_res, 2)
        if tab == size(behav_mat_res, 2)
            if isnan(behav_mat_res{tab}(trial))
                trial_line = [trial_line, sprintf('n/a')];
            else
                trial_line = [trial_line, sprintf('%1.10g', ...
                    behav_mat_res{tab}(trial))];
            end
        else
            if isnan(behav_mat_res{tab}(trial))
                trial_line = [trial_line, sprintf('n/a\t')];
            else
                trial_line = [trial_line, sprintf('%1.10g\t', ...
                    behav_mat_res{tab}(trial))];
            end
        end
    end
    fprintf(const.behav_file_fid,'%s\n',trial_line);
end

% End messages
instructionsIm(scr,const,my_key,'End',1);  %show end screen image

% Save all config at the end of the block (overwrite start made at start)
config.scr = scr; 
config.const = const; 
config.expDes = expDes;...
config.my_key = my_key;
config.eyetrack = eyetrack;
config.aud = aud;
save(const.mat_file,'config');

% Stop Eyetracking
if const.tracker
    Eyelink('command','clear_screen');
    Eyelink('command', 'record_status_message ''END''');
    WaitSecs(1);
    Eyelink('stoprecording');
    Eyelink('message', 'RECORD_STOP');
    eyeLinkClearScreen(eyetrack.bgCol);
    eyeLinkDrawText(scr.x_mid, scr.y_mid, eyetrack.txtCol,...
        'THE END - PRESS SPACE OR WAIT');
end

end