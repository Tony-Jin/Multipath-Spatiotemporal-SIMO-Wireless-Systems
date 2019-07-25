% JINLI JIN, 2019, Imperial College.
% 07/01/2019

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reads an image file with AxB pixels and produces a column vector of bits
% of length Q=AxBx3x8 where 3 represents the R, G and B matrices used to
% represent the image and 8 represents an 8 bit integer. If P>Q then
% the vector is padded at the bottom with zeros.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Inputs
% filename (String) = The file name of the image
% P (Integer) = Number of bits to produce at the output - Should be greater
% than or equal to Q=AxBx3x8
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Outputs
% bitsOut (Px1 Integers) = P bits (1's and 0's) representing the image
% x (Integer) = Number of pixels in image in x dimension
% y (Integer) = Number of pixels in image in y dimension
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [bitsOut,x,y]=fImageSource(filename,P)
image=imread(filename);
[y,x,z] = size(image);
bitsOut=zeros(P,1);
%Seperate the image
r_im = reshape(image(:,:,1),x*y,1);
g_im = reshape(image(:,:,2),x*y,1);
b_im = reshape(image(:,:,3),x*y,1);
%transform the 2D signal to 1D
im = [r_im;g_im;b_im];
im2 = [];
for i = 1:x*y*z
    imb = dec2bin(im(i,1),8);
    temp_bit = str2num(imb');
    im2 = [im2;temp_bit];
end
bitsOut(1:x*y*z*8,1) = im2;
end