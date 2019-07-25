%Task 2 for ACT coureswork made by JINLI JIN
%Run this file, the output image will be shown
%if you want to change the value of SNR please go to line 44
%The function file "interface_task2.m" is the code for interface of task2
%Run the interface_task2.m, the interface will be shown, which can shown
%the result clearer and change the SNR value easier and the input images
%can be decided by users.
close all;clear all; clc;
%transform the image to binary signal
[signal1,x1,y1] = fImageSource('image1.jpg',100*100*3*8);
[signal2,x2,y2] = fImageSource('image8.jpg',100*100*3*8);
[signal3,x3,y3] = fImageSource('image7.jpg',100*100*3*8);
%generate m-sequence
D1 = [1;0;0;1;1];%1+D+D4 from c0 to c4
D2 = [1;1;0;0;1];%1+D3+D4 from c0 to c4
mseq1=fMSeqGen(D1);
mseq2=fMSeqGen(D2);
%find out the gold sequence
surname=10; 
firstname=10;
shift = 1+mod(surname+firstname,12);
[GoldSeq1]=fGoldSeq(mseq1,mseq2,shift);
%find out the balance sequence
balance = sum(GoldSeq1);
while (balance~=-1)
    shift = shift+1;
    [GoldSeq1]=fGoldSeq(mseq1,mseq2,shift);
    balance = sum(GoldSeq1);
end
[GoldSeq2]=fGoldSeq(mseq1,mseq2,shift+1);
[GoldSeq3]=fGoldSeq(mseq1,mseq2,shift+2);
%QPSK
phi = surname +  2*firstname;
signal1_input = fDSQPSKModulator(signal1,GoldSeq1,phi);
signal2_input = fDSQPSKModulator(signal2,GoldSeq2,phi);
signal3_input = fDSQPSKModulator(signal3,GoldSeq3,phi);
signal_input = [signal1_input signal2_input signal3_input];%180000*3
%transformation
de_c = surname + firstname;
paths = [1;1;1;2;3];
delay = [mod(de_c,4);4+mod(de_c,5);9+mod(de_c,6);8;13];
beta = [0.8;0.4*exp(-j*40*pi/180);0.8*exp(j*80*pi/180);0.5;0.2];
DOA = [30 0;45 0;20 0;90 0;150 0];
SNR = 40;
array = [];

[symbolsOut]=fChannel_t2(paths,signal_input.',delay,beta,DOA,SNR,array);
[delay_estimate1, DOA_estimate1, beta_estimate1] = fChannelEstimation_t2(symbolsOut, GoldSeq1);
[bitsout]=fDSQPSKDemodulator_t2(symbolsOut,GoldSeq1,phi,delay_estimate1);
%error judge
error = 0;
P = 100*100*8*3;
for i = 1:P-6
    if bitsout(i,1)~= signal1(i,1)
       error = error+1;
    end
end
Q = x1*y1*8*3;
fImageSink(bitsout,Q,x1,y1);


