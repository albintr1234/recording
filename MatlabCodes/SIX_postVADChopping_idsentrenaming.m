% Read the ID file
idFile = '../id_sent_everdaytwofolder/ids.txt';
fid = fopen(idFile, 'r');
ids = textscan(fid, '%s');
ids = ids{1};
fclose(fid);

% Read the sentences file
sentenceFile = '../id_sent_everdaytwofolder/sentences.txt';
fid = fopen(sentenceFile, 'r');
sentences = textscan(fid, '%s', 'Delimiter', '\n');
sentences = sentences{1};
fclose(fid);

% Check if both files have the same number of lines
if length(ids) ~= length(sentences)
    error('The number of IDs and sentences must be the same');
end

% Create text files for each ID with the corresponding sentence
for i = 1:length(ids)
    filename = sprintf('../Chopped_Audios_Sentences/%s.txt', ids{i});
    fid = fopen(filename, 'w');
    fprintf(fid, '%s\n', sentences{i});
    fclose(fid);
end

disp('Text files created successfully.');



xlsdata=readtable('../Metadata.xlsx');
for i1=1:height(xlsdata)
    datestring=getdatestring(xlsdata.Date(i1,:));
    speaker=xlsdata.Name{i1};
    mobile=xlsdata.PhoneNumber(i1);
    if ~isdir(['../PreVerification_FinalRecordingData/' datestring '/' speaker '_' num2str(mobile) '/'])
        reply=input(['Are you working on ' speaker ' with mobile no: ' num2str(mobile) ' dated ' datestring '(y/n)?'],"s");
        if reply=='y'
            DIR=['../PreVerification_FinalRecordingData/' datestring '/' speaker '_' num2str(mobile) '/'];
            wavDIR=['../VAD_ChoppedAudios/'];
            mkdir(DIR);
            for i = 1:length(ids)
                filename = sprintf([DIR '/%s.txt'], ids{i});
                wavfilename = sprintf([wavDIR '/%s.wav'], ids{i});
                if isempty(wavfilename)
                    error(['NO AUDIO FILE CORRESPONDING TO ' ids{i} '.txt IN ' wavDIR]);
                end
                targetwavfilename = sprintf([DIR '/%s.wav'], ids{i});
                % movefile(wavfilename,targetwavfilename);
                copyfile(wavfilename,targetwavfilename)
                fid = fopen(filename, 'w');
                fprintf(fid, '%s\n', sentences{i});
                fclose(fid);
            end

        else
            error('LOOKS LIKE YOUR FOLDER STRUCTURE IS NOT IN ORDER. PLEASE CONTACT PROGRAMMER.');
        end
    end
end