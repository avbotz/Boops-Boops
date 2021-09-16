`commands.cpp` contains helper functions that assist in moving the sub through the competition course in `tasks.cpp`. See the beginning of `tasks.cpp` for clearing up some aspects of the code.

## Function Breakdown

#### float align(int attempts, Task task, int camera)

This function returns the angle to a competition object, as it can take multiple detections and average out their angles to return the average angle to the object (for more stability/accuracy). This function does not physically move the sub, despite its name.

1. Execute a for loop to collect x amount of detections, add them to the total.
2. If all of our detections were unsuccessful, then we return an invalid angle.
3. Calculate the average angle to the object.
4. Use `angleAdd` function to turn the relative angle into an absolute angle and return it. (angleAdd makes sure that the sum is within [-180, 180] degrees.

Inputs:
* int attempts: The number of detections you want to use to find the average angle to the object.
* Task task: The object you want to detect (Task::GATE, Task::GATE_ML, Task::BINS, Task::BINS_ML, Task::TARGET, Task::TARGET_ML, Task::SECOND_TARGET, Task::SECOND_TARGET_ML).
* int camera: Which camera the detection should be on (FRONT, DOWN).

Outputs:
* float: The absolute angle that the sub can orient to to face the object.

#### float relativeAlign(int attempts, Task task, int camera)

This is the same as `align()`, except that instead of outputting the absolute angle, we output the relative angle (steps 1-3 of `align()`).

Inputs:
* int attempts: The number of detections you want to use to find the average angle to the object.
* Task task: The object you want to detect (Task::GATE, Task::GATE_ML, Task::BINS, Task::BINS_ML, Task::TARGET, Task::TARGET_ML, Task::SECOND_TARGET, Task::SECOND_TARGET_ML).
* int camera: Which camera the detection should be on (FRONT, DOWN).

Outputs:
* float: The relative angle that the sub can orient to to face the object.

#### float sweepCheck(int attempts, Task task, int camera)

This function tries to look for a competition object, and if it can't find it, it will turn left and right to look for it. Ultimately, it will attempt to return the absolute angle to the object.

1. Set up relative angles that we can get the sub to turn to if we can't find the object.
2. Try to look for the object. If we find it, then return the angle to the object. If we can't find it, then turn to the next search angle.
3. If all of our search angles failed, then return an invalid angle.

Inputs:
* int attempts: The number of detections you want to use to find the average angle to the object.
* Task task: The object you want to detect (Task::GATE, Task::GATE_ML, Task::BINS, Task::BINS_ML, Task::TARGET, Task::TARGET_ML, Task::SECOND_TARGET, Task::SECOND_TARGET_ML).
* int camera: Which camera the detection should be on (FRONT, DOWN).

Outputs:
* float: The absolute angle that the sub can orient to to face the object.

#### float forwardSweepCheck(int attempts, Task task, int camera, int num_sweeps)

This function tries to look for a competition object, and if it can't find it, it will turn left and right to look for it. If it still can't find it on the first sweep, it will move forward and sweep again. Ultimately, it will attempt to return the absolute angle to the object.

1. Sweep check for the object.
2. If we find the object, return the absolute angle to it.
3. If all of our sweeps failed, then return an invalid angle.

Inputs:
* int attempts: The number of detections you want to use to find the average angle to the object.
* Task task: The object you want to detect (Task::GATE, Task::GATE_ML, Task::BINS, Task::BINS_ML, Task::TARGET, Task::TARGET_ML, Task::SECOND_TARGET, Task::SECOND_TARGET_ML).
* int camera: Which camera the detection should be on (FRONT, DOWN).
* int num_sweeps: The number of total sweeps the sub should do to look for the object. (If `num_sweeps = 4`, then it will sweep 4 times, moving forward 3 times.)

Outputs:
* float: The absolute angle that the sub can orient to to face the object.

#### float distance(int attempts, Task task, int camera)

This function returns the distance to a competition object, as it can take multiple detections and average out their distances to return the average distance to the object (for more stability/accuracy). 

1. Execute a for loop to collect x amount of detections, add the distances to the total.
2. If all of our detections were unsuccessful, then we return an invalid distance.
3. Calculate the average distance to the object.

Inputs:
* int attempts: The number of detections you want to use to find the average distance to the object.
* Task task: The object you want to detect (Task::GATE, Task::GATE_ML, Task::BINS, Task::BINS_ML, Task::TARGET, Task::TARGET_ML, Task::SECOND_TARGET, Task::SECOND_TARGET_ML).
* int camera: Which camera the detection should be on (FRONT, DOWN).

Outputs:
* float: The distance (in meters) to the object.

#### float distAndAlign(int attempts, Task task, int camera)

This function returns the distance to a competition object, but instead of relying on the distance from detections, we move the sub and use math to calculate the distance. However, even though it is hella cool and looks aesthetic in the simulator, this method is deprecated because small inaccuracies of horizontal movement can significantly disrupt the distance calculation.

1. Store the original state of the sub in case we want to return if the calculation is unsuccessful.
2. Find the relative angle to the object.
3. If we couldn't find the angle to the object, we stop.
4. Move horizontally (which creates a triangle with a known length, allowing us to solve for the distance).
5. Find the relative angle to the object again (to measure triangle attributes).
6. If the detection was unsuccessful, then return back to the original location and stop.
7. Do some math to figure out how much we need to move left/right to align with the object.
8. Move left/right to align with the object.
9. Calculate and return the distance to the object (using the triangles we created).

Inputs:
* int attempts: The number of detections you want to use to find the average angle to the object.
* Task task: The object you want to detect (Task::GATE, Task::GATE_ML, Task::BINS, Task::BINS_ML, Task::TARGET, Task::TARGET_ML, Task::SECOND_TARGET, Task::SECOND_TARGET_ML).
* int camera: Which camera the detection should be on (FRONT, DOWN).

Outputs:
* float: The distance (in meters) to the object.

#### bool isValidDistance(float dist)

This function sees if a detected/calculated distance is valid or sus.

1. If the 0 < distance < 17.5, then the distance is good. Otherwise, it's kinda sus ngl.

Inputs:
* float dist: The distance that is being checked.

Outputs:
* bool: true or false depending on whether or not the distance is valid.

#### State forwardAlign(float max_dist, Task task, int camera, float timeout)

This function continuously moves the sub forward while taking numerous vision detections to readjust the trajectory to an object. Then, when the object is close enough, this function sets the sub to move 2 meters through the object.

1. Record the time when we started so that we can tell later how much time has elapsed inside of the function.
2. Record the initial state of the AUV to later calculate how much distance we have moved.
3. Record the current state to calculate how much we have traveled so far.
4. Record how many seconds have elapsed since the start of the function.
5. If we traveled too far, or if we have gone over the time limit, stop the function.
6. Detect the object.
7. If the object is within three meters, tell the sub to move 2 meters through it, and return the last point we set the sub to move to (which stops the function).
8. Calculate the angle we need to be at to face the object if the detection is valid.
9. Calculate the trajectory that we need to follow and tell the sub to move to that point.
10. Repeat steps 3-9 until we've traveled through the object, we took too long, or we traveled too far.
11. If we took too long or traveled too far, return the current state of the sub.

Inputs:
* float max_dist: The maximum distance we allow the sub to travel from where the function was called (so we don't have the sub moving like 100 meters forward and crashing into the wall if it can't find the object).
* Task task: The object you want to detect (Task::GATE, Task::GATE_ML, Task::BINS, Task::BINS_ML, Task::TARGET, Task::TARGET_ML, Task::SECOND_TARGET, Task::SECOND_TARGET_ML).
* int camera: Which camera the detection should be on (FRONT, DOWN).
* float timeout: The maximum number of seconds you want the function to run for (so we don't wait for 20 minutes if the sub gets stuck somewhere and can't move forward).

Outputs:
* State: The final state that the sub was set to be at (or if it failed, the final state of the sub).

#### Coordinate downAlign(int attempts, Task task, int camera)

This function uses the down camera and calculates the coordinates that the sub needs to move to in order to align with something below it (such as the bins). (This function does not actually move the sub; it only calculates the coordinates that it should move to.)

1. Set up some variables (eg. x_avg, which is the average x coordinate that we will return later along with the y coordinate).
2. Record the sub's current state.
3. Find the distance to the object (this is done using `control_client::depth()`, which returns the distance from the floor or an object directly below the sub to the sub.
4. Detect the object.
5. If the detection is valid, then we continue.
6. Calculate the relative x and y offsets that we need to move to to get above the object.
7. If we are detecting the bins, then edit the offsets so that we align the dropper to the object instead of the down camera.
8. Convert relative offsets to absolute coordinates, and add them to the total (that we will average later).
9. Repeat steps 2-8 until we have attempted the amount of detections that the user has asked for.
10. If we had no successful detections, then return invalid coordinates.
11. Average the x and y coordinates and return the averages.

Inputs:
* int attempts: The number of detections you want to use to find the average coordinates of the object.
* Task task: The object you want to detect (Task::GATE, Task::GATE_ML, Task::BINS, Task::BINS_ML, Task::TARGET, Task::TARGET_ML, Task::SECOND_TARGET, Task::SECOND_TARGET_ML).
* int camera: Which camera the detection should be on (FRONT, DOWN).

Outputs:
* Coordinate: The absolute x and y coordinates of the object under the sub.

#### bool frontContinuousAlign(float min_seconds, Task task, int camera, float thres)

This function continuously aligns the sub to an object in front of it, except instead of using angles and turning the sub to align, it uses offsets to move the sub horizontally and vertically to align. 

1. Vertically align the sub to the object (so the object and the sub are at the same z).
2. Horizontally align the sub to the object (so the object is right in front of it).
3. Return true if we successfully aligned, or return False if it was unsuccessful.

Inputs: 
* float min_seconds: The minimum amount of seconds that you want the sub to vertically align and horizontally align (the minimum seconds applies to each one, not both combined).
* Task task: The object you want to detect (Task::GATE, Task::GATE_ML, Task::BINS, Task::BINS_ML, Task::TARGET, Task::TARGET_ML, Task::SECOND_TARGET, Task::SECOND_TARGET_ML).
* int camera: Which camera the detection should be on (FRONT, DOWN).
* float thres: The threshold of how close the object is to the center of the camera that you are OK with. For example, a threshold of 0.1 means that you want the object to be within 10% of the middle of the camera.

Outputs:
* bool: Returns true or false depending on whether or not the alignments were successful.

#### bool frontContinuousValign(float min_seconds, Task task, int camera, float thres)

This function continuously calls for detections to vertically readjust the sub so that it is at the same z as the detected object.

1. Set up some useful variables (eg. max_seconds sets the timeout at 30 seconds).
2. Warmup the ML model so that the warming up speed does not factor into our timing to see how long the function has taken.
3. Record the starting time to later see how many seconds have elapsed.
4. Record the current state of the sub.
5. Detect the object.
6. If the detected distance to the object is invalid, then we'll just assume the distance is 4 meters.
7. If the detection is valid, continue.
8. If we have continuously aligned for past the minimum time requirement and the object is vertically aligned, then hold the current depth and stop the function.
9. Calculate the offset we need to move the sub vertically for it to be on the same z plane as the object.
10. Adjust the sub's depth to align with the object.
11. If the earlier detection wasn't valid, then we record that (if we failed too many times, then we stop the function because it means the object probably wasn't in view).
12. If we took too long, then stop the function.
13. Repeat steps 4-12 until the object is aligned or until we have taken too long.
14. If the alignment was unsuccessful (couldn't detect the object, or we took too long), return false.

Inputs: 
* float min_seconds: The minimum amount of seconds that you want the sub to vertically align (the minimum seconds applies to each one, not both combined).
* Task task: The object you want to detect (Task::GATE, Task::GATE_ML, Task::BINS, Task::BINS_ML, Task::TARGET, Task::TARGET_ML, Task::SECOND_TARGET, Task::SECOND_TARGET_ML).
* int camera: Which camera the detection should be on (FRONT, DOWN).
* float thres: The threshold of how close the object is to the center of the camera that you are OK with. For example, a threshold of 0.1 means that you want the object to be within 10% of the middle of the camera.

Outputs:
* bool: Returns true or false depending on if the alignment was successful or not.

#### bool frontContinuousHalign(float min_seconds, Task task, int camera, float thres)

This function continuously calls for detections to horizontally readjust the sub so that it is directly facing the object straight on.

1. Set up some useful variables (eg. max_seconds sets the timeout at 30 seconds).
2. Warmup the ML model so that the warming up speed does not factor into our timing to see how long the function has taken.
3. Record the starting time to later see how many seconds have elapsed.
4. Record the current state of the sub.
5. Detect the object.
6. If the detected distance to the object is invalid, then we'll just assume the distance is 4 meters.
7. If the detection is valid, continue.
8. If we have continuously aligned for past the minimum time requirement and the object is horizontally aligned, then hold the current position and stop the function.
9. Calculate the offsets we need to move the sub horizontally for it to be directly in front of the object.
10. Adjust the sub's position to align with the object.
11. If the earlier detection wasn't valid, then we record that (if we failed too many times, then we stop the function because it means the object probably wasn't in view).
12. If we took too long, then stop the function.
13. Repeat steps 4-12 until the object is aligned or until we have taken too long.
14. If the alignment was unsuccessful (couldn't detect the object, or we took too long), return false.

Inputs: 
* float min_seconds: The minimum amount of seconds that you want the sub to horizontally align (the minimum seconds applies to each one, not both combined).
* Task task: The object you want to detect (Task::GATE, Task::GATE_ML, Task::BINS, Task::BINS_ML, Task::TARGET, Task::TARGET_ML, Task::SECOND_TARGET, Task::SECOND_TARGET_ML).
* int camera: Which camera the detection should be on (FRONT, DOWN).
* float thres: The threshold of how close the object is to the center of the camera that you are OK with. For example, a threshold of 0.1 means that you want the object to be within 10% of the middle of the camera.

Outputs:
* bool: Returns true or false depending on if the alignment was successful or not.

#### bool frontConsecutiveAngleAlign(int attempts, Task task, int camera)

This function takes the angle to an object, turns towards the object, and repeats that process a user-specified amount of times. (This function is if you want to be extra careful that you aligned correctly.)

1. Get the angle to the object.
2. If the angle is valid, then turn towards the object; otherwise, return false.
3. Repeat steps 1-2 until we have attempted the amount of times that the user specified.
4. Return false if our alignment was unsuccessful (if any angle was every invalid).

Inputs:
* int attempts: The number of detections you want to use to find the average angle to the object. In this case, also the amount of times you want to turn towards the object.
* Task task: The object you want to detect (Task::GATE, Task::GATE_ML, Task::BINS, Task::BINS_ML, Task::TARGET, Task::TARGET_ML, Task::SECOND_TARGET, Task::SECOND_TARGET_ML).
* int camera: Which camera the detection should be on (FRONT, DOWN).

Outputs:
* bool: Returns true or false depending on whether or not the consecutive alignment was successful.

#### bool downContinuousAlign(float min_seconds, Task task, int camera, float thres)

This function continuously calculates the offsets to align with an object underneath the sub and readjusts the sub's position to move above that object. 

1. Set up some useful variables (eg. max_seconds sets the timeout at 30 seconds).
2. Warmup the ML model so that the warming up speed does not factor into our timing to see how long the function has taken.
3. Record the starting time to later see how many seconds have elapsed.
4. Record the current state of the sub.
5. Get the distance to the object (which is the distance to the floor/anything right below the sub, which is why we use `control_client::depth()`.
6. Detect the object.
7. If the detection is valid, continue.
8. If we have continuously aligned for past the minimum time requirement and the object is aligned, then stop the function.
9. Calculate the offsets we need to move the sub for it to be directly above the object.
10. If we are trying to align on top of the bins, then adjust the offset values so that we align the ball dropper instead of the down camera.
11. Convert relative offsets to absolute coordinates, and set the sub to move to those coordinates.
12. If the earlier detection wasn't valid, then we record that (if we failed too many times, then we stop the function because it means the object probably wasn't in view).
13. If we couldn't detect the object with 5 tries or took too long, then stop the function.
14. Repeat steps 4-13 until the object is aligned, we have taken too long, or we couldn't find the object with numerous tries.
15. If the alignment was unsuccessful (couldn't detect the object, or we took too long), return false.

Inputs: 
* float min_seconds: The minimum amount of seconds that you want the sub to align for.
* Task task: The object you want to detect (Task::GATE, Task::GATE_ML, Task::BINS, Task::BINS_ML, Task::TARGET, Task::TARGET_ML, Task::SECOND_TARGET, Task::SECOND_TARGET_ML).
* int camera: Which camera the detection should be on (FRONT, DOWN).
* float thres: The threshold of how close the object is to the center of the camera that you are OK with. For example, a threshold of 0.1 means that you want the object to be within 10% of the middle of the camera.

Outputs:
* bool: Returns true or false depending on if the alignment was successful or not.

#### bool testObjIsCentered(int attempts, Task task, int camera, float thres)

This function uses the vision system to test if an object is centered in front of the sub's front or down camera.

1. Set up some useful variables (eg. avg_r will eventually be used to record the average row of the pixel that the object was detected at).
2. Detect the object.
3. If the detection is valid, add the pixel coordinates to the total. Otherwise, record that it was an invalid attempt (enough invalid attempts will trigger the function to stop).
4. Repeat steps 2-3 until we have attempted the number of attempts that the user specified.
5. Calculate the average coordinates of the detected object in the camera.
6. If the object is centered satisfactorily within the threshold, then return true. Otherwise, return false.

Inputs: 
* int attempts: The number of detections you want to use to find the average angle to the object.
* Task task: The object you want to detect (Task::GATE, Task::GATE_ML, Task::BINS, Task::BINS_ML, Task::TARGET, Task::TARGET_ML, Task::SECOND_TARGET, Task::SECOND_TARGET_ML).
* int camera: Which camera the detection should be on (FRONT, DOWN).
* float thres: The threshold of how close the object is to the center of the camera that you are OK with. For example, a threshold of 0.1 means that you want the object to be within 10% of the middle of the camera.

Outputs:
* bool: Returns true or false depending on whether or not the object is centered in the camera.

#### bool objIsCentered(float r, float c, int camera, float thres)

This function is a helper function that takes the pixels that an object was detected at and calculates if it is centered within the image or not.

1. Check to see if the object is both vertically aligned and horizontally aligned. If both are satisfied, then return true.

Inputs:
* float r: The row of the pixel of the detection (the y coordinate).
* float c: The column of the pixel of the detection (the x coordinate).
* int camera: Which camera the detection should be on (FRONT, DOWN).
* float thres: The threshold of how close the object is to the center of the camera that you are OK with. For example, a threshold of 0.1 means that you want the object to be within 10% of the middle of the camera.

Outputs:
* bool: Returns true or false depending on whether or not the object is centered in the camera.

#### bool isValigned(float r, int camera, float thres)

This function takes in the r (row/y) coordinate of the pixel of the detection and checks if it is in the middle of the image.

1. Declare useful variables that we will edit inside of the if statements.
2. If we're using the front camera, use the front camera's parameters to calculate the middle row of the image and the number of rows outside of the middle that we are willing to accept.
3. If we're using the down camera, use the down camera's parameters to calculate the middle row of the image and the number of rows outside of the middle that we are willing to accept.
4. Calculate the lower and upper bounds of the rows outside of the middle that we are willing to accept.
5. Return true if the pixel's row is in the sweet spot, or return false if the row is outside of the sweet spot.

Inputs:
* float r: The row of the pixel of the detection (the y coordinate).
* int camera: Which camera the detection should be on (FRONT, DOWN).
* float thres: The threshold of how close the object is to the center of the camera that you are OK with. For example, a threshold of 0.1 means that you want the object to be within 10% of the middle of the camera.

#### bool isHaligned(float r, int camera, float thres)

This function takes in the c (column/x) coordinate of the pixel of the detection and checks if it is in the middle of the image.

1. Declare useful variables that we will edit inside of the if statements.
2. If we're using the front camera, use the front camera's parameters to calculate the middle column of the image and the number of columns outside of the middle that we are willing to accept.
3. If we're using the down camera, use the down camera's parameters to calculate the middle column of the image and the number of columns outside of the middle that we are willing to accept.
4. Calculate the lower and upper bounds of the columns outside of the middle that we are willing to accept.
5. Return true if the pixel's column is in the sweet spot, or return false if the column is outside of the sweet spot.

Inputs:
* float c: The column of the pixel of the detection (the x coordinate).
* int camera: Which camera the detection should be on (FRONT, DOWN).
* float thres: The threshold of how close the object is to the center of the camera that you are OK with. For example, a threshold of 0.1 means that you want the object to be within 10% of the middle of the camera.

Outputs:
* bool: Returns true or false depending on whether or not the object is centered in the camera.

#### void setForward(float dist)

This function tells the sub to move forward `dist` meters and waits for the sub to reach that position.

1. Get the current state of the sub.
2. Convert a relative forward/x offset to absolute coordinates.
3. Move to the desired location.

Inputs:
* float dist: The number of meters that you want the sub to move forward.

#### void setHorizontal(float dist)

This function tells the sub to move horizontally `dist` meters and waits for the sub to reach that position. Positive meters tell the sub to go right, and negative meters tell the sub to go left.

1. Get the current state of the sub.
2. Convert a relative horizontal/y offset to absolute coordinates.
3. Move to the desired location.

Inputs:
* float dist: The number of meters that you want the sub to move horizontally.

#### void setForwardAtDepth(float dist, float depth)

This function tells the sub to move forward `dist` meters at `depth` meters below the surface.

1. Tell the sub to stop maintaining distance above the floor and instead maintain depth from the surface.
2. Get the current state of the sub.
3. Convert a relative forward/x offset to absolute coordinates.
4. Set the depth of the desired location
5. Move to the desired location.

Inputs:
* float dist: The number of meters that you want the sub to move forward.
* float depth: The number of meters below the surface that you want the sub to move at.

#### void setHorizontalAtDepth(float dist, float depth)

This function tells the sub to move horizontally `dist` meters at `depth` meters below the surface. Positive `dist` moves the sub to the right, whereas negative `dist` moves the sub to the left.

1. Tell the sub to stop maintaining distance above the floor and instead maintain depth from the surface.
2. Get the current state of the sub.
3. Convert a relative horizontal/y offset to absolute coordinates.
4. Set the depth of the desired location
5. Move to the desired location.

Inputs:
* float dist: The number of meters that you want the sub to move horizontally.
* float depth: The number of meters below the surface that you want the sub to move at.

#### void setAngle(float angle)

This function tells the sub to turn to an absolute angle. (The difference between absolute and relative angles is that 90 absolute degrees means 90 degrees from the origin/the sub's initial state when it powered on, whereas 90 relative degrees means 90 degrees from the sub's current position.)

1. Get the sub's current state.
2. Set the absolute yaw that we want to turn to.
3. Move to that desired state.

Inputs:
* float angle: The absolute angle that we want the sub to turn to.


#### void addAngle(float angle)

This function tells the sub to turn `angle` degrees from its current position. (The difference between absolute and relative angles is that 90 absolute degrees means 90 degrees from the origin/the sub's initial state when it powered on, whereas 90 relative degrees means 90 degrees from the sub's current position.)

1. Get the sub's current state.
2. Calculate the absolute yaw that we want to turn to using the relative angle.
3. Move to that desired state.

Inputs:
* float angle: The relative angle that we want to turn the sub.

#### void setDepth(float depth, float acceptable_error)

This function tells the sub to move to a certain depth (measured from the bottom, so basically altitude).

1. Tell Nautical to move to that depth.
2. Wait until we are close enough to the desired depth. When we are close enough, the function automatically finishes.

Inputs:
* float depth: The depth (measured in meters from the bottom/floor) that we want the sub to move to.
* float acceptable_error: The number of meters from the desired depth that we are OK with the sub being at. (The default is 0.75 meters.

#### void continuousSpin(int num_rotations)

This function controls the sub to continuously spin in place for `num_rotations` amount of rotations (1 rotation is 360 degrees). It achieves this affect by continuously telling the sub to turn 90 degrees from its current position in a while loop, which makes the sub continuously turn (like a holding a carrot in front of a pig in Minecraft to have the pig continuously move forward).

1. Record the original state of the sub so that we can return to it later.
2. Set up the `prev_angle` variable that will be useful later to calculate how many degrees we have already spun.
3. Convert `num_rotations` to how many degrees we have to spin.
4. Set up the `total_degrees_turned` variable to track how much we have already spun.
5. Get the current absolute yaw of the sub.
6. Calculate how much the sub has spun since the last iteration and add it to the total degrees that we have spun.
7. Update `prev_angle` to our current yaw to set up the angle calculation in the next iteration.
8. If we are close enough to the amount of degrees to spin, or if we have spun over the desired amount, then spin back to the original yaw position and move back to the original position of the sub (in case the sub has moved out of position after spinning).
9. Otherwise, tell the sub to turn 90 degrees from its current position.
10. Sleep for a bit so that we don't overload the Atmega's serial connection.
11. Repeat steps 5-10 until we have spun enough.

Inputs:
* int num_rotations: The number of full, 360 degree rotations that we want the sub to complete. (The sub will not pause between rotations.)

#### bool isValidAngle(float angle)

This function sees if the inputted angle is valid or sus.

1. If the angle is between -240 and 240 degrees, then it's good so return true. Otherwise, it's sus and the function will return false. (The range is not between -360 and 360 because we only use -180 to 180.)

Inputs:
* float angle: The angle that we want to check the validity of.

#### void setCoordinate(Coordinate coordinate)

This function tells the sub to move to the user's inputted absolute coordinates (coordinates measured from the origin).

1. Get the sub's current state.
2. Set the destination with the user's coordinates.
3. Move to those coordinates (the `move` function waits until the sub arrives, then the code continues).

Inputs:
* Coordinate coordinate: The coordinate object that contains attributes `x` and `y` constituting a set of coordinates.

#### void addCoordinate(Coordinate coordinate)

This function tells the sub to move to the user's inputted relative coordinates (coordinates measured from the sub's current position).

1. Get the sub's current state.
2. Convert the relative coordinates into absolute coordinates.
3. Move to the absolute coordinates (the `move` function waits until the sub arrives, then the code continues).

Inputs:
* Coordinate coordinate: The Coordinate object that contains attributes `x` and `y` constituting a set of coordinates.

#### bool isValidCoordinate(Coordinate coordinate)

This function checks to see if a pair of absolute coordinates are legit or sus.

1. If both the x and y coordinates are within -50 and 50 meters, then the coordinates are good so return true. Otherwise, the function will return false.

Inputs:
* Coordinate coordinate: The Coordinate object that containing attributes `x` and `y` that are going to be checked.

#### bool isValidOffsetCoordinate(Coordinate coordinate)

This function checks to see if a pair of relative coordinates are legit or sus.

1. If both the x and y coordinates are within -7 and 7 meters, then the coordinates are good so return true. Otherwise, the function will return false.

Inputs:
* Coordinate coordinate: The Coordinate object that containing attributes `x` and `y` that are going to be checked.

#### void warmupInference(int attempts, Task task, int camera)

This function makes a request to detect the user-specified object. This will warmup the ML model to have the ML model to reach a zone and increase its speed in later inferences.

1. Detect the object.
2. Repeat step 1 for the user-specified amount of `attempts`.

Inputs:
* int attempts: The number of detections you want to have the model run.
* Task task: The object you want to detect (Task::GATE, Task::GATE_ML, Task::BINS, Task::BINS_ML, Task::TARGET, Task::TARGET_ML, Task::SECOND_TARGET, Task::SECOND_TARGET_ML).
* int camera: Which camera the detection should be on (FRONT, DOWN).

#### void disableAltitudeControl()

This function tells Nautical to stop maintaining the depth from the bottom and instead maintain depth from the surface.

1. Set an invalid depth from the bottom to force Nautical to maintain depth from the surface.
2. Wait for the changes to take effect.

#### void dropBalls()

This function tells Nautical to drop the balls (markers), usually used to drop the balls into the bins.

1. Tell the first dropper to open, and wait for it to open.
2. Tell the second dropper to open, and wait for it to open.
3. Tell the first dropper to close.
4. Tell the second dropper to close.
5. Wait for the droppers to close.
6. Repeat steps 1-5 again to make sure that we drop the balls.

#### void move(const State dest)

This function tells the sub to move to the user-specified state, and it waits until the sub reaches the destination before terminating the itself. Note: This function does not wait for the sub to reach a z coordinate, as we normally set our depth using `setDepth` with depth being measured from the bottom.

1. Tell Nautical to move towards the user-specified state.
2. Set up the `quit` variable to be false to not quit the function yet.
3. Get the sub's current state.
4. If the sub is 0.5 meters away from its desired x coordinate, 0.5 meters away from its desired y coordinate, or 3 degrees away from its desired yaw angle, then sleep.
5. Otherwise, this means that we are close enough to the desired state, so we can set `quit` to true to escape the while loop and terminate the function.

Inputs:
* const State dest: The destination state (absolute coordinates) that we want the sub to move to.