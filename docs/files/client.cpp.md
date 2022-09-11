`client.cpp` contains the functions that communicate with `sub_control` and `sub_vision` in order to pass data onto those nodes or request information from them. It does so by utilizing ROS2's "service-client" architecture. Essentially, the nodes from sub_control and sub_vision open services, and sub_mission can act as the client by relaying a request to them to execute some specific lines of code. When sub_control and sub_vision receive these requests, they execute that segment of code, which can either do an action or return some data back to sub_mission.

As touched on in the overview page, sub_mission connects to sub_control to relay commands for Nemo to move to a specific location to the Atmega controller or to have sub_control request data (such as Nemo's state) from the Atmega and return it to sub_mission. For sub_vision, sub_mission requests detections of specific objects, sub_vision performs those detections, and it returns information about the object such as its distance and relative angles from Nemo.

Also, the `rmw_qos_profile_custom` stuff is to set the settings of the service client to best_effort reception of responses from the service. The default is set to reliable, which automatically retries until it gets the message from the service. We set it to best_effort in the case where we use restart_node, which kills sub_mission whenever the kill switch is flipped; this can cause a message that was mid-delivery to get lost, which can later cause subsequent service client calls to continuously re-try to get that message back, which would stall the code forever. With this policy, it fixes that, but it also makes it so that you can't test services through the command line anymore (because command line defaults to reliable method).

# Function Breakdown

## bool service_client::alive()

This function sees whether or not the sub is on (if the kill switch has turned the sub on yet) and returns True or False accordingly.

1. Make the request object that we give to sub_control.
2. Initialize the response object from which we will access the data, and send the request.
3. Wait for sub_control to return the data.
4. Return the bool that we get from sub_control to wherever this function was called in sub_mission.

Outputs:
* bool: True or False depending on whether the sub is alive or not (whether it's turned on or not).

## State service_client::state()

This function asks sub_control what the current state (x, y, z, yaw, pitch, roll) of Nemo is and returns the data to wherever this function was called from in sub_mission. (Side note: sub_control accomplishes this by transferring the request over to Nautical, and since Nautical directly accesses Nemo's sensors, Nautical returns the state data to sub_control which then returns it back to sub_mission)

1. Initialize the request object that we use to send over to sub_control and the response object from which we will access the returned data, and send the request.
2. Wait for sub_control to return the data.
3. Extract the data that we got from sub_control and return in the form of a State object.

Outputs:
* State: the current position and orientation (x, y, z, yaw, pitch, roll) (measured from the origin of where Nemo was turned on in North-East-Down coordinates) of Nemo.

Example:
```c++
State state = service_client::state();
std::cout << "The current state of Nemo is: " << std::endl <<
	"x: " << state.x << std::endl << 
	"y: " << state.y << std::endl << 
	"z: " << state.z << std::endl << 
	"yaw: " << state.yaw << std::endl << 
	"pitch: " << state.pitch << std::endl << 
	"roll: " << state.roll << std::endl;
```

## float service_client::altitude()

This function asks sub_control what the current altitude of Nemo is and returns this data to wherever this function was called from in sub_mission. (The altitude is the distance to the floor.)

1. Initialize the request object that we use to send over to sub_control and the response object from which we will access the returned data, and send the request.
2. Wait for sub_control to return the data.
3. Return the data in the form of a float.

Outputs:
* float: the current altitude of Nemo.

Example:
```c++
float current_altitude = service_client::altitude();
std::cout << "The current altitude of Nemo is: " << current_altitude << " meters." << std::endl;
```

## void service_client::write(std::string input)

This function asks sub_control to relay the `input` message over to the Atmega for Nautical to execute.

1. Initialize the request object that we use to send over to sub_control.
2. Stuff the data inside of the request object so that sub_control will be able to access it.
3. Send the request and wait for its completion.

Inputs:
* std::string input: the string that contains the command that you want Nautical to execute (see Nautical's README and Nautical's main.c to see the available string commands).

Example:
```c++
// Tell Nautical to drop both of the balls (in the bin drop)
for (int i = 0; i < 2; i++)
{
	// Open ball dropper 0
	service_client::write("g 0 1\n");
	std::this_thread::sleep_for(1s);

	// Open ball dropper 1
	service_client::write("g 1 1\n");
	std::this_thread::sleep_for(3s);

	// Close both ball droppers
	service_client::write("g 0 0\n");
	service_client::write("g 1 0\n");
	std::this_thread::sleep_for(2s);
}
```

## float service_client::octagon_angle()

(If it were to be implemented) 

This function tells sub_control to ask the FPGA to calculate the angle to the octagon and return that info to sub_mission.

1. Initialize the request object that we use to send over to sub_control and the response object from which we will access the returned data, and send the request.
2. Wait for sub_control to return the data.
3. Extract the data that we got from sub_control and return it.

Outputs:
* float: the relative angle from Nemo to the octagon.

Example:
```c++
// Get the angle to the octagon
float angle = service_client::octagon_angle();

// Turn towards the octagon
addAngle(angle);
```

## Coordinate octagon_coordinates()

(If it were to be implemented)

This function tells sub_control to ask the FPGA to calculate the absolute coordinates of the octagon and return that info the sub_mission.

1. Initialize the request object that we use to send over to sub_control and the response object from which we will access the returned data, and send the request.
2. Wait for sub_control to return the data.
3. Extract the data that we got from sub_control and return it.

Outputs:
* Coordinate: the object that contains the calculated absolute (x, y) coordinates of the octagon.

Example (As of 11-21-21, the hydrophones implementation doesn't have this capability yet):
```
// Get coordinates of the octagon
Coordinate coords = service_client::octagon_coordinates();

// Travel to the octagon
setCoordinate(coords);
```

## Observation service_client::vision(int task, int camera)

This function relays a detection request from sub_mission and carries it over to sub_vision to process. It then receives the detection information from sub_vision and returns it back to wherever this function was called inside of sub_mission.

1. Wait for the service to become available (if we don't do this, sometimes the code stalls).
2. Create a request object, which holds the information that we need to pass onto sub_vision.
3. Put the info we need to pass onto sub_vision into the request object.
4. Send the request to sub_vision, wait until we receive the response, and extract the received data.
5. Return the information in the form of an Observation object back to wherever it was called in sub_mission.

Inputs:
* int task: the object you want to detect (Task::GATE, etc. - check sub_vision_interfaces/msg/Task.msg to find all of the values)
* int camera: Which camera the detection should be on (FRONT, DOWN).

Outputs:
* Observation: the object that contains the detection information gained by sub_vision.

Example:
```c++
Observation obs = service_client::vision(Task::GATE_ML, FRONT);
std::cout << "The relative horizontal angle to the gate is: " << obs.hangle << std::endl;
```

## void service_client::init_clients()

This function initializes the ROS2 client that connects to sub_control's and sub_vision's service.

1. Create a dummy node that we can use (kinda jank but there were some problems that made us do this).
2. Create the client objects that we can use to communicate with each of sub_control's and sub_vision's services.
3. Wait for each service (if we don't do this, then if we call one of the functions above, the code will stall.)