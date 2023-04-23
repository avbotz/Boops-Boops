Defines a bunch of helper functions that form basic movements. 

There are two main types of movement functions:
1) Blocking/Set: They wait until the sub has reached that position, then it terminates.
2) Non-blocking/Write: They don't wait for the sub to reach that position; they immediately terminate.

Blocking functions are good for normal movement through the course.
Non-blocking functions are good for more precise use cases when you want to continuously readjust your setpoint while you move to that setpoint (eg. in continuous align functions). 

These functions all route to send commands to sub_control, which relays these commands to the microcontroller, which controls the thrusters to move to that position. 

# Function Breakdown

## void setForward(float dist)

Moves the sub forward `dist` meters. A negative dist will move the sub back. Does this by converting your relative x offset to an absolute State (position), which is sent to the microcontroller to move to. 

## void setHorizontal(float dist)

Moves the sub `dist` meters to the right. A negative dist will move the sub left. 

## void setAngle(float angle)

Turns the sub to your specified absolute angle. 

## void addAngle(float angle)

Turns the sub to your specified relative angle.

## void setForwardAtAngle(float dist, float angle)

Moves the sub to go forward at that absolute angle, while turning to that absolute angle, at the same time.

## void setForwardAtDepth(float dist, float depth)

Moves the sub forward while adjusting to that depth. 

## void writeVelocity(float forward_m_s, float right_m_s, float down_m_s)

Tells the sub to move at those velocities. Doesn't wait for the sub to reach those velocities because this is a `write` function, not a `set` function.

## void setVelocity(float forward_m_s, float right_m_s, float down_m_s)

Same as `writeVelocity` but waits a lil bit to reach those velocities, then terminates.

## void setAngularVelocity(float yaw_deg_s, float pitch_deg_s, float roll_deg_s)

Tells the sub to move at those angular velocities. (Ik, this is a `set` function but it doesn't wait for the sub to reach it, that's my b bro)

## void writeAngle(float yaw_deg, float pitch_deg, float roll_deg)

Tells the sub to move to those absolute degrees. Doesn't wait for sub to reach that orientation before terminating. 

## void writeDepth(float depth)

Tells the sub to move to that depth without waiting for it to reach it before terminating. Useful when continuously aligning.

## void writeAltitude(float altitude)

Tells the sub to move to that altitude without waiting for it to reach it before terminating. (The sub can maintain altitude, or depth, depending on which one you set).

## void setDepth(float depth, float acceptable_error)

Tells the sub to move to that depth. Waits until you are within `acceptable_error` meters of that depth, then it terminates. The default acceptable_error is defined in `movements.hpp`.

## void setDepthSlow(float depth, float acceptable_error)

Same as setDepth but tries to descend/ascend slowly by maintaining an explicit down velocity (useful for grabbing).

Todo: make depth controls nice af so we don't have to worry about overshooting and moving down too fast so we don't need this function. 

## void setAltitude(float altitude, float acceptable_error)

Same as setDepth but tells the sub to move to that altitude. 

## void setAltitudeSlow(float altitude, float acceptable_error)

Same as setDepthSlow but tells the sub to move to that altitude. 

## void continuousSpin(float degrees_to_spin)

Continuously spins the sub that amount of degrees. If `degrees_to_spin`=720, the sub will spin 720 degrees to the right. If the inputted angle is negative, it will spin to the left. 

Does this by setting an angular velocity until we have spun enough.

## void setCoordinate(Coordinate coordinate)

Moves the sub to the desired absolute Coordinate (its absolute x and y). Waits until reaches the position before terminating. 

Eg.
```cpp
Coordinate coord = create_coordinate(5, 0);
setCoordinate(coord);
```

## void addCoordinate(Coordinate coordinate)

Moves the sub to the desired relative Coordinate (treating the Coordinate object's x and y values as relative). Waits until reaches the position before terminating. 

## void setCoordinateAtDepth(Coordinate coordinate, float depth)

Same as setCoordinate, but adjust to that depth at the same time while moving. 

## void writeCoordinate(Coordinate coordinate)

Same as setCoordinate, but doesn't wait for sub to reach that position before terminating. 

## float findHoverDepth(float desired_altitude)

Tries to convert a desired_altitude to a depth. For example, if we wanted to find the depth that corresponds to an altitude of 1 meter, this function would return that depth. 

Does this by forming a water column (current depth + altitude), and subtracting our desired altitude, to get our desired depth. Averages multiple samples.

## void dropBalls()

Tells the microcontroller to drop both of the balls. Repeats the sequence multiple times to make sure they are dropped. 

The commands this sends to the microcontroller are something like:
`g 0 0`, which means for the 0th ball, don't drop it.
`g 0 1`, which means for the 0th ball, drop it.
For the first ball (the other ball),
`g 1 0`, which means for the 1st ball, don't drop it.
`g 1 1`, which means for the 1st ball, drop it. 

## void shootTorp(int idx)

Tells the microcontroller to shoot that torp. 

idx = 0 means to shoot the 0th torp, `o 0 1` (for the 0th torp, shoot it)
idx = 1 means to shoot the 1st (other) torp. `o 1 1` (for the 1st torp, shoot it)

## void openGrabber()

Tells the microcontroller to open the grabber by sending it a command. 

`f 0` (for the grabber, open it)

## void closeGrabber()

Tells the microcontroller to close the grabber by sending it a comand.

`f 1` (for the grabber, close it)

## bool waitUntilHit(int camera)

Assumes the sub is already moving, blocks/sleeps until it detects a change in velocity, at which point this function terminates. Essentially, it waits until we hit something.

Useful for buoys or grabbing. 

## void move(const State dest)

Moves the sub to the desired absolute State, waits until we reach it, then terminate.

Eg.
```cpp
State state = create_state(1, 1, 0, 90, 0, 0);
move(state); // Moves the sub to the 1, 1, 0, 90, 0, 0; x y z yaw pitch roll position
```

Note that this can only affect x, y, and yaw. It doesn't affect z, pitch, and roll even when you input those values because we don't want to be changing those all the time. We usually set our depth through separate setDepth functions to be more stable, and we don't mess with pitch and roll. 

## void write_state(const State dest)

Same as move() except we don't wait for the sub to reach that position before terminating. 

## void surfaceAndKill()

Tells the sub to surface, and then tells the microcontroller to have 0 thruster power (which makes the microcontroller send thrust commands of 0 force to the thrusters).