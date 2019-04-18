/*
 * Copyright 1996-2018 Cyberbotics Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * Description:  An example of controller using a radar device.
 */

#include <stdio.h>
#include <webots/device.h>
#include <webots/distance_sensor.h>
#include <webots/motor.h>
#include <webots/nodes.h>
#include <webots/radar.h>
#include <webots/robot.h>
#include <string.h>
#define SPEED 6
#define TIME_STEP 64

// extern double a=0;
 
// extern double b=0;
// extern double c=0;
  extern double dist1=0;
  extern double dist2=0;
  extern double dist3=0;
int main() {
  WbDeviceTag radar = 0;
  int  i;
  // double dist1=0;
  // double dist2=0;
  // double dist3=0;
  wb_robot_init();
  /* get the radar if this robot has one. */
  for (i = 0; i < wb_robot_get_number_of_devices(); ++i) {
    WbDeviceTag tag = wb_robot_get_device_by_index(i);
    if (wb_device_get_node_type(tag) == WB_NODE_RADAR) {
      radar = tag;
      wb_radar_enable(radar, TIME_STEP);
      break;
    }
  }




// while (wb_robot_step(TIME_STEP) != -1){


  // while (wb_robot_step(TIME_STEP) != -1&& strncmp(wb_robot_get_name(), "MyBot1", 7) == 0) {

   // if (radar) {
      // int targets_number = wb_radar_get_number_of_targets(radar);
      // const WbRadarTarget *targets = wb_radar_get_targets(radar);
    // printf("%s see %d targets.\n", wb_robot_get_name(), targets_number);
      // //printf("---target %d: distance1=%lf azimuth=%lf\n", 1, targets[0].distance, targets[0].azimuth);
     // dist1 = targets[0].distance;
     // a = dist1;
        // break;
    // }

    
    // }
           // printf(" a = %f\n",a);

  
    // while (wb_robot_step(TIME_STEP) != -1&& strncmp(wb_robot_get_name(), "MyBot2", 7) == 0) {

   // if (radar) {
      // int targets_number = wb_radar_get_number_of_targets(radar);
      // const WbRadarTarget *targets = wb_radar_get_targets(radar);
   //  printf("%s see %d targets.\n", wb_robot_get_name(), targets_number);
    // printf("---target %d: distance2=%lf azimuth=%lf\n", 1, targets[0].distance, targets[0].azimuth);
     // dist2 = targets[0].distance;
        // double b = dist2;
            // break;
    // }
    
    // }
    
          // printf(" b = %f\n",b);

    // while (wb_robot_step(TIME_STEP) != -1&& strncmp(wb_robot_get_name(), "MyBot3", 7) == 0) {

   // if (radar) {
      // int targets_number = wb_radar_get_number_of_targets(radar);
      // const WbRadarTarget *targets = wb_radar_get_targets(radar);
      // //printf("%s see %d targets.\n", wb_robot_get_name(), targets_number);
      // //printf("---target %d: distance3=%lf azimuth=%lf\n", 1, targets[0].distance, targets[0].azimuth);
     // dist3 = targets[0].distance;
      // double c = dist3;
// break;
    // }
    // }


          // //printf(" a = %f\t,b= %f\t,c= %f\n",a,b,c);

// }

while (wb_robot_step(TIME_STEP) != -1){

    if (radar && strncmp(wb_robot_get_name(), "MyBot1", 7) == 0) {
      int targets_number = wb_radar_get_number_of_targets(radar);
      const WbRadarTarget *targets = wb_radar_get_targets(radar);
     printf("%s see %d targets.\n", wb_robot_get_name(), targets_number);
     // ////for (i = 0; i < targets_number; ++i)
       //printf("---target %d: distance=%lf azimuth=%lf\n", i + 1, targets[i].distance, targets[i].azimuth);
        
       printf("---target %d: distance=%lf azimuth=%lf\n", 1, targets[0].distance, targets[0].azimuth);
        dist1 = targets[0].distance;
       break;
    }else if (radar && strncmp(wb_robot_get_name(), "MyBot2", 7) == 0) {
      int targets_number = wb_radar_get_number_of_targets(radar);
      const WbRadarTarget *targets = wb_radar_get_targets(radar);
     printf("%s see %d targets.\n", wb_robot_get_name(), targets_number);
       printf("---target %d: distance=%lf azimuth=%lf\n", 1, targets[0].distance, targets[0].azimuth);
        dist2 = targets[0].distance;
                break;
    }else if (radar && strncmp(wb_robot_get_name(), "MyBot3", 7) == 0) {
      int targets_number = wb_radar_get_number_of_targets(radar);
      const WbRadarTarget *targets = wb_radar_get_targets(radar);
      printf("%s see %d targets.\n", wb_robot_get_name(), targets_number);        
      printf("---target %d: distance=%lf azimuth=%lf\n", 1, targets[0].distance, targets[0].azimuth);
        dist3 = targets[0].distance;
                break;}

}
     

 
//printf("1: %f,2: %f,3: %f\n",dist1,dist2,dist3);

  
  wb_robot_cleanup();

  return 0;
}
