% Q1 --------------------------------------------------------------------------------------------------------------------------------------------

% inputs: 1 signal: (sample rate, bits per sample) = (4000, 8), (8000, 8), (4000, 16) e (8000, 16), time = 5 (s)

Fs = 8000; % Sampling frequency

n = 16; % bit encoding

Chs = 1; % input channels

% IDin = -1; % always change to the current system input 

IDout = -1; % always change to the current system output

recobj = audiorecorder(Fs, n, Chs); % create recording object

pause(1);

disp('Start speaking.');

recordblocking(recobj, 5); % record for 5s

disp('End of Recording.');

pause(1);

y = getaudiodata(recobj); % y is a double array (values from -1 to 1) with 'Chs' columns

% player = audioplayer(y, Fs, n, IDout); play(player) % Play audio


% Q2 --------------------------------------------------------------------------------------------------------------------------------------------

% Nao eh feita no matlab

% Q3 --------------------------------------------------------------------------------------------------------------------------------------------

% inputs: 1 signal: (sample rate, bits per sample) = (8000, 16) and LPF with cutoff frequencies: 3500, 2000, 1000, 500 (Hz)

filterspecs = fdesign.lowpass('N,Fc', 50, 500, Fs);  % LPF specs, see which are applicable

% disp(designmethods(filterspecs))  % To verify which design method is possible given the specs

filterobj = design(filterspecs,'window');

yF = filter(filterobj, y); % filtering the audio


% Q4 --------------------------------------------------------------------------------------------------------------------------------------------

% inputs: 1 signal: (sample rate, bits per sample) = (8000, 16) and histogram spec

% histogram spec: histogram for the signal samples, 1st sample: instant of voice recording (dismiss the silent samples)


for k = 1:1:length(y)

	if abs(y(k)) > 0.01 % almost random choose

		break;

	else continue;

	end

end

hst = histogram(y(k:end), 2^(n/2 - 1),'Normalization','probability');


% Q5 --------------------------------------------------------------------------------------------------------------------------------------------

% inputs: 1 signal: (sample rate, bits per sample) = (8000, 24)  and quantization: 5 bits per sample

% uniform quantization of a signal using L quantization levels

function [q_out, Delta, SQNR] = uniquan(sig_in, L)

	sig_pmax = max(sig_in);

	sig_nmax = min(sig_in);

	Delta = (sig_pmax - sig_nmax)/L;

	q_level = (sig_nmax + Delta/2):Delta:(sig_pmax - Delta/2);

	L_sig = length(sig_in);

	sigp = (sig_in - sig_nmax)/Delta + 1/2;

 	qindex = round(sigp);

	qindex = min(qindex, L);

	q_out = q_level(qindex)';

	SQNR = 20*log10(norm(sig_in)/norm(sig_in - q_out));

end

L = 32; % n here is different from the n above (L = 2^n)

[yQ, Delta, SNR] = uniquan(y, L);


% Q6 --------------------------------------------------------------------------------------------------------------------------------------------

% inputs: 2 signals: (sample rate, bits per sample) = (8000, 24) and (20000, 24)

% Use Delta from Q5

% implementation of delta modulation, given a step size Delta (important!!!!)

function s_DMout = deltamod(sig_in, Delta, td, ts)

	s_DMout =  NaN*zeros(1, length(sig_in));

	if (rem(ts/td, 1) == 0) 

		nfac = round(ts/td);

		p_zoh = ones(1 , nfac); 

		s_down = downsample(sig_in, nfac); 

		Num_it = length(s_down);

		s_DMout(1) = -Delta/2; 

		for k = 2:Num_it
			
			xvar = s_DMout(k - 1);

			s_DMout(k) = xvar + Delta*sign(s_down(k - 1) - xvar);

		end
	
	s_DMout = kron(s_DMout, p_zoh)';

	else 

		warning('Error! ts/td is not an integer!');

		s_DMout = []';

	end

end

ts = 1/Fs;

td = 1/length(y);

Deltadm = Delta;

yDM = deltamod(y, Delta, td, ts);


