`PIDController.cpp` is the file that defines the functions that are later used to control the thrusters of the sub inside the simulator, to get from the sub's current virtual position to its desired position. Basically I just copied Nautical-Private control code and re-routed it so that it sends the final motor thrust values to the simulator instead. 

### SimulatorNode::SimulatorNode()

This is the function that gets called every time an object of type "SimulatorNode" is created. Essentially this just initializes all the variables that we will use later. Some notable things are setting the initial states (positions + orientations) of the sub as 0, subscribing to the sim's sensor data topics, and setting up publishers that we will use to send DVL thrust values to the simulator.

### SimulatorNode::run()

This is the function that takes in the latest command from BB, parses it, and adjusts the thrust values to the simulator by calculating the difference between our current state and our desired state on all 6 axes (x, y, z, yaw, pitch, roll in North-East-Down coordinate frame and in meters and degrees), editing these error values using a PID (proportional, integral, derivative - search up online or see Nautical-Private's documentation) system, and assigning thrusts values to each thruster based on the error on each axis and the thruster's ability to reduce the error on those axes (the multiplication part basically says if you have error on this axis, and this thruster can move you in that direction, then add thrust to that motor). Finally, it publishes these thruster values, which means that it publishes these values to the simulator's ROS2 topic that listens for the thruster values that the thrusters should be set to, and then the simulator package (UUVSimulator/Plankton (Plantkon is a branch of UUVSimulator that is made to run on ROS2, since UUVSimulator was originally made for ROS Melodic)) updates these thruster values to the sub inside the sim. This basically mirrors the code that is run on Nautical-Private (large portions are copy-pasted, and edited in some places to work with the sim).

### SimulatorNode::getPorpoiseCommand()

This function parses the latest command from BB. Originally, the predecessor of BB was called Porpoise, which is why it's called `getPorpoiseCommand()`. This mirrors Nautical-Private's codebase in how it parses the command, as it expects command to look something like this: `p 0.2\n`, with the first character representing what type of command you're setting, with the subsequent elements being the values that you want to pass through, finished with a newline character at the end. So, this function first reads the character that represents what type of command is being sent to the file from BB, and then it reads in the subsequent elements and parses them accordingly based on what type of message we are receiving. There is some documentaiton on what each command does in the Nautical README, but you can figure them out by studying the code. 

### SimulatorNode::alive()

This returns true if the sub is alive and false if the sub is not alive. This mirrors Nautical-Private's code, but it's also used so that for the first 15 seconds while Gazebo is probably loading on someonen's computer, this returns false, and after that, when Gazebo probably finishes loading up, this returns true. So, this also serves the function of waiting for the simulator to load up. 

### SimulatorNode::kalmanCompute()

This function mimics the code that is run on Nautical-Private, which takes the latest velocity measurements from the sim's DVL and multiplies that by the time difference to get the change in position, which we can use to update the sub's state (state meaning position + orientation). The body to inertial function essentially converts relative velocities into absolute x and y velocities along the sim's coordinate frame. The function is called `kalmanCompute` because originally in Nautical-Private it was supposed to implement a Kalman filter to stabilize DVL data, but they ended up not using it (and I also copied over the stuff from there so wanted to keep the naming consistent).

### SimulatorNode::publishThrusterEfforts()

This function takes the latest thrust values that the object has and publishes them onto the simulator's ROS2 topic that listens for thrust values. Once these values are published, the Plankton simulator package will adjust the thrust values inside the sim to reflect that and move the sub.

### SimulatorNode::drop()

This function drops the balls from the sub onto the ground. It does this by finding the absolute position inside the simulator that the sub is at, and then it teleports the balls to that location to make the illusion that the sub is dropping the balls at that place. Finally, it updates the status of each ball being dropped so we don't drop the balls multiple times during the run to mimic real life. 

### SimulatorNode::getDvlMessageCallback()

This function is automatically run every time a new message is published onto the DVL message topic that the 3rd party simulator package publishes on, so this function essentially just saves those values so we can use them later in other functions of the object. 

### SimulatorNode::getImuMessageCallback() 

Does the same thing as the `getDvlMessageCallback` function except that since the sensors in the simulator package use quaternions (a different way of representing orientation, not standard yaw pitch roll Euler angles), we have to convert these values to Euler angles. Then, since the simulator package uses the ENU (East-North-Up, basically +x is forward, +y is left, +z is up) coordinate frame, we then convert those values into equivalent NED (North-East-Down) coordinate values and then save these values so the other functions in the class can use them.

### SimulatorNode::getPressureMessageCallback()

Does the same thing as the other callback functions, but it gets the raw pressure measurement value, and it does some calculations to convert that into our current depth. (Since pressure increases proportionally with depth, we can use pressure to calculate depth).

### PID::init()

This is the function that initializes the object/variable of type "PID". You can input the P, I, D gains for the PID error editor on that axis, and this function will save it for that variable. (Search up how PID values work lol)

### PID::calculate()

This is the function where you input the raw error on that axis (measured in meters or degrees depending on if it's a position or orientation error), and it returns the edited error based on the PID system. Essentially, it edits the error using 3 principles:
- Proportional: The more raw error there is, the more error this function outputs, proportionally.
- Integral: This adds up error over time, so that small differences in state will build up error and force you to move over time. Currently not used (the integral gain value is set to 0) since apparently it is unstable for us. 
- Derivative: This adds the slope of the error to the final outputted error. This means that if the error is increasing, it'll add more error, but if the error is decreasing, it'll subtract some error. Essentially, this allows you to dampen movement and slow down as you approach the target destination (since the error is decreasing, the error vs. time graph will have a negative slope, which will subtract some error from the PID output, making the motors slow down as you approach the target).

It also clamps the error between -2 and 2 so that the error doesn't get too high and result in us givng the thrusters values higher than the thrusters can spin at.

For the future, it might be good if we have a cascaded PID controller. A top level position controller outputs the target velocity that we should run at, and then we use a lower level velocity controller to calculate the error between our target velocity and current velocity and transfer this to a throttle (or increase in thrust) value that we should edit the current thrust value with and send to the thrusters. Theoretically I think this should make the sub more stable and more resistant to disturbances because if you push it on its side when it's moving forward, it will register this velocity error and try to push back (I think).