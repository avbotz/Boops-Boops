`utils.cpp.md` just has some helper functions to do some small stuff easier.

### float angle_difference()

This returns the difference between the two angles, and it makes sure that the difference is in the range of [-180, 180] degrees. Making the difference inside this range makes everything good (so we and the controllers don't get confused).

### float angle_add()

This returns the sum of the two angles, and it makes sure that the sum is within the range of [-180, 180] degrees. Making the sum inside this range makes everything good (so we and the controllers don't get confused).

### float limit()

This makes sure that the inputted value is within the lower and upper limits that were also inputted into the function. If it's less than the lower limit, it will return the lower limit, and if it is above the upper limit, it will return the upper limit. This makes sure that we don't send thruster values above the thruster's range, for example.

### float limit() (the other one)

This other definition of the limit does the same thing as the other limit function except that it only looks at the lower limit (no upper limit).

### void body_to_inertial()

This function basically converts relative coordinates (or velocities/values) into absolute values. See the documentation on this function in sub_mission or Nautical-Private since I don't feel like retyping it here.

### bool isValidValue()

Returns true if the value is valid (so that means it's not a NaN (not a number) and that it's not too big). Otherwise, this means the value is sus so we return false.

### EulerAngles ToEulerAngles()

This function takes a Quaternion (an alternative way of describing orientation) type struct (defined in some header file somewhere) and it does some calculations to convert them into Euler angles (yaw, pitch, roll). Then, it returns these Euler angle values inside a EulerAngles type object (that has the elements of yaw, pitch, roll).

### float seconds_since_start()

This function calculates the second difference/elapsed time in seconds since the clock that was passed into this function was created.

For example:
```
auto start_time = std::chrono::high_resolution_clock::now();
std::this_thread::sleep_for(5s);
float elapsed_time_in_seconds = seconds_since_start(start_time);

std::cout << elapsed_time_in_seconds << std::endl;
```
Probably prints something like:
```
5.0000000123 
```
or something idk.
```