% MATLAB controller for Webots
% File:          matlab_supervisor.initializationData
% Date:          2019.5.26
% Description:   This is the controller for the supervisor 
% Author:        He Huang  

% uncomment the next two lines if you want to use
% MATLAB's desktop to interact with the controller:
% desktop;
% keyboard;

TIME_STEP = 64;
TIME_STEPEPUCK=320;
M_PI=3.14159265358979323846;
% The room impulse response will be calculated after every 50 steps
counter = 50;
% samples = 0; % Used to show the position of the moving robotwb_console_print('Running Matlab sample Webots controller.', WB_STDOUT);
% distanceMeasurement is the distance that between 3 beacons and the moving robot 
global distanceMeasurement1;
global distanceMeasurement2;
global distanceMeasurement3;




% main loop:
% perform simulation steps of TIME_STEP milliseconds
% and leave the loop when Webots signals the termination
% get and enable receiver
emitter = wb_robot_get_device('emitter');
receiver = wb_robot_get_device('receiver');
receiver0 = wb_robot_get_device('receiver0');
receiver1 = wb_robot_get_device('receiver1');
receiver2 = wb_robot_get_device('receiver2');
wb_receiver_enable(receiver0, 64);
wb_receiver_enable(receiver1, 64);
wb_receiver_enable(receiver2, 64);
wb_receiver_enable(receiver, TIME_STEPEPUCK);


% get the translation and position of the robot
pioneer3at = wb_supervisor_node_get_from_def('PIONEER_3AT');
pioneer_transition = wb_supervisor_node_get_field(pioneer3at, 'translation');
pioneer_rotation = wb_supervisor_node_get_field(pioneer3at, 'rotation');
% rotat_field_epuck = wb_supervisor_node_get_field(pioneer3at,'rotation');

% get and enable radar
radar = wb_supervisor_node_get_from_def('MyBot3.Radar');
transmittedPower_field = wb_supervisor_node_get_field(radar, 'transmittedPower');
maxRange_field = wb_supervisor_node_get_field(radar, 'maxRange');
antennaGain_field = wb_supervisor_node_get_field(radar, 'antennaGain');
frequency_field = wb_supervisor_node_get_field(radar, 'frequency');
% get the antenna gain and frequency of the radar
antennaGain = wb_supervisor_field_get_sf_float(antennaGain_field);
frequency = wb_supervisor_field_get_sf_float(frequency_field);

%get and enable the yellow box position,size.The yellow box can be moved,
%and the corresponding RIR room model will be changed.
yellowboxsize = wb_supervisor_node_get_from_def('YELLOW_BOX.Shape.geometryBox');
yellowboxsize_field = wb_supervisor_node_get_field(yellowboxsize, 'size');
yellowBox = wb_supervisor_node_get_from_def('YELLOW_BOX');
trans_field_yellowbox = wb_supervisor_node_get_field(yellowBox, 'translation');
rotat_field_yellowbox = wb_supervisor_node_get_field(yellowBox, 'rotation');

% get position of 3 unmoving robots with radars
robot_node1 = wb_supervisor_node_get_from_def('MyBot1');
robot_node2 = wb_supervisor_node_get_from_def('MyBot2');
robot_node3 = wb_supervisor_node_get_from_def('MyBot3');
trans_field1 = wb_supervisor_node_get_field(robot_node1, 'translation');
trans_field2 = wb_supervisor_node_get_field(robot_node2, 'translation');
trans_field3 = wb_supervisor_node_get_field(robot_node3, 'translation');

% initialize the position of the beacons
filename = 'Initialization.mat';
initializationData = matfile(filename);
wb_supervisor_field_set_sf_vec3f(trans_field1, initializationData.beacon1_position);
wb_supervisor_field_set_sf_vec3f(trans_field2, initializationData.beacon2_position);
wb_supervisor_field_set_sf_vec3f(trans_field3, initializationData.beacon3_position);
wb_supervisor_field_set_sf_vec3f(pioneer_transition, initializationData.robot_position);
wb_supervisor_field_set_sf_rotation(pioneer_rotation, initializationData.robot_rotation);
% set the transmitted power 
wb_supervisor_field_set_sf_float(transmittedPower_field, initializationData.transmittedPower);

%read the data from matlabsscript
while wb_robot_step(TIME_STEP) ~= -1
      webots_simulationMode=importdata('webots_simulationMode.txt');
    if initializationData.reload == 1 && webots_simulationMode == 1
              a=1001;%set a random number that not equal to 1
              fid = fopen('webots_simulationMode.txt','wt');
              fprintf(fid,'%g\n',a);     
              fclose(fid);
               wb_console_print('the world is reload', WB_STDOUT);
                wb_supervisor_world_reload();
      elseif webots_simulationMode == 2
              a=1003;
              fid = fopen('webots_simulationMode.txt','wt');
              fprintf(fid,'%g\n',a);     
              fclose(fid);
               wb_console_print('the simulation is stopped', WB_STDOUT);
               wb_supervisor_simulation_set_mode(WB_SUPERVISOR_SIMULATION_MODE_PAUSE);
               wb_console_print('now it is stopped', WB_STDOUT);               
               pause(initializationData.stopTime);
              wb_supervisor_simulation_set_mode(WB_SUPERVISOR_SIMULATION_MODE_RUN);
               wb_console_print('now it is started', WB_STDOUT);

       elseif webots_simulationMode == 3
              running_Time=importdata('running_Time.txt');
              running_Time =  running_Time - 1;
              X=sprintf('running counter is =%f', running_Time);
              disp(X); 
              fid = fopen('running_Time.txt','wt');
              fprintf(fid,'%g\n',running_Time);     
              fclose(fid);
              if running_Time == 0
              a=1003;
              fid = fopen('webots_simulationMode.txt','wt');
              fprintf(fid,'%g\n',a);     
              fclose(fid);
               wb_console_print('the simulation is stopped', WB_STDOUT);
               wb_supervisor_simulation_set_mode(WB_SUPERVISOR_SIMULATION_MODE_PAUSE);
               end
        % else 
             % wb_console_print('no input number', WB_STDOUT);

     end
    

      % plot distance sensor values
      % subplot(2,2,4);
      % bar([1:8], sensor_values);
      % title('Distance sensors');
      % axis([1 8 0 2000]);
      % flush graphics
      % drawnow;
      %calculate the maximal Range of radar,which is based on the transmitted power that set before
      transmittedPower = wb_supervisor_field_get_sf_float(transmittedPower_field); 
      G = 10^(antennaGain/10);
      P = 0.001*10^(0.1*transmittedPower);
      maxRange = P*(10^6)*(G^2)*(299792458^2)/((((10^9)*frequency)^2)*((4*M_PI)^3));
      maxRange =  maxRange^0.25;
      % Y=sprintf('maximal range is %f,transmitted power is %f[dBm] ',maxRange,transmittedPower);
      % disp(Y);
      wb_supervisor_field_set_sf_float(maxRange_field,maxRange);
      % //output the position of three unmoving robots
      unmovingRobot1_position = wb_supervisor_field_get_sf_vec3f(trans_field1);
      unmovingRobot2_position = wb_supervisor_field_get_sf_vec3f(trans_field2);
      unmovingRobot3_position = wb_supervisor_field_get_sf_vec3f(trans_field3);
      yellowbox_size =wb_supervisor_field_get_sf_vec3f(yellowboxsize_field);
      trans_yellowbox = wb_supervisor_field_get_sf_vec3f(trans_field_yellowbox);
      rotat_yellowbox = wb_supervisor_field_get_sf_rotation(rotat_field_yellowbox);
       rotation_pioneer3at = wb_supervisor_field_get_sf_rotation(pioneer_rotation);
     % /* send 3 doubles to matlab */
       currentPosition_pioneer3at = wb_supervisor_field_get_sf_vec3f(pioneer_transition);
      
      %save the data,which will be used later in the RIR function
      %the position of the moving robot
        data(1)=currentPosition_pioneer3at(1);
        data(2)=currentPosition_pioneer3at(2);
        data(3)=currentPosition_pioneer3at(3);
      %the position of the movable wall
        data(4)=trans_yellowbox(1);
        data(5)=-trans_yellowbox(3);
        data(6)=trans_yellowbox(2);
      %the size and rotation of the movable wall
        data(7)= 0.5*yellowbox_size(3);
        data(8)=0.5*yellowbox_size(2);
        data(9)=rotat_yellowbox(2)*rotat_yellowbox(4);
       %the position and rotation of the unmoving robots
        data(10)= unmovingRobot1_position(1); 
        data(11)= -unmovingRobot1_position(3);
        data(12)= unmovingRobot2_position(1);
        data(13)=- unmovingRobot2_position(3);
        data(14)= unmovingRobot3_position(1); 
        data(15)=  -unmovingRobot3_position(3);
        data(16)=  rotation_pioneer3at(4)* rotation_pioneer3at(2);
        wb_emitter_send(emitter, data);
      
      % receive the measurement from the first radar
        while wb_receiver_get_queue_length(receiver0) > 0  
             i=1;
             wb_receiver_set_channel(receiver0,i);
             message = wb_receiver_get_data(receiver0,'double');
             array(1)= message;  
             distanceMeasurement1 = array(1);
             wb_receiver_next_packet(receiver0);
             % wb_console_print('the radar 1 is working well', WB_STDOUT);
        end
        
      % receive the measurement from the second radar
        while wb_receiver_get_queue_length(receiver1) > 0  
             i=2;
             wb_receiver_set_channel(receiver1,i);
             message1 = wb_receiver_get_data(receiver1,'double');
             array(2) = message1;  
             distanceMeasurement2 =array(2); 
             wb_receiver_next_packet(receiver1);
             % wb_console_print('the radar 2 is working well', WB_STDOUT);
        end
        
      % receive the measurement from the third radar
    
        while wb_receiver_get_queue_length(receiver2) > 0 
             i=3;
             wb_receiver_set_channel(receiver2,i);
             message2 = wb_receiver_get_data(receiver2,'double');
             wb_receiver_next_packet(receiver2);
             array(3)= message2(1);
             distanceMeasurement3= array(3);
             array(4) = message2(2); 
             array(5) = message2(3);
             % wb_console_print('the radar 3 is working well', WB_STDOUT); 
             % now calculate the energy consumption,changen them from dBm into mW
             receivedpower3=0.001*(10^(0.1*array(4)));
             transmittedPower3=0.001*(10^(0.1*transmittedPower));
             delta = transmittedPower-receivedpower3;
             powerConsumption = 10*log(delta);
             % Z=sprintf(' maximal range is %f,received power is %f[dBm], frequency is %.3f[Hz],power consumption is %.3f[distanceMeasurement2]',maxRange,array(4),array(5),powerConsumption);
             % disp(Z);
             %save the data of radar and the matlabscript will read them
             fid = fopen('sensorInfo.txt','wt');
             fprintf(fid,'%g\n',maxRange,array(4),array(5),powerConsumption); 
             % Y=sprintf('%f %f %f', array(3), array(4),array(5));
             % disp(Y);
         end
         % calculate the RIR function after every 50 steps
         if (mod(counter,50)==0)
               %calculate the position of the corner of the moving wall
               [movableWall_cornerposition1,movableWall_cornerposition2,movableWall_cornerposition3,movableWall_cornerposition4] = obstaclePosition([data(4),data(5),data(6)],[data(7),data(8)],data(9));
               % [t,I] = RIR(data(1),data(3),0,movableWall_cornerposition1,movableWall_cornerposition2,movableWall_cornerposition3,movableWall_cornerposition4,data(10),data(11),data(12),data(13),data(14),data(15));
               RIR_Input = [data(1),data(3),0,movableWall_cornerposition1,movableWall_cornerposition2,movableWall_cornerposition3,movableWall_cornerposition4,data(10),data(11),data(12),data(13),data(14),data(15)];
               fid = fopen('RIR_Input.txt','wt');
               fprintf(fid,'%g\n',RIR_Input); 
         end   
        % draw the RIR and the trajectory of the robot
         counter = counter + 1;
         % subplot(2,1,1);
         % plot(1000*t,abs(I))% draw the RIR 
         % ylabel('Amplitude')
         % xlabel('Time (ms)')
         % title('RIR changes every 20 steps');
        % store position
        % samples = samples + 1;
        % p(samples,:) = currentPosition_pioneer3at;
        % plot latest trajectory segment
         % subplot(2,1,2);
        % if (samples > 100)
          % plot(p(samples-100:samples,1),-p(samples-100:samples,3));
        % else
          % plot(p(1:samples,1),-p(1:samples,3));
        % end
        % plot current robot position
        % hold on;
        % plot(p(samples,1),-p(samples,3),'ro');
        % axis([-30 30 -30 30]);
        % title('Trajectory (Supervisor)');
        % hold off;
        Y=sprintf('The distance to the moving robot are Measurement 1=%.3f Measurement 2=%.3f Measurement 3=%.3f', distanceMeasurement1,distanceMeasurement2,distanceMeasurement3);
        disp(Y); 
        %use trilateration function to calculate the position of the moving robot
        Trilateration(data(10),data(11),data(12),data(13),data(14),data(15), distanceMeasurement1,distanceMeasurement2,distanceMeasurement3);
        drawnow;
    
end

% cleanup code goes here: write data to files, etc.
