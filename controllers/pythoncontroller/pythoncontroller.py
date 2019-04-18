"""pythoncontroller controller."""

# You may need to import some classes of the controller module. Ex:
#  from controller import Robot, LED, DistanceSensor
from controller import Robot
import numpy as np
import rirgenerator as RG
import matplotlib.pyplot as plt
# create the Robot instance.
robot = Robot()

# get the time step of the current world.
timestep = 64

# You should insert a getDevice-like function in order to get the
# instance of a device of the robot. Something like:
#  led = robot.getLED('ledname')
#  ds = robot.getDistanceSensor('dsname')
#  ds.enable(timestep)

# Main loop:
# - perform simulation steps until Webots is stopping the controller
while robot.step(timestep) != -1:
  c = 340					# Sound velocity (m/s)
fs = 16000				# Sample frequency (samples/s)
r = [2,1.5,2]			# Receiver position [x y z] (m)
s = [2,3.5,2]			# Source position [x y z] (m)
L = [5,4,6]				# Room dimensions [x y z] (m)
beta = 0.4				# Reverberation time (s)
n = 4096				# Number of samples

h = RG.rir_generator(c, fs, r, s, L, beta=beta, nsample=n)

plt.plot(h[0,:])
plt.show()
    pass

# Enter here exit cleanup code.
