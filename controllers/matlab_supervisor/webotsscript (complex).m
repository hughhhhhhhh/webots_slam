
%% Initialization 
    clc 
    clear all

% Initialize the positions of the beacons
    beacon1_position = [-28 0 29];   %[x,y,z]
    beacon2_position = [28 0 -28];
    beacon3_position = [-26 0 -27];

% Initialize the position and rotation of the robot
    robot_position = [24 0 -26];
    robot_rotation = [0 1 0 1.6];    % unit axis, (-inf, inf) angle
    %The rotation field defines an arbitrary rotation of the children's coordinate 
    %system with respect to the parent coordinate system. This field contains four
    %floating point values: rx, ry, rz and α. The first three numbers, rx ry rz, 
    %define a normalized vector giving the direction of the axis around which the 
    %rotation must be carried out. The fourth value, α, specifies the rotation angle 
    %around the axis in radians. When α is zero, no rotation is carried out. All the 
    %values of the rotation field can be positive or negative. Note however that the 
    %length of the 3D vector rx ry rz must be normalized (i.e. its length is 1.0), 
    %otherwise the outcome of the simulation is undefined.

% Initialize the transmitted power[dbm]
    transmittedPower = 77;

% Initialize the workspace
    reload = 0;     % If 'reload' is set to 1,the webots world will be reset.
    filename = 'Initialization.mat';
    save(filename);
%Set the webots simulation mode
    webots_simulationMode = 1;
    fid = fopen('webots_simulationMode.txt','wt');
    fprintf(fid,'%g\n',webots_simulationMode);  
%% Run Simulation
% Set the running steps
    running_Time = 500;
    
% Set the workspace
    webots_simulationMode = 3; 
    fid = fopen('webots_simulationMode.txt','wt');
    fprintf(fid,'%g\n',webots_simulationMode); 
    fid = fopen('running_Time.txt','wt');
    fprintf(fid,'%g\n',running_Time); 
%% Step 3 : Generate room impulse response (RIR)
%     To do later
%% Show the sensor info  
    data=importdata('sensorInfo.txt');
    X = sprintf('Maximal range is %f,received power is %f[dBm], frequency is %.3f[Hz],power consumption is %.3f[dB]',data(1),data(2),data(3),data(4));
    disp(X);
%% Calculation the exploration
%   To do later
%% Stop the simulation for a while
    webots_simulationMode = 2; %choose the webots as stop mode
    % set the stop time(s)
    stopTime = 5;
    % set the workspace
    filename = 'Initialization.mat';
    save(filename);
    fid = fopen('webots_simulationMode.txt','wt');
    fprintf(fid,'%g\n',webots_simulationMode); 

%% Reload the world   
    % you can set different initial positions of the beacons and robot here
        clc 
        clear all
    % Initialize the positions of the beacons
        beacon1_position = [-27 0 27];   %[x,y,z]
        beacon2_position = [27 0 -27];
        beacon3_position = [-27 0 -27];

    % Initialize the position and rotation of the robot
        robot_position = [25 0 -25];
        robot_rotation = [0 1 0 1.6];    % unit axis, (-inf, inf) angle

    % Initialize the transmitted power[dbm]
        transmittedPower = 77;

    % Initialize the workspace
        reload = 1;     % If 'reload' is set to 1,the webots world will be reset.
        filename = 'Initialization.mat';
        save(filename);
    %Set the webots simulation mode
        webots_simulationMode = 1;
        fid = fopen('webots_simulationMode.txt','wt');
        fprintf(fid,'%g\n',webots_simulationMode);  
    
