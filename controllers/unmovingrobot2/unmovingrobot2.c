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
#include <webots/emitter.h>
#define WB_CHANNEL_BROADCAST -1

#define SPEED 6
#define TIME_STEP 64

// extern double a=0;
 
// extern double b=0;
// extern double c=0;
double dist2=0;
//int a;
int main() {
  WbDeviceTag radar = 0;
  int  i;
  wb_robot_init();
  WbDeviceTag emitter2;
  emitter2 = wb_robot_get_device("emitter2");
  wb_emitter_set_channel(emitter2,2);

  //wb_robot_battery_sensor_enable(TIME_STEP);


  /* get the radar if this robot has one. */
  for (i = 0; i < wb_robot_get_number_of_devices(); ++i) {
    WbDeviceTag tag = wb_robot_get_device_by_index(i);
    if (wb_device_get_node_type(tag) == WB_NODE_RADAR) {
      radar = tag;
      wb_radar_enable(radar, TIME_STEP);
      break;
    }
  }





while (wb_robot_step(TIME_STEP) != -1){
    //printf("Battery 2: %.3f J\n", wb_robot_battery_sensor_get_value());

    if (radar) {
      int targets_number = wb_radar_get_number_of_targets(radar);
      const WbRadarTarget *targets = wb_radar_get_targets(radar);
     //printf("%s see %d targets.\n", wb_robot_get_name(), targets_number);
      for (i = 0; i < targets_number; ++i){
      // printf("---target %d: distance=%lf azimuth=%lf\n", i + 1, targets[i].distance, targets[i].azimuth);
       
         dist2 = targets[i].distance;
         //char message[128];
         //sprintf(message, "the first distance is %f", dist1);
        double message[1] = { dist2};
        wb_emitter_send(emitter2, message,sizeof(double));   
          //int  a = wb_emitter_get_channel(emitter2);
          // printf("send test:%f,from channel%d\n",message[0],a);


  //wb_emitter_send(emitter, message, strlen(message) + 1);


         
         }
    }

}
  wb_robot_cleanup();

  return 0;
}
