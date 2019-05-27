
Webots Preparation Work
====  

1) Install Webots
-------  

 * R2019a

    [webots](https://cyberbotics.com/)


2) Install ROS 
-------  

 * rosdistribution: melodic
 * rosversion: 1.14.3

    [ROS](http://wiki.ros.org/ROS/Installation) 

3) Create a workspace
-------  
  (if you haven't created one before)


 ```mkdir -p catkin_ws/src  ```
 
 ```cd catkin_ws/src  ```
 
 ```catkin_init_workspace ```

4) Install the webots_ros package
-------  

Extract and copy ‘webots_ros’ document in your workspace (catkin_ws)

 ```catkin_make ```
 
 
5) Install the gmapping package(Melodic)
-----------

1)Install the dependent library

```sudo apt-get install libsdl1.2-dev```

```sudo apt install libsdl-image1.2-dev```

2)Get into workspace

```cd ~/catkin_ws/src/```

3)Gitclone following codes

```git clone https://github.com/ros-perception/openslam_gmapping.git```

```git clone https://github.com/ros-perception/slam_gmapping.git```

```git clone https://github.com/ros-planning/navigation.git```

```git clone https://github.com/ros/geometry2.git```

```git clone https://github.com/ros-planning/navigation_msgs.git```

4)Install the package

```cd ..```

```catkin_make```




___warning___:

if your ROS is the version 'kinetic', you can use following command to install the gmapping package

```sudo apt-get install ros-kinetic-slam-gmapping```








Running  webots
======
There are three worlds with three difficulties: simplest,normal and complex,


1) Open Matlab 
--------
1)Open and Run the first section of corresponding webotsscript

```controllers/matlab_supervisor/webotsscript(simplest).m``` or 

```controllers/matlab_supervisor/webotsscript(normal).m```    or

```controllers/matlab_supervisor/webotsscript(complex).m```



2)Line 70: change your own workspace location to save "my_map.pgm"

```imag_SLAM = '/home/huanghe/catkin_ws/my_map.pgm';```

2) Open  Webots
--------
 Open world ```worlds/SLAM(simplest).wbt``` or ```worlds/SLAM(normal).wbt``` or  ```worlds/SLAM(complex).wbt```

3) Open ROS
---------

open Terminal

```roscore```

open a new tab

```cd catkin_ws/```

```source devel/setup.bash```

```rosrun webots_ros pioneer3at```

4) Run gmapping
----------

open a new tab 

```cd catkin_ws/```

```source devel/setup.bash```

```rosrun gmapping slam_gmapping scan:=/pioneer3at/Sick_LMS_291/laser_scan/layer0 _xmax:=30 _xmin:=-30 _ymax:=30 _ymin:=-30 _delta:=0.2```

5) Open GUI
--------

open new tab

```rqt```

6) Visualize SLAM
-------------

Add - By topic – Map


7) Save the result of the SLAM
---------

```cd catkin_ws/```

```source devel/setup.bash```

```rosrun map_server map_saver -f SLAMresult```

if it doesn't work, you may need to install the map_server package 

[ROS package](http://wiki.ros.org/map_server) 



8) Calculate the exploration
--------
run the corresponding section in matlab script





