% Define the source folders and the destination folder
sourceFolders = { ...
    '../ProgressStatus', ...
    '../SentenceDatabase', ...
    '../SentencesFromExternalUsers', ...
    '../Template_folder', ...
    
    
};
destinationFolder = '../DO_NOT_DELETE_BY_MISTAKE';

% Loop through each source folder
for k = 1:length(sourceFolders)
    % Get a list of all files in the current source folder
    files = dir(fullfile(sourceFolders{k}, '*.*')); % Adjust the file pattern if needed

    % Copy each file to the destination folder
    for i = 1:length(files)
        % Skip directories ('.' and '..')
        if ~files(i).isdir
            % Define the source and destination file paths
            sourceFile = fullfile(sourceFolders{k}, files(i).name);
            destinationFile = fullfile(destinationFolder, files(i).name);

            % Copy the file
            copyfile(sourceFile, destinationFile);
        end
    end
end

disp('Files have been copied successfully.');
