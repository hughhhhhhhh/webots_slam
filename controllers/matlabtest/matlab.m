% Description: MATLAB controller example for Webots
%              This example does not need the Image Processing Toolbox

% uncomment the next two lines if you want to use
% MATLAB's desktop and interact with the controller
% desktop;
% keyboard;
%RIR   Room Impulse Response.
%   [h] = RIR(FS, MIC, N, R, RM, SRC) performs a room impulse
%         response calculation by means of the mirror image method.
%
%      FS  = sample rate.
%      MIC = row vector giving the x,y,z coordinates of
%            the microphone.  
%      N   = The program will account for (2*N+1)^3 virtual sources 
%      R   = reflection coefficient for the walls, in general -1<R<1.
%      RM  = row vector giving the dimensions of the room.  
%      SRC = row vector giving the x,y,z coordinates of 
%            the sound source.

%c = 340;                    % Sound velocity (m/s)
%fs = 16000;                 % Sample frequency (samples/s)
%r = [2 1.5 2];              % Receiver position [x y z] (m)
%s = [2 3.5 2];              % Source position [x y z] (m)
%L = [5 4 6];                % Room dimensions [x y z] (m)
%beta = 0.4;                 % Reverberation time (s)
%n = 4096;                   % Number of samples

%h = rir_generator(c, fs, r, s, L, beta, n);
clc;
clear all;

 [t,I] = RIR;
     

 % hold on;



% control step
TIME_STEP=64;

% number of distance sensors
N=8;

% motor speed unit
SPEED_UNIT=0.00628;

% for collision avoidance
braitenberg_matrix = [
 150 -35;
 100 -15;
  80 -10;
 -10 -10;
 -10 -10;
 -10  80;
 -30 100;
 -20 150 ];

% edge detection matrix
conv_matrix = [
 -1 -1 -1;
 -1  8 -1;
 -1 -1 -1 ];

% get and enable all distance sensors
for i=1:N
  ps(i) = wb_robot_get_device(['ps' int2str(i-1)]);
  wb_distance_sensor_enable(ps(i),TIME_STEP);
end

% get the display (not a real e-puck device !)
display_device = wb_robot_get_device('display');
wb_display_set_color(display_device, [0 0 0]);

% get and enable camera
camera = wb_robot_get_device('camera');
wb_camera_enable(camera,TIME_STEP);

% get and enable emitter and receiver
emitter = wb_robot_get_device('emitter');
receiver = wb_robot_get_device('receiver');
wb_receiver_enable(receiver,TIME_STEP);

% get the motors and set target position to infinity (speed control)
left_motor = wb_robot_get_device('left wheel motor');
right_motor = wb_robot_get_device('right wheel motor');
wb_motor_set_position(left_motor, inf);
wb_motor_set_position(right_motor, inf);
wb_motor_set_velocity(left_motor, 0);
wb_motor_set_velocity(right_motor, 0);

% avoid dummy values on first device query
step = 0;
samples = 0;

wb_console_print('Running Matlab sample Webots controller.', WB_STDOUT);















 


while wb_robot_step(TIME_STEP) ~= -1
%  for x= 1:2
% AW = addWall(   [], [0 0 0], [0 0 3], [5 0 3], [5 0 0], 0.7);
% AW = addWall(AW, [0 0 0], [0 0 3], [0 5 3], [0 5 0], 0.7);
% AW = addWall(AW, [5 0 0], [5 0 3], [5 5 3], [5 5 0], 0.7);
% AW = addWall(AW, [0 5 0], [0 5 3], [5 5 3], [5 5 0], 0.7);
% AW = addWall(AW, [0 1 0], [0 1 1], [1 1 1], [1 1 0], 0.7);
% AW = addWall(AW, [0 0 3], [5 0 3], [5 5 3], [0 5 3], 0.8);
% AW = addWall(AW, [0 0 0], [5 0 0], [5 5 0], [0 5 0], 0.5);
% hb = @KemoL10_TF; % This is the beam function of a speaker that we use in
% AS = addSource(     [], [0.1 0.1 2.9]          , hb, [5 5 -3]);
% AS = addSource(AS, [4.9 0.1 2.9], hb, [-1 1 0]);
% MR = 4; % 
% fs1 = 192e3; % sampling frequency (>= 4xfh)
% fl = 100;  % lower frequency bound
% fh = 60e3; % upper frequency bound (<=80 kHz due to @KemoL10_TF)
% makeFile('testfile', AW, AS, MR, fs1, fl, fh);
% % displayRoom('testfile','HideVS');
% R = addReceiver([1 2.9 0.1]);
% C = USChannel(); % Create an ultrasonic chanell with typical characteristics
% C.T = 25;  % temperatura �C
% C.H = 30;  % humidade %
% C.P = 1.01;% pressure atm
% I = impR('testfile', R, C); % Compute the impulse response for each source
% N = length(I);
% t = (0:N-1)/fs1;
% subplot(2,2,1);
% plot(1000*t,abs(I))
% ylabel('Amplitude')
% xlabel('Time (ms)')
% legend('Source 1','Source 2')
%     
%  end
    
    
    
    
    
    
  step = step + 1;

  % convert to null-terminated 8 bit ascii string
  message = uint8([datestr(now) 0]);
  wb_emitter_send(emitter, message);

  % read all distance sensors
  for i=1:N
    sensor_values(i) = wb_distance_sensor_get_value(ps(i));
  end

  % get camera RGB image
  % this function return an image in true color (RGB) uint8 format
  rgb = wb_camera_get_image(camera);

  % display inversed rgb image with Display device
  inverse = 255 - rgb;
  imageref = wb_display_image_new(display_device, inverse, WB_IMAGE_RGB);
  wb_display_image_paste(display_device, imageref, 0, 0, false);
  wb_display_image_delete(display_device, imageref);

  % add gunsight lines
  wb_display_draw_line(display_device, 0, 19, 51, 19);
  wb_display_draw_line(display_device, 25, 0, 25, 38);

  % create intensity image from RGB image
  intens = double((rgb(:,:,1)+rgb(:,:,2)+rgb(:,:,3))/3);

  % edge detection
  edges = conv2(intens, conv_matrix, 'valid');

%   % display camera image
  % subplot(2,2,1);
  % image(rgb);
  % title('RGB Camera');
  


%   % display 'canny' image
%   subplot(2,2,2);
%   image(edges);
%   colormap('gray');
%   title('Edge detection');

% test for the matlab function















  % get position from Supervisor
  while wb_receiver_get_queue_length(receiver) > 0  
    pos = wb_receiver_get_data(receiver,'double');
    wb_receiver_next_packet(receiver);

      % subplot(2,2,1);
        % fs=44100;
        % mic=[1 0 -1]; 
        % n=12;
        % r=0.3;       
        % rm=[2 2 2];
        % src=[pos(1) 0 pos(3)]; 
        % h=rir(fs, mic, n, r, rm, src);
         % title('RIR1');

         
         subplot(2,2,1);
        plot(1000*t,abs(I))
        ylabel('Amplitude')
        xlabel('Time (ms)')
        legend('Source 1','Source 2')
         title('RIRtest');
         hold on;
    
         subplot(2,2,2);
        fs=44100;
        mic=[1 0 1]; 
        n=12;
        r=0.3;       
        rm=[2 2 2];
        src=[pos(1) 0 pos(3)]; 
        h=rir(fs, mic, n, r, rm, src);
         title('RIR2');

    
    
    
    
    % store position
    samples = samples + 1;
    p(samples,:) = pos;
    
    
    

    

    % plot latest trajectory segment
    subplot(2,2,3);
    if (samples > 100)
      plot(p(samples-100:samples,1),-p(samples-100:samples,3));
    else
      plot(p(1:samples,1),-p(1:samples,3));
    end

    % plot current e-puck position
    hold on;
    plot(p(samples,1),-p(samples,3),'ro');
    axis([-1 1 -1 1]);
    title('Trajectory (Supervisor)');
    hold off;
  end

  % plot distance sensor values
  subplot(2,2,4);
  bar([1:8], sensor_values);
  title('Distance sensors');
  axis([1 8 0 2000]);

  % flush graphics
  drawnow;
 %figure;


  % braitenberg collision avoidance
  speed = (1 - (sensor_values / 500)) * braitenberg_matrix * 5;

  % avoid Webots warning
  speed = min(speed, 1000);

  % actuate wheels
  wb_motor_set_velocity(left_motor, SPEED_UNIT * speed(1));
  wb_motor_set_velocity(right_motor, SPEED_UNIT * speed(2));
 % wb_motor_set_velocity(left_motor, 3.6);
  % wb_motor_set_velocity(right_motor,5);
  
  
  
end

% your cleanup code goes here
