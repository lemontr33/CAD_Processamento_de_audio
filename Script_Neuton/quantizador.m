
function [q_out, Delta, SNR]=quantizador(sig_in,b)

%   [q_out, Delta, SNR]=uniquan(sig_in,b)
%   b  -  Número de bits
%   sig_in  -  Sinal de entrada
%   Function ouputs:
%            q_out - saída quantizada
%            Delta - intervalo de quantização
%            SNR - razão sinal ruido

L = 2^b;% Cálcula o numero de níveis quantizados
sig_pmax=max(sig_in);% achar o máximo positivo

sig_nmax=min(sig_in);% achar o minimo negativo

Delta=(sig_pmax-sig_nmax)/L; % intervalo de quantização

q_level=sig_nmax+Delta/2:Delta:sig_pmax-Delta/2;% definir os níveis quantizados tamanho: L

L_sig=length(sig_in); % tamanho do meu sinal

sigp=(sig_in-sig_nmax)/Delta+1/2;% Localizar em qual nivel L meu sinal de entrada está
% L = 1 é a metade do primeiro nível quantizado

qindex=round(sigp); % joga para o inteiro mais proximo, no caso, o valor de L

qindex=min(qindex,L); % Algum L vai dar L+1, não permitido!

%Caso: sig_in = sig_pmax!!! L + 1/2 na função round vai para L+1!

q_out=q_level(qindex);% transforma as posições dos L em valores quantizados

q_out=transpose(q_out);% transpor a matriz

% Como os dois sons tem a mesma duração e a mesma banda:
%2 sons discrteos!! Razão sinal-ruído é a divisão do somatório dos valores
%ao quadrado

SNR=20*log10(norm(sig_in)/norm(sig_in-q_out));% razão sinal ruido

% norm = norma euclidiana
end