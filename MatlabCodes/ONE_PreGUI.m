    ProgressStatusFile='../ProgressStatus/progress.mat';
    MetadataXLSFile='../Metadata.xlsx';
    ID_Sent_DIR='../id_sent_everdaytwofolder/';

    
    NumberOfSentences = 100;

    all=dir(ProgressStatusFile);
    if isempty(all)
        progress_array={};
        save(ProgressStatusFile,'progress_array');
    end

    load(ProgressStatusFile);
    total=0;
    for i=1:length(progress_array)

        progress=progress_array{i};
        counter=progress.count;
        if counter==-1
            error('Please complete recording using GUI.. There is ID and sentences which are yet to be recorded');
        end
        total=total+counter;

    end
    xlsdata=readtable(MetadataXLSFile);
    %%%%
    flag=0;alldatespkrs=[];
    for i1=1:height(xlsdata)
        datestring=getdatestring(xlsdata.Date(i1,:)); if isempty(datestring); disp('Date in metadata empty');end
        speaker=xlsdata.Name{i1};if isempty(speaker); disp('Name in metadata empty');end
        mobile=xlsdata.PhoneNumber(i1);if isempty(mobile); disp('Phone Number in metadata empty');end
        if ~isdir(['../FinalRecordingData/' datestring '/' speaker '_' num2str(mobile) '/'])
            flag=1;
        end
        alldatespkrs{i1}=['../FinalRecordingData/' datestring '/' speaker '_' num2str(mobile) '/'];
    end
    %%%%
    if length(alldatespkrs)~=length(unique(alldatespkrs))
        error('LOOKS LIKE MULTIPLE ROWS IN Metadata.xlsx HAVE SAME DATE, SPEAKER NAME AND PHONE COMBINATIONS! NOT EXPECTED');
    end
    if flag
        gender=xlsdata.Gender{end};if isempty(gender); disp('Gender in metadata empty');end

        load('../SentenceDatabase/Database.mat');%DBstruct_array
        fid_id=fopen([ID_Sent_DIR 'ids.txt'],'w');
        fid_sent=fopen([ID_Sent_DIR 'sentences.txt'],'w');
        for i=1:NumberOfSentences
            %i
            id=DBstruct_array{total+i}.ID;
            sent=DBstruct_array{total+i}.Sent{1};
            fprintf(fid_id,'%s\n',id);
            fprintf(fid_sent,'%s\n',sent);
            % pause

        end
        fclose(fid_id);
        fclose(fid_sent);

        progress=struct;
        progress.count=-1;
        progress.gender=gender;
        progress_array{length(progress_array)+1}=progress;
        save(ProgressStatusFile,'progress_array');
    else
        error('PLEASE CHECK Metadata.xlsx. RECORDING FOR ALL ENTRIES ARE OVER AND THE RECORDINGS ARE ALREADY IN FinalRecordingData FOLDER! SO NOTHING TO RECORD NOW.')
    end
 
    