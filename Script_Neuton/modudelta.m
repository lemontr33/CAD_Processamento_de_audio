function DM_sig=modudelta(sig_in,delta)

%   [q_out, Delta, SNR]=deltamod(sig_in,b)
%   sig_in  -  Sinal de entrada
%   delta - variação

%   Function ouputs:
%            DM_sig   -   sinal modulado por delta
%   A freq do modulador delta é a mesma do sinal de entrada

sig_in=transpose(sig_in);

tam_int = length(sig_in);% tamanho do meu sinal

for k = 1 : (tam_int-1)% vetor derivada, para o calculo do delta
    
    V_deriv(k) = ( sig_in(k+1) - sig_in(k) );
    
end


DM_sig(1) = -delta/2;


for k = 2 : tam_int
    
    if DM_sig(k-1) <= sig_in(k)% se maior ou igual ao anterior, soma
        DM_sig(k) = DM_sig(k-1) + delta;
        
    else % se menor, subtrai
        DM_sig(k) = DM_sig(k-1) - delta;
        
    end
    
end

DM_sig = transpose(DM_sig);


end

