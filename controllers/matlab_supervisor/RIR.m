function [t,I] = RIR(movingRobot_positionx,movingRobot_positiony,movingRobot_positionz,movableObstacle_positionx,movableObstacle_positiony,movableObstacle_positionz,movableObstacle_rotation,beacon1_positionx,beacon1_positiony,beacon2_positionx,beacon2_positiony,beacon3_positionx,beacon3_positiony)
    %The input of the function of RIR
    % RIR_Input(1)~ RIR_Input(3): The position [x y z] of moving robot
    % RIR_Input(4)~ RIR_Input(12): The position [x y z] of four corners of the movable obstacle
    % RIR_Input(13)~ RIR_Input(15): The rotation [rx, ry, rz, α] of the movable obstacle
    % RIR_Input(16)~ RIR_Input(21): The position [x y] of 3 movable beacons
%% STAGE ONE
%
% In this stage we only define the room to simulate and place
% the sources inside it. At the end of this stage we save all the
% data for next stage. We only need to do this once.
%
% Here is a room with four walls, one floor and one ceil.
% The reflection coefficient for the walls is 0.7, for the ceil is 0.8 and
% for the floor is 0.5. 
%
% To add a wall to the simulator we use the function addWall. In the first 
% call we use this function like that:
AW = addWall(   [], [-30 -30 0], [-30 -30 2.5], [30 -30 2.5], [30 -30 0], 0.7);
%|              |      |________|________|________|       |
% This is the   Use this     |                            This is the 
% array of      only on      This is the coordinates      reflection
% surfaces      first call   of the vertices of the wall  coefficient
%
% We add the other tree walls:
AW = addWall(AW, [-30 -30 0], [-30 -30 2.5], [-30 30 2.5], [-30 30 0], 0.7);
%                 |
%                 Note: if is not the first call you must give to the
%                 function the array that you want to add the surface (AW
%                 in this case)
AW = addWall(AW, [30 -30 0], [30 -30 2.5], [30 30 2.5], [30 30 0], 0.7);
AW = addWall(AW, [-30 30 0], [-30 30 2.5], [30 30 2.5], [30 30 0], 0.7);

% We add the floor and ceil with the respective reflection coefficients
% ceil
AW = addWall(AW, [-30 -30 2.5], [30 -30 2.5], [30 30 2.5], [-30 30 2.5], 0.8);
% floor
AW = addWall(AW, [-30 -30 0], [30 -30 0], [30 30 0], [-30 30 0], 0.8);
%  AW = addWall(AW, [-1 0.36 0], [0 0.36 0], [0 0.36 0.28], [-1 0.36 0.28],0.5);

% add two obstacle walls
AW = addWall(AW, [30 -20 0], [30 -20 2.5], [7.4 -20 2.5], [7.4 -20 0],0.5);
AW = addWall(AW, [-30 0 0], [-30 0 2.5], [-7.4 0 2.5], [-7.4 0 0],0.5);

% add the movable obstacle
% [movableObstacle_positionx,movableObstacle_positiony,movableObstacle_positionz,movableObstacle_rotation] = obstaclePosition(p,s,teta)

 AW = addWall(AW, movableObstacle_positionx,movableObstacle_positiony, movableObstacle_positionz, movableObstacle_rotation,0.5);




% here we define the beam function of the sources. 
% It must be a function of type [h,p] = func(theta,phi,fs,fL,fH); where h is
% the impulse response of the wall and p the position of the first impulse
% response sample; theta is the azimuth; phi is the elevation, fs  is the
% sampling frequency and fL and fH are the lower and upper frequency bounds
% for band optimization
%
hb = @KemoL10_TF; % This is the beam function of a speaker that we use

% To add a source to the simulator we use the function addSource. In the
% first call we use this function like that:
AS = addSource(     [], [beacon1_positionx beacon1_positiony 0]          , hb, [-beacon1_positionx/abs(beacon1_positionx) -beacon1_positiony/abs(beacon1_positiony) 0]);
% |                 |           |                |    |_|_|  
% This is the       Use this    The coordinates  |        |        
% array of          only on     of the source    |        propagation direction
% sources           irst call                    | 
%                                                transfer function
%
AS = addSource(AS, [beacon2_positionx beacon2_positiony 0], hb, [-beacon2_positionx/abs(beacon2_positionx) -beacon2_positiony/abs(beacon2_positiony) 0]);
%               |
%               Note, if is not the first call you must give to the
%               function the array what you want to add the source.
% AS = addSource(AS, [3 0.1 1], hb, [-1 1 0]);

AS = addSource(AS, [beacon3_positionx beacon3_positiony 0], hb, [-beacon3_positionx/abs(beacon3_positionx) -beacon3_positiony/abs(beacon3_positiony) 0]);

% we define that the maximum reflection coefficient that the simulator
% takes into account - MR.
MR = 4; % 
fs = 192e3; % sampling frequency (>= 4xfh)
fl = 100;  % lower frequency bound
fh = 60e3; % upper frequency bound (<=80 kHz due to @KemoL10_TF)

% Now, for finish the stage one, it is necessary to create the file. In
% this example we call the file "testfile". And for this we use the
% function:

makeFile('testfile', AW, AS, MR, fs, fl, fh);
%

%% STAGE two

% To add a receiver to the simulator we use the function addReceiver. 
% It is only possible to add just one receiver.
R = addReceiver([movingRobot_positionx movingRobot_positiony movingRobot_positionz]);
% This is for an omnidirectional receiver for directional receivers is similar 
% to the addSource example (above)

C = USChannel(); % Create an ultrasonic chanell with typical characteristics
% Default:
% T = 22 C; P = 1 atm; H = 50%; 

C.T = 25;  % temperatura C
C.H = 30;  % humidade %
C.P = 1.01;% pressure atm

I = impR('testfile', R, C); % Compute the impulse response for each source
% The impulse reponses are obtained in the order that the sources were
% added
N = length(I);
t = (0:N-1)/fs;


end

