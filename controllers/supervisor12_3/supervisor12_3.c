/*
 * File:         void.c
 * Description:  This is an empty robot controller, the robot does nothing.
 * Author:       www.cyberbotics.com
 * Note:         !!! PLEASE DO NOT MODIFY THIS SOURCE FILE !!!
 *               This is a system file that Webots needs to work correctly.
 */
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
 * Description:  A controller for players of the soccer game from soccer.wbt
 */
#include <webots/emitter.h>

#include <stdlib.h>
#include <time.h>
#include <webots/receiver.h>
#include <webots/robot.h>
#include <webots/supervisor.h>
#include <string.h>
#include <stdio.h>
#include <math.h>
#include <webots/device.h>
#define TIME_STEP 64
#define TIME_STEPEPUCK 320
// #define ROUND(x) ((x)>=0?(long)((x)+0.5):(long)((x)-0.5))


#include <webots/display.h>
#include <webots/utils/system.h>


#define GROUND_X 2.0
#define GROUND_Z 2.0

#define LIGHT_GRAY 0x505050
#define RED 0xBB2222
#define GREEN 0x22BB11
#define BLUE 0x2222BB
#define WHITE 0xFFFFFF
#define INDIGO  0x4b0082
#define YELLOW   0xFFFF00
#ifndef M_PI 
    #define M_PI 3.14159265358979323846 
#endif


#include "math.h"
#include "rir_generator.h"

 double array[5];
double literation (double xa, double ya, double xb, double yb, double xc, \
double yc,double da,double db,double dc) ;

double literation (double xa, double ya, double xb, double yb, double xc,\
 double yc,double da,double db,double dc)
{
   double x,y,a,b,c,d,e,f;
 a=2*(xa-xc);
 b=2*(ya-yc);
 c=dc*dc-da*da-yc*yc+ya*ya-xc*xc+xa*xa;
 d=2*(xb-xc);
 e=2*(yb-yc);
 f=dc*dc-db*db-yc*yc+yb*yb-xc*xc+xb*xb;
 y=(f-c*d/a)/(e-b*d/a);
 x=(c-b*y)/a;
 // give the position of the epuck
    printf("\033[44;32;5m Moving robot Position from Triliteration: %.3f %.3f \033[0m \n",x,y);
    return 0;
}


 
 
 

//void computeRIR(double* imp,double c,double fs,double* rr,int nMicrophones,int nSamples,double* ss,double* LL,double* beta,char* microphone_type, int nOrder, double* angle, int isHighPassFilter);


int main(int argc, const char *argv[]) {
  wb_robot_init();

int i,nn;
//int a,b,c;


//epuck enable receiver emitter
  WbDeviceTag emitter = wb_robot_get_device("emitter");
    // WbDeviceTag emittertoyellowbox = wb_robot_get_device("emittertoyellowbox");
     // WbDeviceTag emitter9 = wb_robot_get_device("emitter9");


  WbDeviceTag receiver = wb_robot_get_device("receiver");
  
  wb_receiver_enable(receiver, TIME_STEPEPUCK);
  // wb_receiver_enable(emittertoyellowbox, TIME_STEPEPUCK);

  WbNodeRef epuck = wb_supervisor_node_get_from_def("PIONEER_3AT");
  WbFieldRef trans = wb_supervisor_node_get_field(epuck, "translation");







  // First we get a handler to devices
  WbDeviceTag ground_display = wb_robot_get_device("ground_display");

  // get the properties of the Display
  int width = wb_display_get_width(ground_display);
  int height = wb_display_get_height(ground_display);
 





double transmittedPower,maxRange,antennaGain,frequency;
//double yellowbox_rotation[4];


  WbNodeRef root, node,yellowboxsize;
  WbFieldRef children, transmittedPower_field,maxRange_field,antennaGain_field,frequency_field,yellowboxsize_field;
  
  
  
    WbDeviceTag receiver0=0; /* to receive coordinate information */
    WbDeviceTag receiver1=0;
    WbDeviceTag receiver2=0;
  
  
  root = wb_supervisor_node_get_root();
  children = wb_supervisor_node_get_field(root, "children");
  nn = wb_supervisor_field_get_count(children);
  printf("This world contains %d nodes:\n", nn);
  for (i = 0; i < nn; i++) {
    node = wb_supervisor_field_get_mf_node(children, i);
    printf("-> %s\n", wb_supervisor_node_get_type_name(node));
  }
  printf("\n");
  
   // node = wb_supervisor_field_get_mf_node(children, 8);
   node = wb_supervisor_node_get_from_def("MyBot3.Radar");
   yellowboxsize = wb_supervisor_node_get_from_def("YELLOW_BOX.Shape.geometryBox");
   yellowboxsize_field = wb_supervisor_node_get_field(yellowboxsize, "size");
   
   //yellowbox_rotation = wb_supervisor_node_get_from_def("YELLOW_BOX");
   WbNodeRef yellowBox = wb_supervisor_node_get_from_def("YELLOW_BOX");
   
 
   transmittedPower_field = wb_supervisor_node_get_field(node, "transmittedPower");
   maxRange_field = wb_supervisor_node_get_field(node, "maxRange");
   antennaGain_field = wb_supervisor_node_get_field(node, "antennaGain");
   frequency_field = wb_supervisor_node_get_field(node, "frequency");
    

  antennaGain = wb_supervisor_field_get_sf_float(antennaGain_field);
  frequency = wb_supervisor_field_get_sf_float(frequency_field);
  //obstacle yellow box

  
  receiver0 = wb_robot_get_device("receiver0");
  receiver1 = wb_robot_get_device("receiver1");
  receiver2 = wb_robot_get_device("receiver2");
  wb_receiver_enable(receiver0, 64);
   wb_receiver_enable(receiver1, 64);
   wb_receiver_enable(receiver2, 64);

//get the position of three robots
WbNodeRef robot_node1 = wb_supervisor_node_get_from_def("MyBot1");
WbNodeRef robot_node2 = wb_supervisor_node_get_from_def("MyBot2");
WbNodeRef robot_node3 = wb_supervisor_node_get_from_def("MyBot3");
//WbNodeRef mybot = wb_supervisor_node_get_from_def("E_PUCK");
// WbNodeRef yellowBox = wb_supervisor_node_get_from_def("YELLOW_BOX");

//WbFieldRef translationField = wb_supervisor_node_get_field(mybot, "translation");
WbFieldRef trans_field1 = wb_supervisor_node_get_field(robot_node1, "translation");
WbFieldRef trans_field2 = wb_supervisor_node_get_field(robot_node2, "translation");
WbFieldRef trans_field3 = wb_supervisor_node_get_field(robot_node3, "translation");
WbFieldRef trans_field_yellowbox = wb_supervisor_node_get_field(yellowBox, "translation");
WbFieldRef rotat_field_yellowbox = wb_supervisor_node_get_field(yellowBox, "rotation");
WbFieldRef rotat_field_epuck = wb_supervisor_node_get_field(epuck, "rotation");

//WbFieldRef trans_field4 = wb_supervisor_node_get_field(robot_node4, "translation");



    
    
    
    
    
  // paint the display's background
  wb_display_set_color(ground_display, LIGHT_GRAY);
  wb_display_fill_rectangle(ground_display, 0, 0, width, height);
  wb_display_set_color(ground_display, RED);
  wb_display_draw_line(ground_display, 0, height / 2, width - 1, height / 2);
  wb_display_draw_text(ground_display, "x", width - 10, height / 2 - 10);
  wb_display_set_color(ground_display, BLUE);
  wb_display_draw_line(ground_display, width / 2, 0, width / 2, height - 1);
  wb_display_draw_text(ground_display, "z", width / 2 - 10, height - 10);

  // init image ref used to save into the image file
  //WbImageRef to_store = NULL;

  // init a variable which counts the time steps
  int counter = 0;
  
  
  

  while (wb_robot_step(TIME_STEP) != -1) {
  

    transmittedPower = wb_supervisor_field_get_sf_float(transmittedPower_field);
    
     
    double G = pow(10,antennaGain/10);
    double P=0.001*pow(10,0.1*transmittedPower);
        
  maxRange = pow(P*pow(10,6)*pow(G,2)*pow(299792458,2)/(pow(pow(10,9)*frequency,2)*pow(4*3.14159265358979,3)), 0.25);
   wb_supervisor_field_set_sf_float(maxRange_field,maxRange);


  //output the position of three robots
   const double *trans1 = wb_supervisor_field_get_sf_vec3f(trans_field1);
  const double *trans2 = wb_supervisor_field_get_sf_vec3f(trans_field2);
  const double *trans3 = wb_supervisor_field_get_sf_vec3f(trans_field3);
  const double  *yellowbox_size =wb_supervisor_field_get_sf_vec3f(yellowboxsize_field);

   const double *trans_yellowbox = wb_supervisor_field_get_sf_vec3f(trans_field_yellowbox);
   const double *rotat_yellowbox = wb_supervisor_field_get_sf_rotation(rotat_field_yellowbox);
      const double *rotat_epuck = wb_supervisor_field_get_sf_rotation(rotat_field_epuck);

   
   
 /* send 3 doubles to matlab */
    const double *pos = wb_supervisor_field_get_sf_vec3f(trans);
    // printf("the e puck position is  %.3g %.3g %.3g\n",-pos[0],pos[1],pos[2]);
    
    double data[16];
    // data[0]=pos[2];
    // data[1]=pos[1];
    // data[2]=-pos[0];
      data[0]=pos[0];
    data[1]=pos[1];
    data[2]=pos[2];
    data[3]=trans_yellowbox[0];
    data[4]=-trans_yellowbox[2];
    data[5]=trans_yellowbox[1];
    // data6 is the wide data 7 is high 
    data[6]= 0.5*yellowbox_size[2];
    data[7]=0.5*yellowbox_size[1];
    data[8]=rotat_yellowbox[1]*rotat_yellowbox[3];
    data[9]= trans1[0]; 
    data[10]= -trans1[2];
    data[11]= trans2[0];
    data[12]=- trans2[2];
    data[13]= trans3[0]; 
    data[14]=  -trans3[2];
    data[15]=  rotat_epuck[3]* rotat_epuck[1];
     // printf("the e puck rotation is  %.3g\n",data[15]);

     // printf("Sensor1_Position: %.3g %.3g \tSensor2_Position: %.3g %.3g\t Sensor3_Position: %.3g %.3g\n",data[9], data[10],data[11], data[12],data[13], data[14]);
     
     
    wb_emitter_send(emitter, data , 16 * sizeof(double));
       // wb_emitter_send(emitter9, data , 16 * sizeof(double));//send to the epuck his won position

    
    
    
     // wb_emitter_send(emittertoyellowbox, pos, 3 * sizeof(double));
   // const double *trans4 = wb_supervisor_field_get_sf_vec3f(trans_field4);
   // const double *rotation = wb_supervisor_field_get_sf_vec3f(rotation);
 //printf("the rotation is  %.3g %.3g %.3g\n",rotation[0],rotation[1],rotation[2]);
    //printf("Sensor1_Position: %.3g %.3g \tSensor2_Position: %.3g %.3g\t Sensor3_Position: %.3g %.3g\n",trans1[0], trans1[2],trans2[0], trans2[2],trans3[0], trans3[2]);
  
  
  
  
  
   // Update the translation field
   //const double *translation = wb_supervisor_field_get_sf_vec3f(translationField);

    // Update the counter
   counter++;

                
                         
     // wb_display_draw_line(ground_display, translation[0],translation[2]);
  // Clear previous to_store
     // if (to_store) {
      // wb_display_image_delete(ground_display, to_store);
       // to_store = NULL;
    // / }
// printf("the position is  %.3g %.3g %.3g\n",data[3],data[4],data[5]);
// printf("the size is  long: %.3g high: %.3g\n",0.5*yellowbox_size[2],0.5*yellowbox_size[1]);
// printf("the rotation is  %.3g rad \n",rotat_yellowbox[1]*rotat_yellowbox[3]);

    // Every 50 steps, store the resulted image into a file
    // if (counter % 10 == 0) {
         // ////paint the display's background
  // wb_display_set_color(ground_display, LIGHT_GRAY);
  // wb_display_fill_rectangle(ground_display, 0, 0, width, height);
  // wb_display_set_color(ground_display, RED);
  // wb_display_draw_line(ground_display, 0, height / 2, width - 1, height / 2);
  // wb_display_draw_text(ground_display, "x", width - 10, height / 2 - 10);
  // wb_display_set_color(ground_display, BLUE);
  // wb_display_draw_line(ground_display, width / 2, 0, width / 2, height - 1);
  // wb_display_draw_text(ground_display, "z", width / 2 - 10, height - 10);
    // //// display the robot position
    
   //wb_display_set_alpha(ground_display, 1);
    // wb_display_set_opacity(ground_display,1);
    // wb_display_set_color(ground_display, WHITE);
    // wb_display_fill_oval(ground_display, width * (translation[0] + GROUND_X / 2) / GROUND_X,
                         // height * (translation[2] + GROUND_Z / 2) / GROUND_Z, 2, 2);
    // wb_display_set_color(ground_display, GREEN);

     // wb_display_draw_line(ground_display,width * (trans1[0] + GROUND_X / 2) / GROUND_X, 
                         // height * (trans1[2] + GROUND_Z / 2) / GROUND_Z,
                         // width * (translation[0] + GROUND_X / 2) / GROUND_X,
                         // height * (translation[2] + GROUND_Z / 2) / GROUND_Z);
                         
                         
              // wb_display_set_color(ground_display, GREEN);

     // wb_display_draw_line(ground_display,width * (trans2[0] + GROUND_X / 2) / GROUND_X, 
                         // height * (trans2[2] + GROUND_Z / 2) / GROUND_Z,
                         // width * (translation[0] + GROUND_X / 2) / GROUND_X,
                         // height * (translation[2] + GROUND_Z / 2) / GROUND_Z);               
                         
                                       // wb_display_set_color(ground_display, GREEN);

     // wb_display_draw_line(ground_display,width * (trans3[0] + GROUND_X / 2) / GROUND_X, 
                         // height * (trans3[2] + GROUND_Z / 2) / GROUND_Z,
                         // width * (translation[0] + GROUND_X / 2) / GROUND_X,
                         // height * (translation[2] + GROUND_Z / 2) / GROUND_Z);  
//draw the reflection

                                // wb_display_set_color(ground_display, INDIGO);
    // wb_display_draw_line(ground_display,width * (trans3[0] + GROUND_X / 2) / GROUND_X, 
                         // height * (trans3[2] + GROUND_Z / 2) / GROUND_Z,
                         // width * (trans_yellowbox[0] + GROUND_X / 2) / GROUND_X,
                         // height * (trans_yellowbox[2] + GROUND_Z / 2) / GROUND_Z);
    // wb_display_draw_line(ground_display,width * (trans2[0] + GROUND_X / 2) / GROUND_X, 
                         // height * (trans2[2] + GROUND_Z / 2) / GROUND_Z,
                         // width * (trans_yellowbox[0] + GROUND_X / 2) / GROUND_X,
                         // height * (trans_yellowbox[2] + GROUND_Z / 2) / GROUND_Z);
    // wb_display_draw_line(ground_display,width * (trans1[0] + GROUND_X / 2) / GROUND_X, 
                         // height * (trans1[2] + GROUND_Z / 2) / GROUND_Z,
                         // width * (trans_yellowbox[0] + GROUND_X / 2) / GROUND_X,
                         // height * (trans_yellowbox[2] + GROUND_Z / 2) / GROUND_Z);
     // wb_display_draw_line(ground_display,width * (trans_yellowbox[0] + GROUND_X / 2) / GROUND_X, 
                         // height * (trans_yellowbox[2] + GROUND_Z / 2) / GROUND_Z,
                         // width * (translation[0] + GROUND_X / 2) / GROUND_X,
                         // height * (translation[2] + GROUND_Z / 2) / GROUND_Z);
    
//draw the yellow box
 // wb_display_set_color(ground_display, YELLOW);
//yellowbox_size[3]
  // const int px[] = {10,20,10, 0};
  // const int py[] = {0, 10,20,10};
  // wb_display_draw_polygon(ground_display,px,py,4); // draw a diamond
  
  
  
   // wb_display_draw_line(ground_display,width * ((trans_yellowbox[0]-yellowbox_size[2]/2 + GROUND_X / 2) / GROUND_X, 
                         // height * (trans_yellowbox[2]+yellowbox_size[2]/2+ GROUND_Z / 2) / GROUND_Z,
                         // width * (translation[0] + GROUND_X / 2) / GROUND_X,
                         // height * (translation[2] + GROUND_Z / 2) / GROUND_Z);
    
  
     // }
     
 // //matlab epuck
   while (wb_receiver_get_queue_length(receiver) > 0) {
   wb_receiver_set_channel(receiver,8);
      // //receive null-terminated 8 bit ascii string from matlab
      const char *string = wb_receiver_get_data(receiver);
      wb_supervisor_set_label(0, string, 0.01, 0.01, 0.1, 0x000000, 0.0, "Arial");
      wb_receiver_next_packet(receiver);
    }
  
  
  
    while (wb_receiver_get_queue_length(receiver0) > 0 ) {
     i=1;
     wb_receiver_set_channel(receiver0,i);
  //  a = wb_receiver_get_channel(receiver);
    const double *message = wb_receiver_get_data(receiver0);
     array[i-1] = *message;  
    wb_receiver_next_packet(receiver0);}
    
    
    while (wb_receiver_get_queue_length(receiver1) > 0 ) {
    i=2;
     wb_receiver_set_channel(receiver1,i);
//    b = wb_receiver_get_channel(receiver1);
    const double *message1 = wb_receiver_get_data(receiver1);
     array[i-1] = *message1;   
    wb_receiver_next_packet(receiver1);}
    
    
    while (wb_receiver_get_queue_length(receiver2) > 0 ) {
     i=3;
     wb_receiver_set_channel(receiver2,i);
    //c = wb_receiver_get_channel(receiver2);
    const double *message2 = wb_receiver_get_data(receiver2);
     array[i-1] = *message2; 
     message2++;
     array[i] = *message2; 
     message2++;
     array[i+1] = *message2; 


     
    wb_receiver_next_packet(receiver2);}
    
  
  //receive the battery signal from robotbattery1
    // if(array[0]==0) {
       // printf("Battery of sensor1 is empty\n");

    // }
    // else{}
    
 // printf("received value:%f from channel 1, %f from channel 2, %f from channel 3 \n",array[0],array[1],array[2]);
  double receivedpower3=0.001*pow(10,0.1*array[3]);
  double powerConsumption = 10*log10(1000*(P-receivedpower3));
  //energy consumption
     printf("Radar3 TransmittedPower = %.1f[dBm],MaxRange= %f,Radar3 Received power %f[dBm],the power consumption is %f[dBm],the Radar sampling frequency is %.3f[Hz]\n",transmittedPower,maxRange,array[3],powerConsumption,1000/array[4]);

   
   literation(trans1[0], trans1[2],trans2[0], trans2[2],\
   trans3[0], trans3[2],array[0],array[1],array[2]);
 //printf("Moving robot Position from supervisor: %.3g %.3g\n",trans4[0], trans4[2]);
 
 
 }
  wb_robot_cleanup();

  return 0;
}



