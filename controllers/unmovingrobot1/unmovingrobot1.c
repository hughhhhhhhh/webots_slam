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
 * Description:  The controller of the unmoving robot1
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


#define SPEED 6
#define TIME_STEP 64
double distanceMeasurement=0;

int main() {
  WbDeviceTag radar = 0;
  int  i;
  wb_robot_init();
  //get and enable the emitter
  WbDeviceTag emitter;
  emitter = wb_robot_get_device("emitter");
  wb_emitter_set_channel(emitter,1);

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
       if (radar) {
      int targets_number = wb_radar_get_number_of_targets(radar);
      const WbRadarTarget *targets = wb_radar_get_targets(radar);
    // printf("%s see %d targets.\n", wb_robot_get_name(), targets_number);
      for (i = 0; i < targets_number; ++i){
      //printf("---target %d: distance=%lf azimuth=%lf\n", i + 1, targets[i].distance, targets[i].azimuth);
         distanceMeasurement = targets[i].distance;
         //char message[128];
         //sprintf(message, "the first distance measurement is %f", distanceMeasurement);
        double message[1] = { distanceMeasurement };
        wb_emitter_send(emitter, message, sizeof(double));               
       printf("the first distance is %f", distanceMeasurement);
                  }
    }
}
  wb_robot_cleanup();
  return 0;
}
