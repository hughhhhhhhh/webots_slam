% MATLAB controller for Webots
% File:          robotforRIR.m
% Date:          
% Description:   
% Author:        
% Modifications: 

% uncomment the next two lines if you want to use
% MATLAB's desktop to interact with the controller:
%desktop;
%keyboard;

TIME_STEP = 64;

% get and enable devices, e.g.:
%  camera = wb_robot_get_device('camera');
%  wb_camera_enable(camera, TIME_STEP);

% main loop:
% perform simulation steps of TIME_STEP milliseconds
% and leave the loop when Webots signals the termination
%


AW = addWall(   [], [0 0 0], [0 0 3], [5 0 3], [5 0 0], 0.7);
AW = addWall(AW, [0 0 0], [0 0 3], [0 5 3], [0 5 0], 0.7);
AW = addWall(AW, [5 0 0], [5 0 3], [5 5 3], [5 5 0], 0.7);
AW = addWall(AW, [0 5 0], [0 5 3], [5 5 3], [5 5 0], 0.7);
AW = addWall(AW, [0 1 0], [0 1 1], [1 1 1], [1 1 0], 0.7);
AW = addWall(AW, [0 0 3], [5 0 3], [5 5 3], [0 5 3], 0.8);
AW = addWall(AW, [0 0 0], [5 0 0], [5 5 0], [0 5 0], 0.5);
hb = @KemoL10_TF; % This is the beam function of a speaker that we use in
AS = addSource(     [], [0.1 0.1 2.9]          , hb, [5 5 -3]);
AS = addSource(AS, [4.9 0.1 2.9], hb, [-1 1 0]);
MR = 4; % 
fs1 = 192e3; % sampling frequency (>= 4xfh)
fl = 100;  % lower frequency bound
fh = 60e3; % upper frequency bound (<=80 kHz due to @KemoL10_TF)
makeFile('testfile', AW, AS, MR, fs1, fl, fh);
displayRoom('testfile','HideVS');
R = addReceiver([1 2.9 0.1]);
C = USChannel(); % Create an ultrasonic chanell with typical characteristics
C.T = 25;  % temperatura �C
C.H = 30;  % humidade %
C.P = 1.01;% pressure atm
I = impR('testfile', R, C); % Compute the impulse response for each source
N = length(I);
t = (0:N-1)/fs1;

plot(1000*t,abs(I))
ylabel('Amplitude')
xlabel('Time (ms)')
legend('Source 1','Source 2')
% while wb_robot_step(TIME_STEP) ~= -1







  % read the sensors, e.g.:
  %  rgb = wb_camera_get_image(camera);
  
  % Process here sensor data, images, etc.

  % send actuator commands, e.g.:
  %  wb_differential_wheels_set_speed(500, -500);
  
  % if your code plots some graphics, it needs to flushed like this:
  % drawnow;

% end

% cleanup code goes here: write data to files, etc.
