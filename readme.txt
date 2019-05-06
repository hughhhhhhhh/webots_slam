Preparation Work
1)Install Webots

2)Install ROS(Melodic)

3)Clone the code from Github
https://github.com/hughhhhhhhh/webots_slam.git

If you haven't created any catkin workspace yet, you can create one with the following commands: 
mkdir -p catkin_ws/src 
cd catkin_ws/src 
catkin_init_workspace
Extract and copy ‘webots_ros’ document in catkin_ws
catkin_make





















Running the webots

1)Open Matlab and load the script
Run the first section of webotsscript
webotsslam_github/controllers/matlab_supervisor/webotsscript.m

line 44: change your own location to save "my_map.pgm"
imag_SLAM = '/home/huanghe/catkin_ws/my_map.pgm';

2)Open the webots and load the world
File - Open world – webotsslam_github/worlds/SLAM.wbt

3)Open terminal and run ROS
write down the following commands
roscore
open a new tab
cd catkin_ws/
source devel/setup.bash
cd src
rosrun webots_ros pioneer3at
4)Run gmapping
open a new tab and go to the locatin catkin_ws/
source devel/setup.bash
cd src
rosrun gmapping slam_gmapping scan:=/pioneer3at/Sick_LMS_291/laser_scan/layer0 _xmax:=30 _xmin:=-30 _ymax:=30 _ymin:=-30 _delta:=0.2
5) Visualize the sensors output in rqt
open new tab and write down the following command
rqt

6)Show the SLAM resluts
Add-By topic – Map

7) Calculation the exploration
open terminal and  go to the locatin of catkin_ws/
source devel/setup.bash
cd src
rosrun map_server map_saver -f my_map
run the corresponding section in matlab script

8) Run other sections of matlabscript
for example run the simulation for 500 steps,generate RIR, Display the corresponding room model...

