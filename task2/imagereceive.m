function image = imagereceive(bitsIn,Q,x,y)
recover_signal = bitsIn(1:Q,1);

for i = 1:Q/8
    piex = recover_signal((i-1)*8+1:8*i)';
    temp = num2str(piex);
    gray(i,1)=bin2dec(temp);
end

R = gray(1:10000,1);
G = gray(10001:20000,1);
B = gray(20001:30000,1);

image = uint8(permute(reshape(gray, 100, 100, 3), [1 2 3]));
end