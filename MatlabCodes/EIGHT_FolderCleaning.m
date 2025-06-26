% Define the paths of the five folders from which you want to remove all files
folders = { ...
    '../id_sent_everdaytwofolder',...
    '../gui_recording_outcomes_timestamps_audios',...
    '../Chopped_Audios', ...
    '../VAD_ChoppedAudios', ...
    '../Chopped_Audios_Sentences' ...
};

% Loop through each folder
for k = 1:length(folders)
    % Get the current folder path
    folderPath = folders{k};
    
    % Get a list of all files in the folder
    files = dir(fullfile(folderPath, '*.*'));
    
    % Loop through each file and delete it
    for i = 1:length(files)
        % Skip directories ('.' and '..')
        if ~files(i).isdir
            % Define the full file path
            filePath = fullfile(folderPath, files(i).name);
            
            % Delete the file
            delete(filePath);
        end
    end
end

disp('All files have been removed from the specified folders successfully.');
