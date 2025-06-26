function [begintime endtime]=finddurationfromchoppedaudio(wavfile)
% % wavfile=[DIR wavfile];
% wavfile='C:\Users\deepa\Desktop\Deepak\recordings\varsha_20_06_24_f1_kannada_raw\kannada_english\06_06_24_varsha_dhare_f1_kannada_english\chopped_audio';
Th=20;
PAD=0.2;

sent_begin=-1;
sent_end=-1;

st_win=0.1;
st_shift=0.01;

[sig,fs]=audioread(wavfile);

N_win=round(st_win*fs);
N_shift=round(st_shift*fs);

st_energy=zeros(1,ceil((length(sig)-N_win-1)/N_shift));
count=1;
for n=1:N_shift:length(sig)-N_win-1
    temp=sig(n:n+N_win-1);
    st_energy(count)=sum(temp.^2);
    count=count+1;
end

inds=st_energy*0;
inds(find(st_energy>Th))=1;
diffinds=diff(inds);
inds_diffinds=find(abs(diffinds)==1);
ind1=inds_diffinds(1);
indend=inds_diffinds(end);
begintime=(ind1*st_shift)-PAD;if begintime<0; begintime=0;end
endtime=(indend*st_shift)+3*PAD;if endtime>length(sig)/fs; endtime=length(sig)/fs; end
% [begintime endtime]
% length(sig)/fs
subplot(211);plot([1:length(sig)]/fs,sig);hold on;
plot([begintime begintime],[-1 1],'r');plot([endtime endtime],[-1 1],'r');hold off;
subplot(212);plot([1:length(st_energy)]*st_shift,st_energy);
hold on;plot([1:length(st_energy)]*st_shift,Th*ones(1,length(st_energy)),'r');hold off;
ylim([0 100]);
% disp(wavfile);

reply=input('Is this timestamps fine (y/n)?','s');
if isempty(reply)
    reply='n';
end
if strcmp(reply,'y')
    disp(['automatic timestamps accepted ' num2str(begintime) ' ' num2str(endtime)])
else
    disp('click on graph to provide begin and end timestamps');
    [T,Y]=ginput(2);
    begintime=T(1);endtime=T(2);
    reply1=input('Do you want to proceed(y/n)?','s');
    if strcmp(reply1,'n')
        disp('click on graph to provide begin and end timestamps');
        [T,Y]=ginput(2);
        begintime=T(1);endtime=T(2);
    end
    disp(['manual timestamps accepted ' num2str(begintime) ' ' num2str(endtime)])
end