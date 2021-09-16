`tasks.cpp` contains the code that navigates the submarine through the competition course. There is a function for each competition task (eg. gate, bins, target, octagon) that contains a set of linear instructions for the sub to follow to complete the task. 

Before we start the function breakdown, let's clear up a few things. 
1. `tasks.cpp` uses a plethora of high-level functions such as `setForward` or `forwardAlign`; these helper functions are defined in `commands.cpp`. 
2. `State` objects record the position of the sub. The object has `x, y, z, yaw, pitch, roll` components in it, which follow the North-East-Down standard (positive x = forward, positive y = right, positive z = down). Yaw, pitch, and roll describe the orientation of the AUV.
3. Depth is measured from the bottom; in other words, a line saying `setDepth(2.5);` makes the submarine hover 2.5 meters above the floor.

With that said, let's get started. :100: 

## Function Breakdown

#### void coin_flip() :construction: WORK IN PROGRESS

In the competition, we can choose to attempt the coin flip task, where the AUV is deployed in a random orientation and we must first orient it correctly towards the tasks. In this instance, we attempt to use our hydrophones system to get the angle to the octagon and follow that route. This is currently a work in progress.

1. We submerge the sub under the water.
2. We request the angle towards the octagon from the FPGA using the `control_client`.
3. If the angle to the octagon is valid, then we tell the sub to turn to that angle.
4. Finally, `control_client::write("x\n");` tells Nautical to clean its variables and set the origin point (0, 0, 0, 0, 0, 0) as the sub's current position.

#### void gate()

This function controls the AUV to pass through the gate in competition, using our ML models to detect the gate and give us the angle to move through it.

1. Submerge the sub.
2. Set the sub to move a few meters forward for the gate to get in view. This is done using `setCoordinate` instead of `setForward` because we want to make sure that the sub does not stray off to the side, by setting the y coordinate target to 0.
3. Print the current state of the sub (for aesthetic/debugging/informative purposes for the software user that is looking at the printed messages in the terminal)
4. Use the `forwardAlign` function to detect the gate and move through it. The benefit of using this function is that it continually readjusts the trajectory of the sub as new images are coming in, hopefully allowing for increased accuracy.
5. Use the `continuousSpin` function to have the sub spin hopefully 2 meters in front of the gate, to do 2 full rotations (720 degrees).
6. Orient the sub to continue through the rest of the course depending on which competition pool we are in.
7. Move forward to continue through the course.

#### void bins()

This function controls the AUV to navigate from the gate to the bins, position the AUV above the bins, and drop our markers (balls) into the bins. The reason why we attempt bins before targets, which are closer to the gate, is because touching the backside of the targets yields more points, so we opt to attempt bins first then touch the backside of the targets.

1. Orient the sub towards the bins, depending on which competition pool we are in.
2. Use the `setForwardAtDepth` function to move numerous meters forward to reach the bins, while at a depth of 1 meter (this time, it means 1 meter below the surface).
3. Set the sub to maintain a consistent depth as we look for the bins.
4. Set up the search_offsets array/vector to have a list of relative movements we can move the sub with to find the bins, if we can't find them on the first try.
5. Use the `downContinuousAlign` function to use the vision system to look for the bins; if we see the bins, this function will position the AUV above them. If we can't find the bins, then the for loop will have the sub move a little bit using a search_offset to see if we can get the bins in view and repeat the vision process.
6. Set the `acceptable_error` to 0.5. This allows the `setDepth` function to break as long as we are within 0.5 meters of our desired depth. 
7. Set the depth to 1.5. We are descending and honing onto the bins (hopefully).
8. Continuously align the sub again, continuously readjusting the sub's position to be right on top of the bins (hopefully).
9. Set the depth to 0.75, descending to the closest that we will get to the bins.
10. Continuously align the sub for the last time, setting the AUV up for the marker drop.
11. Drop the balls (markers).

#### void target()

This function controls the sub to navigate from the bins to the buoys, utilizing the vision system to detect the buoys and orienting the AUV to ram them.

1. Store the initial state the AUV is in so that we can return to it when we're finished.
2. Turn the sub around to look back towards the origin and face the buoys.
3. Tell the sub to maintain a depth as it approaches the buoys.
4. Move forward to approach the buoys.
5. Store the original state of the AUV so we can return to it if we can't detect the first buoy.
6. Find the angle to the first buoy using our vision system and the `forwardSweepCheck` function. This function will continually make the sub turn and move forward to try to get the buoys in view if it can't find them.
7. Check if the angle is legit. If it's legit, then we continue the process.
8. Use the angle to turn towards the first buoy.
9. Use the `forwardAlign` function to turn towards the buoy and ram it, similar to how it was used in `gate()`.
10. Wait for the AUV to ram the buoy.
11. Tell the sub to move back.
12. If the sub could not detect the buoys, then we move back to the original state.
13. Move sideways to be in position to detect the next target.
14. Repeat steps 6-12 for the second target.
15. Return back above the bins.

#### void octagon()

This function controls the AUV to navigate underneath the octagon and surface within it, using the FPGA's angle and coordinate calculations.

1. Tell the sub to maintain a depth.
2. Get the angle to the octagon from the FPGA.
3. Move 5 meters in that direction. (We don't use the coordinate calculation first in case the coordinate calculation is off and makes us crash into a wall.)
4. Execute a for loop to get the coordinates of the octagon, move to that coordinate, and repeat (so we readjust the location for a higher chance of success).
5. Surface the sub by telling the sub to go 0 meters below the surface.
6. Wait for the sub to reach the surface.
7. Kill the sub.

#### void prelim()

This function contains a list of fundamental movements that we can use to check if the sub is working correctly. If you'd like to execute this function, use `ros2 launch ros2_ws/launch/launch_prelim.py`.

#### void pool_test()

This function is where the software user can put the commands of what they would like the sub to do in a pool test. If you'd like to execute this function, use `ros2 launch ros2_ws/launch/launch_pool_test.py`.

#### void vision_test()

This function tests the vision capabilities of the sub by first submerging the sub and then aligning the sub above the bins. If you'd like to execute this function, use `ros2 launch ros2_ws/launch/launch_vision_test.py`.

#### void pid_tuning_sequence()

This function was originally a movement sequence for the sub to test its axes of control for the software user to edit the PID gains (the aggressiveness of the motors) to have the sub move smoothly and accurately, though it is now deprecated in favor of `sub_control`'s new `tuning.py` node where the user can remote-control the sub.

1. Tell the AUV to maintain a depth.
2. Test various movements for PID tuning (x, y, z, yaw, continuous spinning).