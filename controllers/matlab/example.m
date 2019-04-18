close all;
clear all;
clc;
%
%  Copyright 2008 LocUS Project.
%  Written by:  Daniel Filipe Albuquerque.
%  $Revision: 1.0$    $Date: 2008/03/17 20:40$
%
%% STAGE ONE
%
% In this stage we only define the room to simulate and place
% the sources inside it. At the end of this stage we save all the
% data for next stage. We only need to do this once.
%
% This example considers a room with four walls, one floor and one ceil.
% The reflection coefficient for the walls is 0.7, for the ceil is 0.8 and
% for the floor is 0.5. 
%
% To add a wall to the simulator we use the function addWall. In the first 
% call we use this function like that:
AW = addWall(   [], [0 0 0], [0 0 3], [5 0 3], [5 0 0], 0.7);
%|              |      |________|________|________|       |
% This is the   Use this     |                            This is the 
% array of      only on      This is the coordinates      reflection
% surfaces      first call   of the vertices of the wall  coefficient
%
% We add the other tree walls:
AW = addWall(AW, [0 0 0], [0 0 3], [0 5 3], [0 5 0], 0.7);
%                 |
%                 Note: if is not the first call you must give to the
%                 function the array that you want to add the surface (AW
%                 in this case)
AW = addWall(AW, [5 0 0], [5 0 3], [5 5 3], [5 5 0], 0.7);
AW = addWall(AW, [0 5 0], [0 5 3], [5 5 3], [5 5 0], 0.7);
AW = addWall(AW, [0 1 0], [0 1 1], [1 1 1], [1 1 0], 0.7);

% We add the floor and ceil with the respective reflection coefficients
AW = addWall(AW, [0 0 3], [5 0 3], [5 5 3], [0 5 3], 0.8);
AW = addWall(AW, [0 0 0], [5 0 0], [5 5 0], [0 5 0], 0.5);


% Hear we define the beam function of the sources. we consider that it is
% equal for all the sources, but o can define a different beam function for
% each source
%
% It must be a function of type [h,p] = func(theta,phi,fs,fL,fH); where h is
% the impulse response of the wall and p the position of the first impulse
% response sample; theta is the azimuth; phi is the elevation, fs  is the
% sampling frequency and fL and fH are the lower and upper frequency bounds
% for band optimization
%
hb = @KemoL10_TF; % This is the beam function of a speaker that we use in
% our LAB 

% To add a source to the simulator we use the function addSource. In the
% first call we use this function like that:
AS = addSource(     [], [0.1 0.1 2.9]          , hb, [5 5 -3]);
% |                 |           |                |    |_|_|  
% This is the       Use this    The coordinates  |        |        
% array of          only on     of the source    |        propagation direction
% sources           irst call                    | 
%                                                transfer function
%
AS = addSource(AS, [4.9 0.1 2.9], hb, [-1 1 0]);
%               |
%               Note, if is not the first call you must give to the
%               function the array what you want to add the source.
% AS = addSource(AS, [3 0.1 1], hb, [-1 1 0]);

%
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


%% DISPLAY THE ROOM
%
% You can view in 3D the room, the real sources, and all the virtual
% sources with reflection coefficient up to maxR, for that you can use the
% function displayRoom:
displayRoom('testfile','HideVS');
%                        |
%                        This option hide the virtual sources


%% STAGE 2

% To add a receiver to the simulator we use the function addReceiver. 
% It is only possible to add just one receiver.
R = addReceiver([1 2.9 0.1]);
% This is for an omnidirectional receiver for directional receivers is similar 
% to the addSource example (above)

C = USChannel(); % Create an ultrasonic chanell with typical characteristics
% Default:
% T = 22�C; P = 1 atm; H = 50%; 

C.T = 25;  % temperatura �C
C.H = 30;  % humidade %
C.P = 1.01;% pressure atm

I = impR('testfile', R, C); % Compute the impulse response for each source
% The impulse reponses are obtained in the order that the sources were
% added

N = length(I);
t = (0:N-1)/fs;

figure
plot(1000*t,abs(I))
ylabel('Amplitude')
xlabel('Time (ms)')
legend('Source 1','Source 2')