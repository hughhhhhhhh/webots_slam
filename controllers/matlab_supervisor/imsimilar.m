function value = imsimilar( count1,count2,type)
%imsimilar---calculate the similarity
%count1------ֱthe first color histogram
%count2------ֱthe second histogram
%value------the similarity value
% 
% 1, input image
% 
% 2, grayscale
% 
% 3, normalize image size
% 
% 4, simplify the grayscale to reduce the amount of calculation, for example, all grayscales divided by 5
% 
% 5, calculate the average gray value average
% 
% 6. Compare the average value of the average gray value. If it is large, it is recorded as 1 and the small value is recorded as 0.
% 
% 7. Compare the fingerprints of the two images and calculate the similarity.

N1 = length(count1);
N2 = length(count2);

if N1~=N2
    fprintf('N1<>N2');
    value = 0;
    return ;
end


result = 0;
if type==1
for x = 1:N1
    den = max(count1(x),count2(x));
    if den == 0 
        den = 1;
    end
    result = result+(1-abs(count1(x)-count2(x))/den);   
end
    value = 100*result/N1;
else
    for x = 1:N1
       result = result+min(count1(x),count2(x)); 
    end
    value = result*100;
end
end

