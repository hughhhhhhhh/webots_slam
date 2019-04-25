function  literation(xa,ya,xb,yb,xc,yc,da,db,dc)
 a = 2*(xa-xc);
 b = 2*(ya-yc);
 c = dc*dc-da*da-yc*yc+ya*ya-xc*xc+xa*xa;
 d = 2*(xb-xc);
 e = 2*(yb-yc);
 f = dc*dc-db*db-yc*yc+yb*yb-xc*xc+xb*xb;
 y = (f-c*d/a)/(e-b*d/a);
 x = (c-b*y)/a;
positionx= x;   
positiony = y;
X = sprintf('the position is %d %d ',positionx,positiony);
disp(X)

end

