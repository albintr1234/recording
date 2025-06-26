clc
clear
close all

folders_path='..\Chopped_Audios\';
new_folder_path="..\VAD_ChoppedAudios\";

% folders_path="C:\Users\deepa\Desktop\MultiLanguageRecording\Hindi\Chopped_Audios\Audios_Timestamps";
% new_folder_path="C:\Users\deepa\Desktop\MultiLanguageRecording\Hindi\Chopped_Audios\new\";


% new_folder_path="..\Chopped_Audios\";

files=dir([folders_path '*.wav']);

for i=1:length(files)

    
        [y, Fs] = audioread([folders_path '\' files(i).name]);
        filename=split(files(i).name,".");
        filename=filename{1};
        textfile=textread(strcat(folders_path,'\',filename,".txt"),'%s','delimiter','\t');
        start=round(str2num(textfile{1})*Fs);
        if start==0
            start=1
        end
        stop=round(str2num(textfile{2})*Fs);
    
        audiowrite(strcat(new_folder_path,'\',filename,'.wav'),y(start:stop)/max(abs(y(start:stop))),Fs);
        disp(filename);
   




end
% for i=1:length(files)
%     [y, Fs] = audioread([files(i).folder '\' files(i).name]);
%    
%     filename=split(files(i).name,".");
%     filename=filename{1};
%     textfile=textread(strcat(timestampsaftervad,filename,".txt"),'%s','delimiter','\t');
%     start=round(str2num(textfile{1})*Fs);
%     stop=round(str2num(textfile{2})*Fs);
% 
%     audiowrite(strcat(audiopath,filename,'.wav'),y(start:stop)/max(abs(y(start:stop))),Fs);
%     disp(filename);
% 
% end


% [y, Fs] = audioread(AudioFile);
% p=textread(timestampsaftervad,'%s','delimiter','\t');
% 
% start=str2num(p{1})*Fs;
% stop=str2num(p{2})*Fs;
% 
% audiowrite("a1.wav",y(start:stop)/max(abs(y(start:stop))),Fs);






