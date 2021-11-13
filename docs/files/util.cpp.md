`util.cpp` contains the helper functions that automates some common tasks that are called numerous times in `commands.cpp` and `tasks.cpp`. 

# Function Breakdown

## State create_state(float x, float y, float z, float yaw, float pitch, float roll)

This function creates and returns a State object that stores all of the coordinates/angles that are inputted into the function.

1. Create the State object.
2. Store the data inside of the object.
3. Return the object.

Inputs:
* float x: the absolute x coordinate that you wish to store in the State object.
* float y: the absolute y coordinate that you wish to store in the State object.
* float z: the absolute z coordinate that you wish to store in the State object.
* float yaw: the absolute yaw coordinate that you wish to store in the State object.
* float pitch: the absolute pitch coordinate that you wish to store in the State object.
* float roll: the absolute roll coordinate that you wish to store in the State object.

Outputs:
* State: the State object that stores the inputted data.

Example:
```c++
State myState = create_state(50, 12, 5, 90, 0, 0);
std::cout << "The roll value of my state is: " << myState.roll << std::endl;
```

## Coordinate create_coordinate(float x, float y)

This function creates and returns a Coordinate object that stores the (x, y) coordinates that are inputted into the function.

1. Create the Coordinate object.
2. Store the data inside of the object.
3. Return the object.

Inputs:
* float x: the x coordinate that you wish to store in the Coordinate object.
* float y: the y coordinate that you wish to store in the Coordinate object.

Outputs:
* Coordinate: the Coordinate object that stores the inputted data.

Example:
```c++
Coordinate myCoord = create_coordinate(65, 21);
std::cout << "The y value of my coordinate is: " << myCoord.y << std::endl;
```

## std::string state_to_text(State state)

This function takes in a state and formats and returns its contents in a nice string (that can later be used to print out Nemo's state, for example).

1. Create an std stringstream that makes it easy for us to create our string.
2. Set the precision to 2 so that our terminal won't be filled up with a bunch of decimal points.
3. Create the string, putting all of the parts of the state into the string.
4. Return the new string.

Inputs:
* State state: the state that you wish to format and make a string out of.

Outputs:
* std::string: the formatted string.

Example:
```c++
State state = control_client::state();
std::cout << "Current state of Nemo @ " << state_to_text(state) << std::endl;
```

Example Output:
```
Current state of Nemo @ (12.07, 2.83, 1.8, -57.55, 1.12, -2.79)
```

## std::string bool_to_text(bool x)

Takes in a boolean and converts it to a string (useful for printing things.)

1. If the bool is true, then return "true".
2. If the bool is false, then return "false".

Inputs:
* bool x: the bool that you want to convert into a string.

Outputs:
* std::string: the string version of the bool.

## void print_current_state()

Prints the current state of Nemo.

1. Gets the current state of Nemo, converts it to text, and prints it out.

## float seconds_since_start(std::chrono::time_point<std::chrono::high_resolution_clock> start_time)

Returns the seconds since a recorded starting time. (Useful for timing mission functions, eg. in `forwardAlign`.)

1. Records the current time, when the function is called.
2. Calculates the difference between the stop time and the start time.
3. Converts the difference into seconds and returns it.

Inputs:
* std::chrono::time_point<std::chrono::high_resolution_clock> start_time: the time at which you want to calculate the seconds elapsed from.

Outputs:
* float: the seconds since the inputted start time.

Example:
```c++
// Create a starting time point
auto start_time = std::chrono::high_resolution_clock::now();

// Wait 5 seconds
std::this_thread::sleep_for(5s);

// Calculate the time difference and print it
float time_difference = seconds_since_start(start_time);
std::cout << "The time difference is: " << time_difference << " seconds." << std::endl;
```

Example Output:
```
The time difference is: 5 seconds.
```

## float angleDifference(float a1, float a2)

Returns the difference between two inputted angles.

1. Subtracts the angles.
2. Standardizes the difference to be within [-180, 180] degrees.
3. Returns the difference.

Inputs:
* float a1: the reference angle.
* float a2: the angle you want to subtract from `a1`.

Outputs:
* float: the difference between the two angles (standardized between [-180, 180] degrees.)

## float angleAdd(float a1, float add)

Returns the sum of two inputted angles.

1. Adds the angles.
2. Standardizes the sum to be within [-180, 180] degrees.
3. Returns the sum.

Inputs:
* float a1: the reference angle.
* float add: the angle you want to add to `a1`.

Outputs:
* float: the sum of the two angles (standardized between [-180, 180] degrees.)

## float angleStandardize(float a)

Returns the inputted angle, but standardized between [-180, 180] degrees.

1. While the magnitude of the angle is too big, keep adjusting it until it fits into our interval.
2. Return the fixed angle.

Inputs:
* float a: the angle you want to standardize.

Outputs:
* float: the standardized angle.

Example:
```c++
float og_angle = 597.5;
float fixed_angle = angleStandardize(og_angle);
std::cout << "The new angle is: " << fixed_angle << std::endl;
```

Example Output:
```
The new angle is: -122.5
```

## void bodyToInertial(float *input, float *angles, float *output)

This function calculates and converts the sub’s relative position to absolute position, switching between non inertial and inertial frame (useful for finding our position after many rotations and transformations), with inertial meaning fixed.

1. Calculates trig functions needed to find the rotation matrix using input Euler angles.
2. Finds the rotation matrix needed for the Euler transformation to figure out where the sub is in relation to the fixed frame.
3. Multiplies the input matrix by the rotation matrix to find the projection of x, y, z on the inertial frame (absolute position).
    
Inputs:
* float *input: the pointer to an array storing the body frame coordinates: x, y, and z. These are usually relative offsets from the orientation defined by the angles variable.
* float *angles: the pointer to a matrix storing the Euler angles phi, theta, and psi (roll, pitch, and yaw, respectively) which describe the absolute orientation at which we want to add these relative offsets.
* float *output: the pointer to a vector storing the final calculated x, y, and z coordinates of the sub’s position projected onto the inertial frame. These are usually the absolute offsets.

Outputs:
* Technically none, but the outputs can be accessed through the variable that was inputted into the third slot.

Example:
```c++
// Aim to make the sub travel 2 meters in the absolute 30 degree direction, while maintaining its current orientation
float input[3] = {2., 0., 0.};
float angles[3] = {30., 0., 0.};
float output[3];

// Convert relative offsets into absolute offsets
bodyToInertial(input, angles, output);

// Add the absolute offsets to the current state
State state = control_client::state();
state.x += output[0];
state.y += output[1];

// Move to our desired destination
move(state);
```

