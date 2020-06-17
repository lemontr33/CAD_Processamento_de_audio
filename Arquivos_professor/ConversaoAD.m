clear
close all 

s=0;
while s~=1 & s~=2
    s=input('Gravar audio(1) ou carregar arquivo(2)? ');
end

if s==1
    TxAmost=16000; %Hz
    Bits_Amostra=16;
    Tempo_Gravacao=5; %segundos
    disp(['Taxa de amostragem =  ',num2str(TxAmost),' Hz'])
    disp(['Bits/amostra =  ',num2str(Bits_Amostra)])
    disp(['Tempo de gravacao = ',num2str(Tempo_Gravacao),' segundos'])
        
    
    recObj = audiorecorder(TxAmost,Bits_Amostra,1);

%Common sample rates are 8000, 11025, 22050, 44100, 48000, and 96000 Hz.
%The number of bits must be 8, 16, or 24. The number of channels must
% be 1 or 2 (mono or stereo).

    disp('Comece a falar')
    recordblocking(recObj, Tempo_Gravacao);
    disp('Fim da gravacao.');

    disp('Reproducao do audio gravado')
    play(recObj);
    pause(Tempo_Gravacao)
    
    y = getaudiodata(recObj);
    
    s=input('Deseja armazenar o arquivo gerado? [s/n] ','s');
    
    if s=='s'
        %save voz.mat y TxAmost Bits_Amostra Tempo_Gravacao
        %save nota_Lah4_violao.mat y TxAmost Bits_Amostra Tempo_Gravacao
    end
    

else
    load voz.mat
    %load nota_Lah4_violao.mat
    
    disp(['Taxa de amostragem =  ',num2str(TxAmost),' Hz'])
    disp(['Bits/amostra =  ',num2str(Bits_Amostra)])
    disp(['Tempo de gravacao = ',num2str(Tempo_Gravacao),' segundos'])
    
    disp('Reproducao do audio gravado')
    player = audioplayer(y,TxAmost);
    play(player);
    pause(Tempo_Gravacao)
end

disp('Gerando figuras ...')

%% Gráfico do sinal no tempo
figure(1)
t=0:1/TxAmost:(length(y)-1)/TxAmost;
plot(t,y);
xlabel('t (seg)')
ylabel('Amplitude')
title('Amostras do Sinal')


%% Espectro de amplitudes do sinal
Y=fft(y);%,2^ceil(log2(length(y))));

f=0:TxAmost/length(Y):TxAmost/2;
f=f(1:end-1);

figure(2)
plot(f,abs(Y(1:floor(length(Y)/2))))
xlabel('f (Hz)')
ylabel('Amplitude')
title('Espectro do Sinal')
hold on


%% Passando o sinal por um filtro passa-baixas
fc=1000; %freq. de corte
Wn=fc/(TxAmost/2);
[b,a] = butter(8,Wn);
[H,W] = freqz(b,a,length(f));
k=sqrt(sum(abs(Y(1:floor(length(Y)/2))).^2)/sum(abs(H).^2));
plot(f,k*abs(H),'r')
hold off

y_filt=filter(b,a,y); %realiza a filtragem


Y_filt=fft(y_filt);
figure(3)
plot(f,abs(Y_filt(1:floor(length(Y_filt)/2))))
title('Espectro do Sinal Após o filtro ')
xlabel('f (Hz)')
ylabel('Amplitude')



disp('Reproduzindo o audio filtrado')
player = audioplayer(y_filt,TxAmost);
play(player);




