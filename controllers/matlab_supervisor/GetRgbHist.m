function [count,I] = GetRgbHist(filename)
%GetRgbHist---��ȡͼ��ֱ��ͼ
%filename-----ͼ���ļ�����ͼ�����·��
%count--------ͼ��ֱ��ͼ

info = imfinfo(filename);
I = imread(filename);
[N1,N2] = size(I);
%info.BitDepth=24ʱ�������RGBͼ�񣬷����ǻҶ�ͼ��
if info.BitDepth == 24 
    [count1,x] = imhist(I(:,:,1));  %����Rͨ����ֱ��ͼ
    [count2,x] = imhist(I(:,:,2));  %����Rͨ����ֱ��ͼ
    [count3,x] = imhist(I(:,:,3));  %����Rͨ����ֱ��ͼ
    %��������תΪһά��ֱ��ͼ
    count = [count1,count2,count3]; 
    count = reshape(count,256*3,1);
else
    count = imhist(I);
end

count = count/(N1*N2);  %��һ��������ͼ���������⡣
end

