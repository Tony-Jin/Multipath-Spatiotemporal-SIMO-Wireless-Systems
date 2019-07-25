%The main codes for task 4
%Run the code directly, the result will shown in commande window direclty
%Open the function file "interface_task4.m" and run it
%The interface will shown whihc has same function as this file but it will
%show the estimation of parameters clearly.
clear all;close all;clc;
load('jj4218.mat');
[m,n] = size(Xmatrix);
D1 = [1;0;0;1;0;1];
D2 = [1;0;1;1;1;1];
mseq1=fMSeqGen(D1);
mseq2=fMSeqGen(D2);
[GoldSeq]=fGoldSeq(mseq1,mseq2,phase_shift);
Nc = length(GoldSeq);
co=0.5/sin(frad(36));
array = [];
for i=1:5
	gamma=frad(30+72*(i-1));
    array=[array;co*cos(gamma),co*sin(gamma),0 ];
end
%estimation
[delay_estimate, DOA_estimate] = fChannelEstimation_t4(Xmatrix,GoldSeq,array);
%spatiotemporal beamformers
J = [zeros(2*Nc-1,1)' 0; eye(2*Nc-1) zeros(2*Nc-1,1)];
c = [GoldSeq;zeros(Nc,1)];
S1 = spv(array,DOA_estimate(1,:));
S2 = spv(array,DOA_estimate(2,:));
S3 = spv(array,DOA_estimate(3,:));
Jc1 = J^delay_estimate(1)*c;
Jc2 = J^delay_estimate(2)*c;
Jc3 = J^delay_estimate(3)*c;
h1 = kron(S1,Jc1);
h2 = kron(S2,Jc2);
h3 = kron(S3,Jc3);
H = [h1,h2,h3];
w = H*Beta_1;
coe1 = 2*Nc*1;
for i=1:m
    temp=reshape(Xmatrix(i,:),[Nc,n/Nc]);
    expand_s=kron(temp,ones(1,2));
    X(coe1*(i-1)+1:coe1*i,:)=reshape(expand_s(:,2:end-1),[coe1,(n-Nc)/Nc]);
end
signal = w'*X;
%demodulator
[bitsout]=Demodulator(signal.',GoldSeq,phi_mod);
Q = length(bitsout);
bit = reshape(bitsout,[8,60]);
ASC = bi2de(bit','left-msb');
message = char(ASC);
disp(message');