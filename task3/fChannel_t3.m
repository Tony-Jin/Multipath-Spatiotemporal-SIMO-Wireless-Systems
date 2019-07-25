% NAME, GROUP (EE4/MSc), 2010, Imperial College.
% DATE

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Models the channel effects in the system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% paths (Mx1 Integers) = Number of paths for each source in the system.
% For example, if 3 sources with 1, 3 and 2 paths respectively then
% paths=[1;3;2]
% symbolsIn (MxR Complex) = Signals being transmitted in the channel
% delay (Cx1 Integers) = Delay for each path in the system starting with
% source 1
% beta (Cx1 Integers) = Fading Coefficient for each path in the system
% starting with source 1
% DOA = Direction of Arrival for each source in the system in the form
% [Azimuth, Elevation]
% SNR = Signal to Noise Ratio in dB
% array = Array locations in half unit wavelength. If no array then should
% be [0,0,0]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% symbolsOut (FxN Complex) = F channel symbol chips received from each antenna
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [symbolsOut]=fChannel_t3(paths,symbolsIn,delay,beta,DOA,SNR,array)
[m,n] = size(symbolsIn);
adddelay = 15;
newlength = n + adddelay;
signal = zeros(m,newlength);

len1 = length(delay);
for s = 1:len1
    signal(s,delay(s,1)+1:delay(s,1)+n) = symbolsIn(s,:);
%     S = spv(array,DOA(s,:));
%     signal(s,:) = signal(s,:)*S;
end
S = spv(array,DOA);
% signal = S*signal;
signal_new = signal.*beta;
message = S*signal_new;
% out_m = awgn(message,SNR,'measured');
% Psignal=rms(signal(1,:)).^2;
% sigma2=Psignal*10^(-SNR/10);
% noise=sqrt(sigma2/2)*(randn(1,newlength)+1i*randn(1,newlength));
% end
[row,col] = size(message);
noise =(2/(10^(SNR/10))) *((rand(row,col))+(rand(row,col))*j);
% out = sum(out_m)+noise;
% out = awgn(Out,SNR,'measured');
symbolsOut = message+noise;
end