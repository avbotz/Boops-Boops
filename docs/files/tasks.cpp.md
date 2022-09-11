`tasks.cpp` contains the code that navigates the submarine through the competition course. There is a function for each competition task (eg. gate, bins, target, octagon) that contains a set of linear instructions for the sub to follow to complete the task. 

Before we start the function breakdown, let's clear up a few things. 
1. `tasks.cpp` uses a plethora of high-level functions such as `setForward` or `forwardAlign`; these helper functions are defined in `commands.cpp`. 
2. `State` objects record the position of the sub. The object has `x, y, z, yaw, pitch, roll` components in it, which follow the North-East-Down standard (positive x = forward, positive y = right, positive z = down). Yaw, pitch, and roll describe the orientation of the AUV.

With that said, let's get started. :100: 

# Function Breakdown

## void coin_flip() 

Disclaimer: This was written for the Natatorium pool at the University of Maryland; may not work for TRANSDEC because you have less range of view in the murky water. 

In the competition, we can choose to attempt the coin flip task, where the AUV is deployed in a random orientation and we must first orient it correctly towards the tasks. In this instance, we attempt to use our hydrophones system to get the angle to the octagon and follow that route. This is currently a work in progress.

1. We submerge the sub under the water.
2. We check the 4 possible 90 degree blocks where the gate can be; if we find it at one of the blocks, tell Nautical to record the current angle as the 0 degree point and to clear its state to mark the current position as the origin. 
3. If we couldn't find the gate, set power of thrusters to 0 to make the sub float and effectively kill the run (because can't do anything if you can't find the gate.)

## void gate()

This function controls the AUV to pass through the gate in competition, using our ML models to detect the gate and give us the angle to move through it.

1. Submerge the sub.
2. Set the sub to move a few meters forward for the gate to get in view. This is done using `setCoordinate` instead of `setForward` because we want to make sure that the sub does not stray off to the side, by setting the y coordinate target to 0.
3. Print the current state of the sub (for aesthetic/debugging/informative purposes for the software user that is looking at the printed messages in the terminal)
4. Use the `forwardAlign` function to detect the gate and move through it. The benefit of using this function is that it continually readjusts the trajectory of the sub as new images are coming in, hopefully allowing for increased accuracy.
5. Use the `continuousSpin` function to have the sub spin hopefully 2 meters in front of the gate, to do 2 full rotations (720 degrees).

## void buoy()

This function controls the sub to navigate from the bins to the buoys, utilizing the vision system to detect the buoys and orienting the AUV to ram them.

1. Position the sub above path marker, and turn toward the path marker's angle.
2. Forward sweep check for the buoy (will sweep, and if it can't find it, it will move forward and sweep again, repeat until total number of forward movements is taken up or until it finds the angle).
3. Turn towards the buoy.
4. Align depth with the buoy.
5. Forward align into the buoy to ram into it. (Once forward align is within a certain range, it will write the final setpoint that goes about 1.5 meters through the bouy, but it will exit the function and not block for it (to not forever block the code in case the sub can't move through the buoy.))
6. Wait for sub to finish ramming into buoy. 
7. Back up from the buoy.

## void bins()

This function controls the AUV to navigate from the gate to the bins, position the AUV above the bins, and drop our markers (balls) into the bins. 

1. Position sub above path marker.
2. Turn towards angle of path marker.
3. Move a big chunk forward towards the bins.
4. Move in small steps until you can see the bins. (Break from the sequence once you can see the bins.)
5. If you couldn't find the bins, then move the sub through a search pattern to look for the bins, aligning over the bins and breaking from the sequence once you can find it.
6. If you still couldn't find the bins, then stop the bins function (which will cause the next function to run.)
7. Continuous align 2 more times, each at deeper depths.
8. Drop the markers.

## void octagon()

For 2022 we cheesed the task by using our front camera to detect the octagon and our down camera to align over the octagon stools (in the future you may want to do hydrophones.)

Vision-based approach we used at UMD:
1. Face the starting angle of the course (yaw = 0, our original yaw.)
2. Sweep check for the octagon stools (it will return the angle to the octagon and break from the sequence if it finds it.)
3. Turn towards the octagon stools. 
4. Go forward and check again for the stools and turn towards them if you found it.
5. If at least one of your two checks found the octagon, then proceed, otherwise quit the function and surface.
6. Keep moving in small steps in the direction of the octagon (getting the front camera angle and readjusting after each step), until you can find the center stool with the down camera (the down camera octagon detection returns a valid angle.)
7. With the octagon stools in its sights, down continuous align above the center stool, and surface by setting 0 power to the thrusters.

Theoretical hydrophone based approach:
1. Tell the sub to maintain a depth.
2. Get the angle to the octagon from the FPGA.
3. Do the same approach where you keep moving in small steps in that direction until you can detect the stools with your down camera, then dodwn continuous align over the center stool.

## void prelim()

This function contains a list of fundamental movements that we can use to check if the sub is working correctly. If you'd like to execute this function, use `ros2 launch ros2_ws/launch/launch_prelim.py`.

## void pool_test()

This function is where the software user can put the commands of what they would like the sub to do in a pool test. If you'd like to execute this function, use `ros2 launch ros2_ws/launch/launch_pool_test.py`.

## void vision_test()

This function tests the vision capabilities of the sub by first submerging the sub and then aligning the sub above the bins. If you'd like to execute this function, use `ros2 launch ros2_ws/launch/launch_vision_test.py`.

## void pid_tuning_sequence()

This function was originally a movement sequence for the sub to test its axes of control for the software user to edit the PID gains (the aggressiveness of the motors) to have the sub move smoothly and accurately, though it is now deprecated in favor of `sub_control`'s new `tuning.py` node where the user can remote-control the sub.

1. Tell the AUV to maintain a depth.
2. Test various movements for PID tuning (x, y, z, yaw, continuous spinning).