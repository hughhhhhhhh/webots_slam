
%% Initialization 
% initialize the positions of the beacons
clc 
clear all
reloadworld = 0;
pos1=[28 0 28];
pos2=[28 0 -25];
pos3=[-26 0 -27];
% initialize the position of the robot
pos_robot=[0 0 0];
% set the transmitted power[dbm]
transmittedpower = 77;
% set the workspace
filename = 'inputsdata.mat';
save(filename);
controldata=0;
fid = fopen('reload_record.txt','wt');
fprintf(fid,'%g\n',controldata);  
%% Run Simulation
% set the running steps
running_time = 500;
% set the workspace
controldata = 3;
fid = fopen('reload_record.txt','wt');
fprintf(fid,'%g\n',controldata); 
fid = fopen('running_time.txt','wt');
fprintf(fid,'%g\n',running_time); 
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
data=importdata('sensorinfo.txt');
X = sprintf('maximal range is %f,received power is %f[dBm], frequency is %.3f[Hz],power consumption is %.3f[dB]',data(1),data(2),data(3),data(4));
disp(X)
%% Calculation the exploration
set(gcf,'outerposition',get(0,'screensize'));
imag1 = '/home/huanghe/catkin_ws/src/navigation/my_map.pgm';
imag2 = 'my_map.pgm';
[count1,I1] = GetRgbHist(imag1);
[count2,I2] = GetRgbHist(imag2);
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
controldata = 2;
% set the stop time(s)
stoptime = 5;
% set the workspace
filename = 'inputsdata.mat';
save(filename);
fid = fopen('reload_record.txt','wt');
fprintf(fid,'%g\n',controldata); 

%% Reload the world
clc 
clear all
% initialize the positions of the beacons
pos1=[27 0 27];
pos2=[27 0 -26];
pos3=[-25 0 -25];
% initialize the position of the robot
pos_robot=[0 0 0];
% set the transmitted power[dbm]
transmittedpower = 77;
reloadworld = 1;
filename = 'inputsdata.mat';
save(filename)
controldata=0;
fid = fopen('reload_record.txt','wt');
fprintf(fid,'%g\n',controldata);  
% reload the world is finished
%% Display the current room model
displayRoom('testfile','HideVS');
