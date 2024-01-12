function const = dirSaveFile(const)
% ----------------------------------------------------------------------
% const = dirSaveFile(const)
% ----------------------------------------------------------------------
% Goal of the function :
% Make directory and saving files name and fid.
% ----------------------------------------------------------------------
% Input(s) :
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Output(s):
% const : struct containing constant configurations
% ----------------------------------------------------------------------
% Function created by Martin SZINTE (martin.szinte@gmail.com)
% ----------------------------------------------------------------------

% Create data directory 
if ~isfolder(sprintf('data/%s/%s/%s/', const.sjct, const.session, ...
        const.modality))
    mkdir(sprintf('data/%s/%s/%s/', const.sjct, const.session, ...
        const.modality))
end

% Define directory
const.dat_output_file = sprintf('data/%s/%s/%s/%s_%s_task-%s_%s',...
    const.sjct, const.session, const.modality, const.sjct, ...
    const.session, const.task, const.run);

% Define eye data filename
const.eyetrack_temp_file = 'XX.edf';
const.eyetrack_local_file = sprintf('%s_eyetrack.edf', ...
    const.dat_output_file);

% Define behavioral data filename
const.behav_file = sprintf('%s_events.tsv', const.dat_output_file);
if const.expStart
    if exist(const.behav_file,'file')
        aswErase = upper(strtrim(input(sprintf(...
            '\n\tSame data file exists, erase it ? (Y or N): '), 's')));
        if upper(aswErase) == 'N'
            error('Relaunch with correct input.')
        elseif upper(aswErase) == 'Y'
        else
            error('Incorrect input, relaunch with correct input.')
        end
    end
end
const.behav_file_fid = fopen(const.behav_file, 'w');

% Define .mat saving file
const.mat_file = sprintf('%s_matlab.mat', const.dat_output_file);

end