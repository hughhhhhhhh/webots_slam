% DESCRIPTIVE TEXT
% MATLAB controller for Webots
% File:          matlab_supervisor.m
% Date:          
% Description:   
% Author:        
% Modifications: 

% uncomment the next two lines if you want to use
% MATLAB's desktop to interact with the controller:
%desktop;
%keyboard;

TIME_STEP = 64;
TIME_STEPEPUCK=320;
M_PI=3.14159265358979323846;
counter = 50;
samples = 0;
wb_console_print('Running Matlab sample Webots controller.', WB_STDOUT);
global da;
global db;
global dc;
% DESCRIPTIVE TEXT


% get and enable devices, e.g.:
%  camera = wb_robot_get_device('camera');
%  wb_camera_enable(camera, TIME_STEP);

% main loop:
% perform simulation steps of TIME_STEP milliseconds
% and leave the loop when Webots signals the termination
%
emitter = wb_robot_get_device('emitter');
receiver = wb_robot_get_device('receiver');
wb_receiver_enable(receiver, TIME_STEPEPUCK);
epuck = wb_supervisor_node_get_from_def('PIONEER_3AT');
trans = wb_supervisor_node_get_field(epuck, 'translation');
node = wb_supervisor_node_get_from_def('MyBot3.Radar');
yellowboxsize = wb_supervisor_node_get_from_def('YELLOW_BOX.Shape.geometryBox');
yellowboxsize_field = wb_supervisor_node_get_field(yellowboxsize, 'size');
yellowBox = wb_supervisor_node_get_from_def('YELLOW_BOX');
transmittedPower_field = wb_supervisor_node_get_field(node, 'transmittedPower');
maxRange_field = wb_supervisor_node_get_field(node, 'maxRange');
antennaGain_field = wb_supervisor_node_get_field(node, 'antennaGain');
frequency_field = wb_supervisor_node_get_field(node, 'frequency');
antennaGain = wb_supervisor_field_get_sf_float(antennaGain_field);
frequency = wb_supervisor_field_get_sf_float(frequency_field);
receiver0 = wb_robot_get_device('receiver0');
receiver1 = wb_robot_get_device('receiver1');
receiver2 = wb_robot_get_device('receiver2');
wb_receiver_enable(receiver0, 64);
wb_receiver_enable(receiver1, 64);
wb_receiver_enable(receiver2, 64);
% get position of beacons
robot_node1 = wb_supervisor_node_get_from_def('MyBot1');
robot_node2 = wb_supervisor_node_get_from_def('MyBot2');
robot_node3 = wb_supervisor_node_get_from_def('MyBot3');
trans_field1 = wb_supervisor_node_get_field(robot_node1, 'translation');
trans_field2 = wb_supervisor_node_get_field(robot_node2, 'translation');
trans_field3 = wb_supervisor_node_get_field(robot_node3, 'translation');
trans_field_yellowbox = wb_supervisor_node_get_field(yellowBox, 'translation');
rotat_field_yellowbox = wb_supervisor_node_get_field(yellowBox, 'rotation');
rotat_field_epuck = wb_supervisor_node_get_field(epuck,'rotation');


% set the position of the beacons

filename = 'Initialization.mat';
m = matfile(filename);
wb_supervisor_field_set_sf_vec3f(trans_field1, m.pos_Beacon1);
wb_supervisor_field_set_sf_vec3f(trans_field2, m.pos_Beacon2);
wb_supervisor_field_set_sf_vec3f(trans_field3, m.pos_Beacon3);
wb_supervisor_field_set_sf_vec3f(trans, m.pos_Robot);
% set the transmitted power 
wb_supervisor_field_set_sf_float(transmittedPower_field, m.transmittedPower);

% DESCRIPTIVE TEXT

while wb_robot_step(TIME_STEP) ~= -1
      ex=importdata('reload_Record.txt');
    if m.reload_Judgment == 1 && ex == 0
              a=1001;
              fid = fopen('reload_Record.txt','wt');
              fprintf(fid,'%g\n',a);     
              fclose(fid);
               wb_console_print('the world is reload', WB_STDOUT);
                wb_supervisor_world_reload();
      elseif ex == 2
              a=1003;
              fid = fopen('reload_Record.txt','wt');
              fprintf(fid,'%g\n',a);     
              fclose(fid);
               wb_console_print('the simulation is stopped', WB_STDOUT);
               wb_supervisor_simulation_set_mode(WB_SUPERVISOR_SIMULATION_MODE_PAUSE);
               wb_console_print('now it is stopped', WB_STDOUT);               
               pause(m.stopTime);
              wb_supervisor_simulation_set_mode(WB_SUPERVISOR_SIMULATION_MODE_RUN);
               wb_console_print('now it is started', WB_STDOUT);

       elseif ex == 3
              running_Time=importdata('running_Time.txt');
              running_Time =  running_Time - 1;
              X=sprintf('running counter is =%f', running_Time);
              disp(X); 
              fid = fopen('running_Time.txt','wt');
              fprintf(fid,'%g\n',running_Time);     
              fclose(fid);
              if running_Time == 0
              a=1003;
              fid = fopen('reload_Record.txt','wt');
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

  transmittedPower = wb_supervisor_field_get_sf_float(transmittedPower_field); 
  G = 10^(antennaGain/10);
  P=0.001*10^(0.1*transmittedPower);
  maxRange = P*(10^6)*(G^2)*(299792458^2)/((((10^9)*frequency)^2)*((4*3.14159265358979)^3));
  maxRange =  maxRange^0.25;
  % Y=sprintf('maximal range is %f,transmitted power is %f[dBm] ',maxRange,transmittedPower);
  % disp(Y);
  wb_supervisor_field_set_sf_float(maxRange_field,maxRange);
    % //output the position of three robots
  trans1 = wb_supervisor_field_get_sf_vec3f(trans_field1);
  trans2 = wb_supervisor_field_get_sf_vec3f(trans_field2);
  trans3 = wb_supervisor_field_get_sf_vec3f(trans_field3);
  yellowbox_size =wb_supervisor_field_get_sf_vec3f(yellowboxsize_field);
  trans_yellowbox = wb_supervisor_field_get_sf_vec3f(trans_field_yellowbox);
  rotat_yellowbox = wb_supervisor_field_get_sf_rotation(rotat_field_yellowbox);
  rotat_epuck = wb_supervisor_field_get_sf_rotation(rotat_field_epuck);
 % /* send 3 doubles to matlab */
   pos = wb_supervisor_field_get_sf_vec3f(trans);
  
  
    data(1)=pos(1);
    data(2)=pos(2);
    data(3)=pos(3);
    data(4)=trans_yellowbox(1);
    data(5)=-trans_yellowbox(3);
    data(6)=trans_yellowbox(2);
    data(7)= 0.5*yellowbox_size(3);
    data(8)=0.5*yellowbox_size(2);
    data(9)=rotat_yellowbox(2)*rotat_yellowbox(4);
    data(10)= trans1(1); 
    data(11)= -trans1(3);
    data(12)= trans2(1);
    data(13)=- trans2(3);
    data(14)= trans3(1); 
    data(15)=  -trans3(3);
    data(16)=  rotat_epuck(4)* rotat_epuck(2);
    wb_emitter_send(emitter, data);
  
  
    while wb_receiver_get_queue_length(receiver0) > 0  
     i=1;
     wb_receiver_set_channel(receiver0,i);
     message = wb_receiver_get_data(receiver0,'double');
      array(1)= message;  
     da = array(1);
    wb_receiver_next_packet(receiver0);
     % wb_console_print('1allesgut', WB_STDOUT);

    end
    
    
    while wb_receiver_get_queue_length(receiver1) > 0  
    i=2;
     wb_receiver_set_channel(receiver1,i);
     message1 = wb_receiver_get_data(receiver1,'double');
      array(2) = message1;  
      db =array(2); 
    wb_receiver_next_packet(receiver1);
      % wb_console_print('2allesgut', WB_STDOUT);

    end
    
    
    while wb_receiver_get_queue_length(receiver2) > 0 

     i=3;
     wb_receiver_set_channel(receiver2,i);
     message2 = wb_receiver_get_data(receiver2,'double');
     wb_receiver_next_packet(receiver2);
      array(3)= message2(1);
      dc= array(3);
      array(4) = message2(2); 
      array(5) = message2(3); 
      % now calculate the energy consumption,changen them from dBm into mW
      receivedpower3=0.001*(10^(0.1*array(4)));
      transmittedPower3=0.001*(10^(0.1*transmittedPower));
      delta = transmittedPower-receivedpower3;
      powerConsumption = 10*log(delta);
      Z=sprintf(' maximal range is %f,received power is %f[dBm], frequency is %.3f[Hz],power consumption is %.3f[dB]',maxRange,array(4),array(5),powerConsumption);
      disp(Z);
      
      fid = fopen('sensorInfo.txt','wt');
      fprintf(fid,'%g\n',maxRange,array(4),array(5),powerConsumption); 
     
     
     % Y=sprintf('%f %f %f', array(3), array(4),array(5));
   % disp(Y);
     % wb_console_print('3allesgut', WB_STDOUT);

end
    
       if (mod(counter,50)==0)
      [yellowpos1,yellowpos2,yellowpos3,yellowpos4] = obstaclePosition([data(4),data(5),data(6)],[data(7),data(8)],data(9));
     % [t,I] = RIR(data(1),data(3),0,yellowpos1,yellowpos2,yellowpos3,yellowpos4,data(10),data(11),data(12),data(13),data(14),data(15));
     
     RIR_Input = [data(1),data(3),0,yellowpos1,yellowpos2,yellowpos3,yellowpos4,data(10),data(11),data(12),data(13),data(14),data(15)];
     
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
    % p(samples,:) = pos;
    % plot latest trajectory segment
     % subplot(2,1,2);
    % if (samples > 100)
      % plot(p(samples-100:samples,1),-p(samples-100:samples,3));
    % else
      % plot(p(1:samples,1),-p(1:samples,3));
    % end

    % plot current e-puck position
    % hold on;
    % plot(p(samples,1),-p(samples,3),'ro');
    % axis([-30 30 -30 30]);
    % title('Trajectory (Supervisor)');
    % hold off;
    
    
    
    
     % receivedpower3=0.001*(10^(0.1*array(4)));
     % powerConsumption = 10*log(1000*(P-receivedpower3));
    % Z=sprintf('received power is  %f',array(4));
  % disp(Z);
  
  
  
   Y=sprintf('the triliteration function value is a=%f b=%f c=%f', da,db,dc);
    disp(Y); 
  literation(data(10),data(11),data(12),data(13),data(14),data(15), da,db,dc);

  drawnow;

end

% cleanup code goes here: write data to files, etc.
