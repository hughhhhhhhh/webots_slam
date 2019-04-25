
function [pos1,pos2,pos3,pos4] = obstaclePosition(p,s,teta)

% [p1,p2,p3]=position;
% [w,h]=size;
pos1=[p(1)-s(1),p(2),0];
pos2=[p(1)-s(1),p(2),2*s(2)];
pos3=[p(1)+s(1),p(2),2*s(2)];
pos4=[p(1)+s(1),p(2),0];

degrees = (180 / pi) * teta -90;
T = [
    cosd(degrees), -sind(degrees);...
    sind(degrees), cosd(degrees)
];
a = T * [pos1(1)-p(1);pos1(2)-p(2)] + [p(1);p(2)];
pos1(1)= a(1); pos1(2)=a(2);
b =  T * [pos2(1)-p(1);pos2(2)-p(2)] + [p(1);p(2)];
pos2(1)= b(1); pos2(2)=b(2);
c =  T * [pos3(1)-p(1);pos3(2)-p(2)] + [p(1);p(2)];
pos3(1)= c(1); pos3(2)=c(2);
d =  T * [pos4(1)-p(1);pos4(2)-p(2)] + [p(1);p(2)];
pos4(1)= d(1); pos4(2)=d(2);


end

