% JINLI JIN, 2019, Imperial College.
% 07/01/2019

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Perform demodulation of the received data using <INSERT TYPE OF RECEIVER>
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% symbolsIn (Fx1 Integers) = R channel symbol chips received
% goldseq (Wx1 Integers) = W bits of 1's and 0's representing the gold
% sequence of the desired signal to be used in the demodulation process
% phi (Integer) = Angle index in degrees of the QPSK constellation points
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% bitsOut (Px1 Integers) = P demodulated bits of 1's and 0's
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [bitsOut]=fDSQPSKDemodulator(symbolsIn,GoldSeq,phi,delay_estimate)
signal1 = symbolsIn(delay_estimate+1:(delay_estimate+1800000),1);
[m,n] = size(signal1);
%find the x and y value in the QPSK
for b = 1:(m/15)
    signal(b,1) = 1/15*sum(signal1(1+15*(b-1):15+15*(b-1),1).*GoldSeq);
    re(b,1) = real(signal(b,1));
    im(b,1) = imag(signal(b,1));
end
%00
standard(1,1) = sqrt(2)*cos(phi*2*pi/360); 
standard(1,2) = sqrt(2)*sin(phi*2*pi/360);
%01   
standard(2,1) = -sqrt(2)*cos(phi*2*pi/360); 
standard(2,2) = sqrt(2)*sin(phi*2*pi/360);
%11  
standard(3,1) = -sqrt(2)*cos(phi*2*pi/360);
standard(3,2) = -sqrt(2)*sin(phi*2*pi/360);
%10   
standard(4,1) = sqrt(2)*cos(phi*2*pi/360); 
standard(4,2) = -sqrt(2)*sin(phi*2*pi/360);
%find the most similar bits from QPSK
for i = 1:(m/15)
     dis(1,1) = sqrt((re(i,1)-standard(1,1))^2+(im(i,1)-standard(1,2))^2); %distance to 00
     dis(1,2) = sqrt((re(i,1)-standard(2,1))^2+(im(i,1)-standard(2,2))^2); %distance to 01
     dis(1,3) = sqrt((re(i,1)-standard(3,1))^2+(im(i,1)-standard(3,2))^2); %distance to 11
     dis(1,4) = sqrt((re(i,1)-standard(4,1))^2+(im(i,1)-standard(4,2))^2); %distance to 10

    [value, index] = min(dis);
    if index == 1
        bitsOut(2*i-1,1) = 0;
        bitsOut(2*i,1) = 0;
    end
    if index == 2 
        bitsOut(2*i-1,1) = 0;
        bitsOut(2*i,1) = 1;
    end
    if index == 3 
        bitsOut(2*i-1,1) = 1;
        bitsOut(2*i,1) = 1;
    end
    if index == 4 
        bitsOut(2*i-1,1) = 1;
        bitsOut(2*i,1) = 0;
    end

end
end