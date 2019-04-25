
%% Start the simulation
% initialize the positions of the beacons
clc 
clear all
reloadworld = 0;
pos1=[28 0 28];
pos2=[28 0 -25];
pos3=[-26 0 -27];
% initialize the position of the robot
pos_robot=[0 0 0];
% set the workspace
filename = 'inputsdata.mat';
save(filename);
controldata=0;
fid = fopen('reload_record.txt','wt');
fprintf(fid,'%g\n',controldata);  
%% Stop the simulation for a while
% stop the simulation 
controldata = 2;
% set the stop time(s)
stoptime = 5;
% set the workspace
filename = 'inputsdata.mat';
save(filename);
fid = fopen('reload_record.txt','wt');
fprintf(fid,'%g\n',controldata); 
%% stage 3
% display the room model
displayRoom('testfile','HideVS');
%% stage 4
% Reload the world
clc 
clear all
pos1=[27 0 27];
pos2=[27 0 -26];
pos3=[-25 0 -25];
pos_robot=[0 0 0];
reloadworld = 1;
filename = 'inputsdata.mat';
save(filename)
% reload the world is finished
%% SECTION TITLE
% DESCRIPTIVE TEXT
displayRoom('testfile','HideVS');
