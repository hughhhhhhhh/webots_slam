
function  Trilateration(beacon1_position_x,beacon1_position_y,beacon2_position_x,beacon2_position_y,beacon3_position_x,beacon3_position_y,beacon1_measurement,beacon2_measurement,beacon3_measurement)
% This function is used to calculate the position of the moving robot by
% using the  Trilateration algorithm
% beacon1_position_x beacon1_position_x are the position from the first beacaon
% beacon1_measurement is the distance it measures
 a = 2*(beacon1_position_x-beacon3_position_x);
 b = 2*(beacon1_position_y-beacon3_position_y);
 c = beacon3_measurement*beacon3_measurement-beacon1_measurement*beacon1_measurement-beacon3_position_y*beacon3_position_y+beacon1_position_y*beacon1_position_y-beacon3_position_x*beacon3_position_x+beacon1_position_x*beacon1_position_x;
 d = 2*(beacon2_position_x-beacon3_position_x);
 e = 2*(beacon2_position_y-beacon3_position_y);
 f = beacon3_measurement*beacon3_measurement-beacon2_measurement*beacon2_measurement-beacon3_position_y*beacon3_position_y+beacon2_position_y*beacon2_position_y-beacon3_position_x*beacon3_position_x+beacon2_position_x*beacon2_position_x;
 y = (f-c*d/a)/(e-b*d/a);
 x = (c-b*y)/a;
robot_position_x= x;   
robot_position_y = y;
X = sprintf('The moving robot position is %.3f %.3f ',robot_position_x,-robot_position_y);
disp(X)

end

