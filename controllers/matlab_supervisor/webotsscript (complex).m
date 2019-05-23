
%% Initialization 
clc 
clear all
% Initialize the positions of the beacons
pos_Beacon1=[28 0 28];
pos_Beacon2=[28 0 -25];
pos_Beacon3=[-26 0 -27];
% Initialize the position of the robot
pos_Robot=[24 0 -26];
% Initialize the transmitted power[dbm]
transmittedPower = 77;
% Initialize the workspace
reload_Judgment = 0; % Set the judgment of reloading the world to 0,otherwise the world will be reloaded.
filename = 'Initialization.mat';
save(filename);
mode_Choice = 0;
fid = fopen('mode_Choice.txt','wt');
fprintf(fid,'%g\n',mode_Choice);  
%% Run Simulation
% Set the running steps
running_Time = 500;
% Set the workspace
mode_Choice = 3; %choose the webots at running mode 
fid = fopen('mode_Choice.txt','wt');
fprintf(fid,'%g\n',mode_Choice); 
fid = fopen('running_Time.txt','wt');
fprintf(fid,'%g\n',running_Time); 
%% Generate RIR
RIR_Input=importdata('RIR_Input.txt');
[t,I] = RIR(RIR_Input(1),RIR_Input(2),RIR_Input(3),[RIR_Input(4) RIR_Input(5) RIR_Input(6)],[RIR_Input(7) RIR_Input(8) RIR_Input(9)],[RIR_Input(10) RIR_Input(11) RIR_Input(12)],[RIR_Input(13) RIR_Input(14) RIR_Input(15)],RIR_Input(16),RIR_Input(17),RIR_Input(18),RIR_Input(19),RIR_Input(20),RIR_Input(21));
plot(1000*t,abs(I))% draw the RIR 
ylabel('Amplitude')
xlabel('Time (ms)')
legend('Source 1','Source 2','Source 3')
%% Display the corresponding room model
displayRoom('testfile','HideVS');
%% Show the sensor info  
data=importdata('sensorInfo.txt');
X = sprintf('maximal range is %f,received power is %f[dBm], frequency is %.3f[Hz],power consumption is %.3f[dB]',data(1),data(2),data(3),data(4));
disp(X);
%% Calculation the exploration
set(gcf,'outerposition',get(0,'screensize'));
imag_SLAM = '/home/huanghe/catkin_ws/src/my_map_normal.pgm'; % change your own location of the saved "my_map.pgm"
imag_Reference = 'my_map_normal.pgm';
[count1,I1] = GetRgbHist(imag_SLAM);
[count2,I2] = GetRgbHist(imag_Reference);
value = imsimilar(count1,count2,2);
subplot(2,2,1);imshow(I1);title('SLAM Result');
subplot(2,2,2);hold on;imshow(I2);title('Reference');
subplot(2,1,2);
plot(count1);
hold on;
plot(count2,'r');
legend('SLAM Result','Reference');
str = sprintf('Exploration:%s %%',num2str(value));
title(str);
%% Stop the simulation for a while
mode_Choice = 2; %choose the webots as stop mode
% set the stop time(s)
stopTime = 5;
% set the workspace
filename = 'Initialization.mat';
save(filename);
fid = fopen('mode_Choice.txt','wt');
fprintf(fid,'%g\n',mode_Choice); 

%% Reload the world
clc 
clear all
% initialize the positions of the beacons
pos_Beacon1=[27 0 27];
pos_Beacon2=[27 0 -26];
pos_Beacon3=[-25 0 -25];
% initialize the position of the robot
pos_Robot=[0 0 0];
% set the transmitted power[dbm]
transmittedPower = 77;
reload_Judgment = 1;
filename = 'Initialization.mat';
save(filename)
mode_Choice=0; %choose the webots as reload mode
fid = fopen('reload_Record.txt','wt');
fprintf(fid,'%g\n',mode_Choice);  
% reload the world is finished
%% Display the current room model
displayRoom('testfile','HideVS');
