`alignments.cpp` contains helper functions that usually request vision detections from sub_vision, then uses this information to align the sub with a competition object. 

# Function Key

Parameter meanings:
* int attempts: The number of detections to average.
* int task: An integer representing which task (competition object) we want to track. The mapping of which integer corresponds to which task is defined in sub_vision -> sub_vision_interfaces -> msg -> Task.msg
* int camera: An integer representing which camera to use for detecting. 0 = front cam, 1 = down cam
* float min_seconds: The min amount of seconds you want the function to operate for. 
* float max_dist: The max dist we allow the sub to travel before ending the function (to prevent traveling too far).
* float timeout: The max amount of time we allow a function to run for before we time out (to prevent getting stuck on objects).
* float thres: The accuracy threshold that we're OK with. For example, thres=0.3 would mean you're satisfied if the object is within 30% of the center of the camera image, at which point the function should terminate, provided that it's already run for the min_seconds. 

Function types:
* Requestor functions: ask sub_vision for info, then take this info and return it.
* Alignor functions: take sub_vision detections and move the sub to align with the object.
* Continuous alignor functions: same as alignor functions but repeat the process continuously in a loop for more accuracy.

# Function Breakdown

## float align(int attempts, int task, int camera)

Returns:
* float: the absolute angle the sub should turn to, to face a competition object.

Takes multiple detections and average out their angles to return the average, absolute angle to the object (for more stability/accuracy). This function does not physically move the sub, despite its name.

1. Execute a for loop to collect x amount of detections, add them to the total.
2. If all of our detections were unsuccessful, then we return an invalid angle.
3. Calculate the average angle to the object.
4. Use `angleAdd` function to turn the relative angle into an absolute angle and return it. (angleAdd makes sure that the sum is within [-180, 180] degrees.

## float relativeAlign(int attempts, int task, int camera)

Returns:
* float: the relative angle that the sub can turn to face the object.

This is the same as `align()`, except that instead of outputting the absolute angle, we output the relative angle (steps 1-3 of `align()`).

## float getOrientation(int attempts, int task, int camera)

Returns:
* float: the absolute orient (absolute angle the object is pointing to). Useful for path marker or torpedo board (to align perpendicularly to the torpedo board).

Requests orientation information from sub_vision about this task, returns the average absolute orient. Note that if you want to get orientation info about an object, you must set up the detection in sub_vision's detect.py to calculate the orientation using OpenCV or solvePNP and return it (see their torpedo board example).

## float hw_ratio(int attempts, int task, int camera)

Returns:
* float: the height/width ratio of a detection. For example, if a detected box around the object in the image is 40 pixels tall and 20 pixels wide, this returns 2.

Same as getOrientation excepts returns height/width ratio of detected box. Useful for finding when we are perpendicularly aligned to an object (eg. torp board). Usually, facing torp board head on will yield a lower hw_ratio, whereas viewing the torp board at a slanted angle from the side will yield a higher hw_ratio. Moving to the place of lowest hw_ratio allows us to align head-on with the torp board. 

## float sweepCheck(int attempts, int task, int camera)

Returns:
* float: the absolute angle that the sub can orient to to face the object.

This function tries to look for a competition object, and if it can't find it, it will turn left and right to look for it. Ultimately, it will attempt to return the absolute angle to the object.

1. Set up relative angles that we can get the sub to turn to if we can't find the object.
2. Try to look for the object. If we find it, then return the angle to the object. If we can't find it, then turn to the next search angle.
3. If all of our search angles failed, then return an invalid angle. If we found the object, then return that absolute angle. 

## float forwardSweepCheck(int attempts, int task, int camera, int num_sweeps)

Returns:
* float: the absolute angle that the sub can orient to to face the object.

Same as sweep check, except if it can't find it on the first sweep, it'll move forward and sweep again until it can find it.

1. Sweep check for the object.
2. If we find the object, return the absolute angle to it. If we don't, move forward and sweep again. Repeat until we find it or we run out of sweeps.
3. If all of our sweeps failed, then return an invalid angle.

## float distance(int attempts, int task, int camera)

Returns:
* float: the distance (in meters) to the object.

This function returns the average distance to the object through multiple detections (for more stability/accuracy). Note that to get the distance, you have to set up the calculation for that object in sub_vision's detect.py, which includes providing the object's real height (see the places where it's already been written for other tasks there.)

1. Execute a for loop to collect x amount of detections, add the distances to the total.
2. If all of our detections were unsuccessful, then we return an invalid distance.
3. Calculate and return the average distance to the object.

## float distAndAlign(int attempts, int task, int camera)

*Deprecated because inaccurate. Small inaccuracies of horizontal movement can significantly disrupt the distance calculation.*

Returns:
* float: the distance (in meters) to the object.

1. Store the original state of the sub in case we want to return if the calculation is unsuccessful.
2. Find the relative angle to the object.
3. If we couldn't find the angle to the object, we stop.
4. Move horizontally (which creates a triangle with a known length, allowing us to solve for the distance).
5. Find the relative angle to the object again (to measure triangle attributes).
6. If the detection was unsuccessful, then return back to the original location and stop.
7. Do some math to figure out how much we need to move left/right to align with the object.
8. Move left/right to align with the object.
9. Calculate and return the distance to the object (using the triangles we created).

## int numInstances(int attempts, int task, int camera)

Returns:
* int: number of objects of that type (instances) in the latest camera image. Returns 0 if there were no objects it could find. 

Useful for grabbing task, to count how many objects are remaining on the table. If there were less objects than previously, that means we had a successful grab. Otherwise, we'd go back and try to grab again.

Note that you must first setup this return value in sub_vision's detect.py for your object (see where it's already been done and replicate that).

## State forwardAlign(float max_dist, int task, int camera, float timeout)

Outputs:
* State: the final state that the sub was set to be at (or if it failed, the final state of the sub).

Continuously moves the sub forward while taking numerous vision detections to readjust the trajectory through an object. Then, when the object is close enough, sets the sub to move a distance through the object specified inside the function.

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

## Coordinate downAlign(int attempts, int task, int camera)

Outputs:
* Coordinate: a Coordinate object containing the absolute x and y coordinates the sub should move to to be right above the object.

This function does not actually move the sub; it only calculates the coordinates that it should move to to be above the object with the down camera.

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

## bool isValidDistance(float dist)

This function sees if a detected/calculated distance is valid or sus.

1. If the 0 < distance < 17.5, then the distance is good. Otherwise, it's kinda sus ngl.

Inputs:
* float dist: the distance that is being checked.

Outputs:
* bool: true or false depending on whether or not the distance is valid.

## Coordinate downAlign(int attempts, int task, int camera)

This function uses the down camera and calculates the absolute coordinates that the sub needs to move to in order to align with something below it (such as the bins). (This function does not actually move the sub; it only calculates the coordinates that it should move to.)

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

## bool frontContinuousAlign(float min_seconds, int task, int camera, float thres)

Returns:
* bool: returns true or false depending on whether or not the alignment was successful.

Continuously uses offsets to move the sub horizontally and vertically simultaneously to center the object in the front camera.

1. Calculate the relative x and y offsets using information returned by sub_vision. 
3. Move to those offsets by converting relative offsets to an absolute State (position), and telling the sub to move to that position. Uses the writeState() function to avoid blocking (we don't wait for the sub to reach that position, so we can continuously readjust the setpoint while it's moving there).

## bool frontContinuousAlignAtDist(float min_seconds, int task, int camera, float thres, float desiredDist)

Returns:
* bool: returns true or false depending on whether or not the alignment was successful.

Same as frontContinuousAlign(), but it also targets the sub to move to a `desiredDist` away from the object. For example, we could call this function for the torpedo board, to be aligned with it and move to 2 meters away from it at the same time.

## bool frontContinuousOrientAlign(float min_seconds, int task, int camera, float thres)

*Work in progress*

Returns:
* bool: returns true or false depending on whether or not the alignment was successful.

Attempts to continuously move the sub to face the object (eg. torp board) perpendicularly/head-on. Work in progress because you need to setup a consistent (relative) orient calculation in sub_vision for your desired object, which we still have yet to make consistent and more accurate.

## bool perpendicularAlign(int attempts, int task, int camera)

Returns:
* bool: returns true or false depending on whether or not the alignment was successful.

Attempts to align to an object so that the sub is perpendicularly facing it (eg. torp board, to have a higher chance of successful torp firing through the hole). Does this by finding which direction has a lower hw_ratio (because lower height/width ratios of detections means you're facing it more head-on rather than from the side). Knowing the direction, we then know the sign of the orient angle from sub_vision, which we use to calculate where to move to be perpendicularly aligned with the object. Requires that you set up the (relative) orient calculation inside of sub_vision's detect.py for that object.

This function is more jank because of difficulties in getting a consistent orient calculation in sub_vision that returns a relative orient with the correct sign, which is why we need to move around first to find what sign the orient should be. Recommended to first call frontContinuousAlignAtDist() to center the object in the camera before using this function. 

## bool downContinuousAlign(float min_seconds, int task, int camera, float thres)

Returns:
* bool: returns true or false depending on whether or not the alignment was successful.

One of my favorite functions. 

Attempts to continuously move the sub to be directly above an object, centered in the down camera. Does this by using sub_vision detection info and altitude info (from dvl) to calculate relative x y offsets, and moves to those offsets in a loop. Useful for bins, path marker, grabbing tasks. 

Terminates if the object is sufficiently centered in image (thres), we timed out, or we couldn't find the object. 

This function by default centers the down camera above an object. However, if you instead want to center the ball dropper above the bins for example, you can add offsets inside this function to move the sub that way. You need to know the x and y distances (in NED coordinates) from the down camera to the apparatus you want to center, and do (calculated x offset) - (apparatus x distance to down cam), and do the same for the y offset. 

You can also offset to apparatuses by first calling this function to align the down camera, then call addCoordinate() with your relative x and y offsets to center your apparatus. 

## bool testObjIsCentered(int attempts, int task, int camera, float thres)

Returns:
* bool: true or false depending on if the object is centered in the camera within the thres. 

Not really used atm. Calculates, with sub_vision detections, if the object is sufficiently centered in the camera. 

## bool objIsCentered(float r, float c, int camera, float thres)

This function is a helper function that takes the pixels that an object was detected at and calculates if it is centered within the image or not.

1. Check to see if the object is both vertically aligned and horizontally aligned. If both are satisfied, then return true.

Inputs:
* float r: the row of the pixel of the detection (the y coordinate).
* float c: the column of the pixel of the detection (the x coordinate).
* int camera: which camera the detection should be on (FRONT, DOWN).
* float thres: the threshold of how close the object is to the center of the camera that you are OK with. For example, a threshold of 0.1 means that you want the object to be within 10% of the middle of the camera.

Outputs:
* bool: returns true or false depending on whether or not the object is centered in the camera.

## bool isValigned(float r, int camera, float thres)

This function takes in the r (row/y) coordinate of the pixel of the detection and checks if it is in the middle of the image.

1. Declare useful variables that we will edit inside of the if statements.
2. If we're using the front camera, use the front camera's parameters to calculate the middle row of the image and the number of rows outside of the middle that we are willing to accept.
3. If we're using the down camera, use the down camera's parameters to calculate the middle row of the image and the number of rows outside of the middle that we are willing to accept.
4. Calculate the lower and upper bounds of the rows outside of the middle that we are willing to accept.
5. Return true if the pixel's row is in the sweet spot, or return false if the row is outside of the sweet spot.

Inputs:
* float r: the row of the pixel of the detection (the y coordinate).
* int camera: which camera the detection should be on (FRONT, DOWN).
* float thres: the threshold of how close the object is to the center of the camera that you are OK with. For example, a threshold of 0.1 means that you want the object to be within 10% of the middle of the camera.

## bool isHaligned(float r, int camera, float thres)

This function takes in the c (column/x) coordinate of the pixel of the detection and checks if it is in the middle of the image.

1. Declare useful variables that we will edit inside of the if statements.
2. If we're using the front camera, use the front camera's parameters to calculate the middle column of the image and the number of columns outside of the middle that we are willing to accept.
3. If we're using the down camera, use the down camera's parameters to calculate the middle column of the image and the number of columns outside of the middle that we are willing to accept.
4. Calculate the lower and upper bounds of the columns outside of the middle that we are willing to accept.
5. Return true if the pixel's column is in the sweet spot, or return false if the column is outside of the sweet spot.

Inputs:
* float c: the column of the pixel of the detection (the x coordinate).
* int camera: which camera the detection should be on (FRONT, DOWN).
* float thres: the threshold of how close the object is to the center of the camera that you are OK with. For example, a threshold of 0.1 means that you want the object to be within 10% of the middle of the camera.

Outputs:
* bool: returns true or false depending on whether or not the object is centered in the camera.

## void setForward(float dist)

This function tells the sub to move forward `dist` meters and waits for the sub to reach that position.

1. Get the current state of the sub.
2. Convert a relative forward/x offset to absolute coordinates.
3. Move to the desired location.

Inputs:
* float dist: the number of meters that you want the sub to move forward.

## void setHorizontal(float dist)

This function tells the sub to move horizontally `dist` meters and waits for the sub to reach that position. Positive meters tell the sub to go right, and negative meters tell the sub to go left.

1. Get the current state of the sub.
2. Convert a relative horizontal/y offset to absolute coordinates.
3. Move to the desired location.

Inputs:
* float dist: the number of meters that you want the sub to move horizontally.

## void setForwardAtDepth(float dist, float depth)

This function tells the sub to move forward `dist` meters at `depth` meters below the surface.

1. Tell the sub to stop maintaining distance above the floor and instead maintain depth from the surface.
2. Get the current state of the sub.
3. Convert a relative forward/x offset to absolute coordinates.
4. Set the depth of the desired location
5. Move to the desired location.

Inputs:
* float dist: the number of meters that you want the sub to move forward.
* float depth: the number of meters below the surface that you want the sub to move at.

## void setHorizontalAtDepth(float dist, float depth)

This function tells the sub to move horizontally `dist` meters at `depth` meters below the surface. Positive `dist` moves the sub to the right, whereas negative `dist` moves the sub to the left.

1. Tell the sub to stop maintaining distance above the floor and instead maintain depth from the surface.
2. Get the current state of the sub.
3. Convert a relative horizontal/y offset to absolute coordinates.
4. Set the depth of the desired location
5. Move to the desired location.

Inputs:
* float dist: the number of meters that you want the sub to move horizontally.
* float depth: the number of meters below the surface that you want the sub to move at.

## void setAngle(float angle)

This function tells the sub to turn to an absolute angle. (The difference between absolute and relative angles is that 90 absolute degrees means 90 degrees from the origin/the sub's initial state when it powered on, whereas 90 relative degrees means 90 degrees from the sub's current position.)

1. Get the sub's current state.
2. Set the absolute yaw that we want to turn to.
3. Move to that desired state.

Inputs:
* float angle: the absolute angle that we want the sub to turn to.


## void addAngle(float angle)

This function tells the sub to turn `angle` degrees from its current position. (The difference between absolute and relative angles is that 90 absolute degrees means 90 degrees from the origin/the sub's initial state when it powered on, whereas 90 relative degrees means 90 degrees from the sub's current position.)

1. Get the sub's current state.
2. Calculate the absolute yaw that we want to turn to using the relative angle.
3. Move to that desired state.

Inputs:
* float angle: the relative angle that we want to turn the sub.

## void writeDepth(float depth)

This function tells the sub to move to a certain depth from the surface without waiting for the sub to actually get to that position.

1. Format desired depth into string message.
2. Transfer string message to sub_control, which sends it to Nautical on the Atmega to move to that depth.

Inputs:
* float depth: the depth from the surface that we want the sub to move to.

## void writeAltitude(float altitude)

This function tells the sub to move to a certain altitude above the floor waiting for the sub to actually get to that position.

1. Format desired altitude into string message.
2. Transfer string message to sub_control, which sends it to Nautical on the Atmega to move to that altitude.

Inputs:
* float altitude: the altitude from the surface that we want the sub to move to.

## void setDepth(float depth, float acceptable_error)

This function tells the sub to move to a certain depth from the surface and waits for the sub to get there.

1. Tell Nautical to move to that depth.
2. Wait until we are close enough to the desired depth. When we are close enough, the function automatically finishes.

Inputs:
* float depth: the depth from the surface that we want the sub to move to.
* float acceptable_error: the number of meters from the desired depth that we are OK with the sub being at. (The default is 0.75 meters.)

## void setAltitude(float altitude, float acceptable_error)

This function tells the sub to move to a certain altitude above the floor and waits for the sub to get there.

1. Tell Nautical to move to that altitude.
2. Wait until we are close enough to the desired altitude. When we are close enough, the function automatically finishes.

Inputs:
* float altitude: the altitude above the floor that we want the sub to move to.
* float acceptable_error: the number of meters from the desired altitude that we are OK with the sub being at. (The default is 0.75 meters.

## void continuousSpin(float degrees_to_spin)

This function controls the sub to continuously spin in place for `degrees_to_spin` degrees. It achieves this affect by continuously telling the sub to turn 90 degrees from its current position in a while loop (without blocking), which makes the sub continuously turn (like a holding a carrot in front of a pig in Minecraft to have the pig continuously move forward). Negative `degrees_to_spin` results in the sub spinning left.

1. Record the original state of the sub so that we can return to it later.
2. Set up the `prev_angle` variable that will be useful later to calculate how many degrees we have already spun.
3. Set up the `total_degrees_turned` variable to track how much we have already spun.
4. Start the loop that holds the carrot in front of the pig.
5. Get the current absolute yaw of the sub.
6. Calculate how much the sub has spun since the last iteration and add it to the total degrees that we have spun.
7. Update `prev_angle` to our current yaw to set up the angle calculation in the next iteration.
8. If we are close enough to the amount of degrees to spin, or if we have spun over the desired amount, then spin to the the final yaw position and move back to the original xy position of the sub (in case the sub has moved out of position after spinning) at the same time.
9. Otherwise, continue the loop by telling the sub to turn 90 degrees from its current position (without blocking).
10. Sleep for a bit so that we don't overload the Atmega's serial connection.
11. Repeat steps 5-10 until we have spun enough.

Inputs:
* float degrees_to_spin: the number of degrees that we want the sub to spin.

## bool isValidAngle(float angle)

This function sees if the inputted angle is valid or sus.

1. If the angle is between -240 and 240 degrees, then it's good so return true. Otherwise, it's sus and the function will return false. (The range is not between -360 and 360 because we only use -180 to 180.)

Inputs:
* float angle: the angle that we want to check the validity of.

## void setCoordinate(Coordinate coordinate)

This function tells the sub to move to the user's inputted absolute coordinates (coordinates measured from the origin).

1. Get the sub's current state.
2. Set the destination with the user's coordinates.
3. Move to those coordinates (the `move` function waits until the sub arrives, then the code continues).

Inputs:
* Coordinate coordinate: the coordinate object that contains attributes `x` and `y` constituting a set of coordinates.

## void addCoordinate(Coordinate coordinate)

This function tells the sub to move to the user's inputted relative coordinates (coordinates measured from the sub's current position).

1. Get the sub's current state.
2. Convert the relative coordinates into absolute coordinates.
3. Move to the absolute coordinates (the `move` function waits until the sub arrives, then the code continues).

Inputs:
* Coordinate coordinate: the Coordinate object that contains attributes `x` and `y` constituting a set of coordinates.

## bool isValidCoordinate(Coordinate coordinate)

This function checks to see if a pair of absolute coordinates are legit or sus.

1. If both the x and y coordinates are within -50 and 50 meters, then the coordinates are good so return true. Otherwise, the function will return false.

Inputs:
* Coordinate coordinate: the Coordinate object that containing attributes `x` and `y` that are going to be checked.

## bool isValidOffsetCoordinate(Coordinate coordinate)

This function checks to see if a pair of relative coordinates are legit or sus.

1. If both the x and y coordinates are within -7 and 7 meters, then the coordinates are good so return true. Otherwise, the function will return false.

Inputs:
* Coordinate coordinate: the Coordinate object that containing attributes `x` and `y` that are going to be checked.

## void warmupInference(int attempts, int task, int camera)

This function makes a request to detect the user-specified object. This will warmup the ML model to have the ML model to reach a zone and increase its speed in later inferences.

1. Detect the object.
2. Repeat step 1 for the user-specified amount of `attempts`.

Inputs:
* int attempts: the number of detections you want to have the model run.
* int task: the object you want to detect (Task::GATE_ML, Task::BOUY_ML, etc. (see sub_vision_interfaces/msg/Task.msg for all the values)).
* int camera: which camera the detection should be on (FRONT, DOWN).

## void disableAltitudeControl()

This function tells Nautical to stop maintaining the depth from the bottom and instead maintain depth from the surface.

1. Set an invalid depth from the bottom to force Nautical to maintain depth from the surface.
2. Wait for the changes to take effect.

## void dropBalls()

This function tells Nautical to drop the balls (markers), usually used to drop the balls into the bins.

1. Tell the first dropper to open, and wait for it to open.
2. Tell the second dropper to open, and wait for it to open.
3. Tell the first dropper to close.
4. Tell the second dropper to close.
5. Wait for the droppers to close.
6. Repeat steps 1-5 again to make sure that we drop the balls.

## void move(const State dest)

This function tells the sub to move to the user-specified state, and it waits until the sub reaches the destination before terminating the itself. Note: This function does not wait for the sub to reach a z coordinate, as we normally set our depth using `setDepth` with depth being measured from the bottom.

1. Tell Nautical to move towards the user-specified state.
2. Set up the `quit` variable to be false to not quit the function yet.
3. Get the sub's current state.
4. If the sub is 0.5 meters away from its desired x coordinate, 0.5 meters away from its desired y coordinate, or 3 degrees away from its desired yaw angle, then sleep.
5. Otherwise, this means that we are close enough to the desired state, so we can set `quit` to true to escape the while loop and terminate the function.

Inputs:
* const State dest: the destination state (absolute coordinates) that we want the sub to move to.

## void write_state(const State dest)

This function transfers a desired state setpoint (x, y, z, yaw, pitch, roll) to Nautical for Nautical to move toward that state. Note that it sends -1 for the z value, indicating to Nautical that we do not want to change the current depth setpoint; if you want to change depth, use the `setDepth` or `writeDepth` functions. 

1. Format the desired setpoint into a string message.
2. Send that string message over to sub_control, which sends it to Nautical on the Atmega.

Inputs:
* const State dest: the destination state (absolute coordinates) that we want the sub to move to.