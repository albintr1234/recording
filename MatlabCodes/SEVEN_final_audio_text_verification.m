% Create a UI figure
fig = uifigure('Name', 'Text and Audio Player', 'Position', [100, 100, 800, 400]);


% Create a text area to display the content of the text file
txtArea = uitextarea(fig, 'Position', [50, 150, 500, 200]);
txtArea.Value = 'Text content will be displayed here.';
txtArea.FontSize = 50;

% Create buttons
btnBackward = uibutton(fig, 'push', 'Position', [100, 50, 100, 50], 'Text', 'Backward');
btnPlay = uibutton(fig, 'push', 'Position', [250, 50, 100, 50], 'Text', 'Play');
btnForward = uibutton(fig, 'push', 'Position', [400, 50, 100, 50], 'Text', 'Forward');
% btnSave = uibutton(fig, 'push', 'Position', [550, 50, 100, 50], 'Text', 'Save');


% Global variable to keep track of current file index
global currentIndex;
currentIndex = 1;
global flag;
flag = 0;

% Variable to store folder path and files info
global folderPath;
global textFiles;

% Select folder and initialize files
folderPath = uigetdir(pwd, 'Select Folder Containing Text and Audio Files');
if folderPath == 0
    return; % User canceled folder selection
end

textFiles = dir(fullfile(folderPath, '*.wav'));
if isempty(textFiles)
    errordlg('No text files found in the selected folder!', 'File Error');
    return;
end

% Display the first file
displayFile(txtArea);

% Set the button callbacks
btnBackward.ButtonPushedFcn = @(btn, event) navigateFiles(txtArea, -1);
btnForward.ButtonPushedFcn = @(btn, event) navigateFiles(txtArea, 1);
btnPlay.ButtonPushedFcn = @(btn, event) playAudio();
% btnSave.ButtonPushedFcn = @(btn, event) saveUpdatedFile(txtArea);


% Function to navigate files
function navigateFiles(txtArea, direction)
    global currentIndex;
    global folderPath;
    global textFiles;
    global flag;

    
    if flag == 0
        % Read current text content
        updatedText = txtArea.Value;
        
        % Get current file name
        [~, fileName, ext] = fileparts(textFiles(currentIndex).name);
        
        % Append '_update' to the file name
        updatedFileName = [fileName, '_update.txt'];
        
        % Write updated text to file
        updatedFilePath = fullfile(folderPath, updatedFileName);
        fileID = fopen(updatedFilePath, 'w');
        fwrite(fileID, updatedText{1,1}, 'char');
        fclose(fileID);   
        %%%%
        xlsdata=readtable('../Metadata.xlsx');
        for i1=1:height(xlsdata)
            datestring=getdatestring(xlsdata.Date(i1,:));
            speaker=xlsdata.Name{i1};
            mobile=xlsdata.PhoneNumber(i1);
            if ~isdir(['../FinalRecordingData/' datestring '/' speaker '_' num2str(mobile) '/'])
                mkdir(['../FinalRecordingData/' datestring '/' speaker '_' num2str(mobile) '/']);
            end
        end
        updatedFilePath = fullfile(['../FinalRecordingData/' datestring '/' speaker '_' num2str(mobile) '/'], updatedFileName);
        fileID = fopen(updatedFilePath, 'w');
        fwrite(fileID, updatedText{1,1}, 'char');
        fclose(fileID);
        srcDIR=['../PreVerification_FinalRecordingData/' datestring '/' speaker '_' num2str(mobile) '/'];
        destDIR=['../FinalRecordingData/' datestring '/' speaker '_' num2str(mobile) '/'];
        sourcewavfilename=[srcDIR fileName '.wav'];
        destinationwavfilename=[destDIR fileName '.wav'];
        % movefile(sourcewavfilename,destinationwavfilename);
        copyfile(sourcewavfilename,destinationwavfilename);
        %%%%
        

        sourceFolders = { ...
    '../id_sent_everdaytwofolder',...
    '../gui_recording_outcomes_timestamps_audios',...
    '../Chopped_Audios', ...
    '../VAD_ChoppedAudios', ...
    '../Chopped_Audios_Sentences' ...
};
       destinationFolders = { ...
           ['../FinalRecordingData/' datestring '/' speaker '_' num2str(mobile) '/' 'id_sent_everdaytwofolder'], ... 
           ['../FinalRecordingData/' datestring '/' speaker '_' num2str(mobile) '/' 'gui_recording_outcomes_timestamps_audios'], ...
           ['../FinalRecordingData/' datestring '/' speaker '_' num2str(mobile) '/' 'Chopped_Audios'], ...
           ['../FinalRecordingData/' datestring '/' speaker '_' num2str(mobile) '/' 'VAD_ChoppedAudios'], ...
           ['../FinalRecordingData/' datestring '/' speaker '_' num2str(mobile) '/' 'Chopped_Audios_Sentences'] ...
   
};
    
      % Loop through each source folder
for k = 1:length(sourceFolders)
    % Define the current destination folder
    currentDestinationFolder = destinationFolders{k};
    
    % Create the destination folder if it does not exist
    if ~exist(currentDestinationFolder, 'dir')
        mkdir(currentDestinationFolder);
    end

    % Get a list of all files in the current source folder
    files = dir(fullfile(sourceFolders{k}, '*.*')); % Adjust the file pattern if needed

    % Move each file to the corresponding destination folder
    for i = 1:length(files)
        % Skip directories ('.' and '..')
        if ~files(i).isdir
            % Define the source and destination file paths
            sourceFile = fullfile(sourceFolders{k}, files(i).name);
            destinationFile = fullfile(currentDestinationFolder, files(i).name);

            % Move the file
            movefile(sourceFile, destinationFile);
        end
    end
end

disp('Files have been moved successfully.');
        

    end

    % Wrap around if out of bounds
    if currentIndex < 1
%         currentIndex = length(textFiles);
          msgbox('cannot go back' );
          txtArea.Value = "";
          flag = 1;
    elseif currentIndex >= length(textFiles)
%         currentIndex = 1;
          msgbox('completed');
          txtArea.Value = "";
          flag = 1;
    else
        % Update current index
        currentIndex = currentIndex + direction

        displayFile(txtArea);       

    end
    
    % Display the current file
%     displayFile(txtArea);
end

% % Function to navigate files
% function navigateFiles_forward(txtArea)
%     global currentIndex;
%     global folderPath;
%     global textFiles;
%     global flag;
% 
%     
%     if flag == 0
%         % Read current text content
%         updatedText = txtArea.Value;
%         
%         % Get current file name
%         [~, fileName, ext] = fileparts(textFiles(currentIndex).name);
%         
%         % Append '_update' to the file name
%         updatedFileName = [fileName, '_update.txt'];
%         
%         % Write updated text to file
%         updatedFilePath = fullfile(folderPath, updatedFileName);
%         fileID = fopen(updatedFilePath, 'w');
%         fwrite(fileID, updatedText{1,1}, 'char');
%         fclose(fileID);   
% 
%     end
% 
%     % Wrap around if out of bounds
%     if currentIndex >= length(textFiles)
% %         currentIndex = 1;
%           msgbox('completed');
%           txtArea.Value = "";
%           flag = 1;
%     else
%         % Update current index
%         currentIndex = currentIndex + 1
% 
%         displayFile(txtArea);       
% 
%     end
%     
%     % Display the current file
% %     displayFile(txtArea);
% end
% 
% 
% % Function to navigate files
% function navigateFiles_back(txtArea)
%     global currentIndex;
%     global folderPath;
%     global textFiles;
%     global flag;
% 
%     
%     if flag == 0
%         % Read current text content
%         updatedText = txtArea.Value;
%         
%         % Get current file name
%         [~, fileName, ext] = fileparts(textFiles(currentIndex).name);
%         
%         % Append '_update' to the file name
%         updatedFileName = [fileName, '_update.txt'];
%         
%         % Write updated text to file
%         updatedFilePath = fullfile(folderPath, updatedFileName);
%         fileID = fopen(updatedFilePath, 'w');
%         fwrite(fileID, updatedText{1,1}, 'char');
%         fclose(fileID);   
% 
%     end
% 
%     % Wrap around if out of bounds
%     if currentIndex < 1
% %         currentIndex = length(textFiles);
%           msgbox('cannot go back' );
%           txtArea.Value = "";
%           flag = 1;
%     else
%         % Update current index
%         currentIndex = currentIndex - 1
% 
%         displayFile(txtArea);       
% 
%     end
%     
%     % Display the current file
% %     displayFile(txtArea);
% end


% Function to display text file
function displayFile(txtArea)
    global currentIndex;
    global folderPath;
    global textFiles;
    
    % Read text file
    textFilePath = fullfile(folderPath, [textFiles(currentIndex).name(1:end-3) 'txt']);
    fileID = fopen(textFilePath, 'r');
    textContent = fread(fileID, '*char')';
    fclose(fileID);
    
    % Display text content
    txtArea.Value = textContent;
end

% Function to play audio
function playAudio()
    global currentIndex;
    global folderPath;
    global textFiles;
    
    % Play corresponding audio file
    [~, fileName, ~] = fileparts(textFiles(currentIndex).name);
    audioFilePath = fullfile(folderPath, [fileName, '.wav']);
    
    if exist(audioFilePath, 'file')
        [y, Fs] = audioread(audioFilePath);
        sound(y, Fs);
    else
        errordlg(['Audio file ', fileName, '.wav not found!'], 'File Error');
    end
end

% Function to save updated text file
% function saveUpdatedFile(txtArea)
%     global currentIndex;
%     global folderPath;
%     global textFiles;
%     
%     % Read current text content
%     updatedText = txtArea.Value;
%     
%     % Get current file name
%     [~, fileName, ext] = fileparts(textFiles(currentIndex).name);
%     
%     % Append '_update' to the file name
%     updatedFileName = [fileName, '_update', ext];
%     
%     % Write updated text to file
%     updatedFilePath = fullfile(folderPath, updatedFileName);
%     fileID = fopen(updatedFilePath, 'w');
%     fwrite(fileID, updatedText{1,1}, 'char');
%     fclose(fileID);
%     
    % Display success message
%     msgbox(['File saved as ', updatedFileName], 'File Saved');
% end
