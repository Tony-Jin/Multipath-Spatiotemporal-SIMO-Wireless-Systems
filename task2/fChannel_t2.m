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

function [symbolsOut]=fChannel_t2(paths,symbolsIn,delay,beta,DOA,SNR,array)
signal_input = [];
len = length(paths);
for i = 1:len
    signal_input = [signal_input;symbolsIn(paths(i),:)];
end
[m,n] = size(signal_input);
maxdelay = max(delay);
newlength = n + maxdelay;
signal = zeros(m,newlength);

for s = 1:len
    signal(s,delay(s,1)+1:delay(s,1)+n) = signal_input(s,:);
end
signal_new = signal.*beta;
% for i = 1:len
%     signal_new(i,:) = signal(i,:).*beta(i);
% end

Psignal=rms(signal(1,:)).^2;
sigma2=Psignal*10^(-SNR/10);
% noise=sqrt(sigma2/2)*(randn(1,newlength)+1i*randn(1,newlength));
% end
noise =(2/(10^(SNR/10))) *((rand(1,newlength))+(rand(1,newlength))*j);
out = sum(signal_new)+noise;
% out = awgn(Out,SNR,'measured');
symbolsOut = out.';
end