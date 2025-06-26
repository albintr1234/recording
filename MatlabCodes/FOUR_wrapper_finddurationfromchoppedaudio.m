clear all;clear all
% close all;

%DIR='C:\Users\pooja\OneDrive\Desktop\Day1_31_10_2022\Audios\Chopped_Audios\Day1_401_500\';
DIR='..\Chopped_Audios\';



all=dir([DIR '*.wav']);totdur=0;
for i=1:length(all)
    wavfile=all(i).name;
    disp(' ');
    disp(wavfile);
    [bgtime entime]=finddurationfromchoppedaudio([DIR wavfile]);
    totdur=totdur+entime-bgtime;
    

    fid=fopen([DIR wavfile(1:end-3) 'txt'],'w');
    fprintf(fid,'%.9f\t%.9f\n',bgtime,entime);
    fclose(fid);
    disp([wavfile(1:end-3) 'txt written'])


%     pause
end

disp(['Total duration: ' num2str(totdur)]);

%%%%%%%%%
all=dir([DIR '*.txt']);totdur=0;
for i=1:length(all)
    txtfile=all(i).name;
    xx=load([DIR txtfile]);
    totdur=totdur+xx(2)-xx(1);
end
disp(['Total duration: ' num2str(totdur/60)]);
