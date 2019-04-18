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

//#include <webots/supervisor.h>

#define WB_CHANNEL_BROADCAST -1

#define SPEED 6
double TIME_STEP3=64;

// extern double a=0;
 
// extern double b=0;
// extern double c=0;
double dist3=0;
double receivedPower3 = 0;
//int a;
int main() {
  WbDeviceTag radar = 0;
  int  i;
  wb_robot_init();
  WbDeviceTag emitter3;
  emitter3 = wb_robot_get_device("emitter3");
  wb_emitter_set_channel(emitter3,3);
 // wb_robot_battery_sensor_enable(TIME_STEP3);

  /* get the radar if this robot has one. */
  for (i = 0; i < wb_robot_get_number_of_devices(); ++i) {
    WbDeviceTag tag = wb_robot_get_device_by_index(i);
    if (wb_device_get_node_type(tag) == WB_NODE_RADAR) {
      radar = tag;
      wb_radar_enable(radar, TIME_STEP3);
      
      
      break;
    }
  }

 //const char *name = wb_supervisor_node_get_def(radar);

 //const char *name = wb_device_get_name(radar);
  //WbNodeType type = wb_device_get_node_type(radar);
 //const char *wb_device_get_name(WbDeviceTag tag);
 
//const char *model= wb_device_get_model(radar);
 // printf("model name = %s\n",  model);





while (wb_robot_step(TIME_STEP3) != -1){


    if (radar) {
      int targets_number = wb_radar_get_number_of_targets(radar);
      const WbRadarTarget *targets = wb_radar_get_targets(radar);
  //printf("%s see %d targets.\n", wb_robot_get_name(), targets_number);
      for (i = 0; i < targets_number; ++i){
      //printf("---target %d: distance=%lf received_power=%lf[dBm]\n", i + 1, targets[i].distance, targets[i].received_power);
         dist3 = targets[i].distance;
         receivedPower3 = targets[i].received_power;
        double message[3] = { dist3,receivedPower3,TIME_STEP3};
        wb_emitter_send(emitter3, message,3*sizeof(double));   //take care of the size of message!



         
         }
    }

}
  wb_robot_cleanup();

  return 0;
}
