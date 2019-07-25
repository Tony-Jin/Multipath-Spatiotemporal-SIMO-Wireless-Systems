% NAME, GROUP (EE4/MSc), 2010, Imperial College.
% DATE

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Performs channel estimation for the desired source using the received signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% symbolsIn (Fx1 Complex) = R channel symbol chips received
% goldseq (Wx1 Integers) = W bits of 1's and 0's representing the gold
% sequence of the desired source used in the modulation process
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% delay_estimate = Vector of estimates of the delays of each path of the
% desired signal
% DOA_estimate = Estimates of the azimuth and elevation of each path of the
% desired signal
% beta_estimate = Estimates of the fading coefficients of each path of the
% desired signal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [delay_estimate, DOA_estimate, beta_estimate]=fChannelEstimation_t2(symbolsIn,goldseq)
%delay estimation
len = length(goldseq);
for i=1:3000
    sample = symbolsIn(i:i+len-1,1);
    delay(i) = abs(sample'*goldseq);
end

[value,index]=sort(delay,'descend');
judge = mod(index,15)-1;
x = unique(judge);
for i = 1:length(x)
    [value2,index2]=find(judge(1:300)==x(i));
    num(i) = length(index2);
end

[value3,index3] = sort(num,'descend');
for ii = 1:3
    if x(index3(ii)) == -1
        delay_estimate(ii,1) = 14;
    else
        delay_estimate(ii,1) = x(index3(ii));
    end

DOA_estimate = 0;
beta_estimate = 0;
end