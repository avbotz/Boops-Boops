`scans.cpp` contains helper functions that move the sub around to scan around until it can find a specified object.

Same parameter conventions as the alignment functions (see alignment.cpp docs). I will not be explaining those parameters in each function here for the sake of brevity.

## bool searchPatternScan(int attempts, int task, int camera, float movement_dist)

Parameters:
* float movement_dist: How far the sub should move in between each search pattern spot.

Returns:
* bool: true or false depending on if we found the object or not.

Moves the sub in a square search pattern, to search for an object. If it finds the object, it will return true and stop moving. Usually used to scan for objects on the floor like bins.

## bool forwardScan(int attempts, int task, int camera, float forward_m_s, float max_dist)

Parameters:
* float forward_m_s: The forward velocity to move at while scanning.
* float max_dist: The maximum amount of distance we allow this function to travel before we give up, stop moving, and terminate the function.

Returns:
* bool: true or false depending on if we found the object or not.

Moves the sub forward until it can see an object, at which point it will stop moving and return true. If it can't find the object, it will stop when it hits the max_dist and return false.

Can be used for bins, moving forward from the path marker until bins come into view for example.