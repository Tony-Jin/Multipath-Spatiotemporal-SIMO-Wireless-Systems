% JINLI JIN, 2019, Imperial College.
% 07/01/2019

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Perform DS-QPSK Modulation on a vector of bits using a gold sequence
% with channel symbols set by a phase phi
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% bitsIn (Px1 Integers) = P bits of 1's and 0's to be modulated
% goldseq (Wx1 Integers) = W bits of 1's and 0's representing the gold
% sequence to be used in the modulation process
% phi (Integer) = Angle index in degrees of the QPSK constellation points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% symbolsOut (Rx1 Complex) = R channel symbol chips after DS-QPSK Modulation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [symbolsOut]=fDSQPSKModulator(bitsIn,goldseq,phi)
%QPSK bit
bit1 = sqrt(2)*(cos(phi*2*pi/360)+sin(phi*2*pi/360)*j); %00
bit2 = sqrt(2)*(-cos(phi*2*pi/360)+sin(phi*2*pi/360)*j); %01
bit3 = sqrt(2)*(-cos(phi*2*pi/360)-sin(phi*2*pi/360)*j); %11
bit4 = sqrt(2)*(cos(phi*2*pi/360)-sin(phi*2*pi/360)*j); %10
%modulate the input siganl
len = length(bitsIn);
QPSK_signal = zeros(len/2,1);
for i = 1:len/2
    if bitsIn(2*i-1) == 0 && bitsIn(2*i) == 0
        QPSK_signal(i) = bit1;
    end
    
    if bitsIn(2*i-1) == 0 && bitsIn(2*i) == 1
        QPSK_signal(i) = bit2;
    end
    
    if bitsIn(2*i-1) == 1 && bitsIn(2*i) == 1
        QPSK_signal(i) = bit3;
    end
    
    if bitsIn(2*i-1) == 1 && bitsIn(2*i) == 0
        QPSK_signal(i) = bit4;
    end
end
symbolsOut = [];
lenseq = length(goldseq);
num = len/2;
% signal = goldseq;

for ii = 1:num
    temp = goldseq.*QPSK_signal(ii);
    symbolsOut = [symbolsOut;temp];
end
end