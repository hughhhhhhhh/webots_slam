function [count,I] = GetRgbHist(filename)
%GetRgbHist---get the Color histogram 
%filename-----the name of the file
%count--------the color histogram

info = imfinfo(filename);
I = imread(filename);
[N1,N2] = size(I);
if info.BitDepth == 24 
    [count1,x] = imhist(I(:,:,1));  
    [count2,x] = imhist(I(:,:,2)); 
    [count3,x] = imhist(I(:,:,3));  
    count = [count1,count2,count3]; 
    count = reshape(count,256*3,1);
else
    count = imhist(I);
end

count = count/(N1*N2);  
end

