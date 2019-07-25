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

function [delay_estimate, DOA_estimate]=fChannelEstimation_t4(symbolsIn,goldseq,array)
[m,n] = size(symbolsIn);
Nc = length(goldseq);
coe1 = 2*Nc*1;
delay_estimate = zeros(3,1);
DOA_estimate = zeros(3,2);

for i=1:m
    temp=reshape(symbolsIn(i,:),[Nc,n/Nc]);
    expand_s=kron(temp,ones(1,2));
    X(coe1*(i-1)+1:coe1*i,:)=reshape(expand_s(:,2:end-1),[coe1,(n-Nc)/Nc]);
end
Rxx=X*X'./size(X,1);  

%STAR
J = [zeros(2*Nc-1,1)' 0; eye(2*Nc-1) zeros(2*Nc-1,1)];
c = [goldseq;zeros(Nc,1)];
[eigenvector,eigenvalue] = eig(Rxx);
en=eigenvector(:,1:size(eigenvector,1)-10);
Pn = en*inv(en'*en)*en';

star = zeros(Nc,180);

for i=1:Nc
    Jc = J^i*c;
    for j=0:180
        direction = [j 0];
        Sd = spv(array,direction);
        h = kron(Sd,Jc);
        star(i,j+1) = 1/(h'*Pn*h);
    end
end

star = abs(star);
% Z = 10*log(star);
surf(star);
%delay projection
for i = 1:length(goldseq)
    YZ(i) = max(star(i,:));
end
%DOA projection
for i = 1:181
    XZ(i) = max(star(:,i));
end
[value1,delay] = findpeaks(YZ,'minpeakheight',0.008);
delay_estimate = delay';
for i = 1:3
    [~,DOA] = find(star(delay(i),:)==value1(i));
    DOA_estimate(i,1) = DOA-1;
end

end