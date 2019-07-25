function [bitsOut]=Demodulator(symbolsIn,GoldSeq,phi)
len = length(GoldSeq);
signal = symbolsIn;
[m,n] = size(signal);

for b = 1:m
%     signal(b,1) = (1/len)*sum(signal1(1+len*(b-1):len+len*(b-1),1).*GoldSeq);
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

for i = 1:m
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