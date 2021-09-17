`sub_control` is the package that handles interfacing with the sub's low level control systems. It uses a serial UART connection to the submarine's Atmega2560 to control the sub and get position/state estimates.

`sub_control` is written in Python for simplicity.

## Structure

There are 2 main directories:
- `sub_control`, which contains the main Python code
- `sub_control_interfaces`, which contains the ROS2 .msg interface files

### The Interface Files
`sub_control` is a ROS package that contains a `control_service` ROS node, which
publishes data and serves requests on the ROS DDS (Data Distribution System).
Other nodes, such as `sub_mission`, make requests to specific *topics* using
a shared set of service request messages and subscribe to data using a shared
set of data messages. The format of these service and data messages are specified
under `sub_control_interfaces`.

Under `sub_control_interfaces`, you will find:
- `CMakeLists.txt` (build configuration)
- `package.xml` (ROS package metadata, e.g. name and stuff)
- `msg/` (the publish/subscribe messages used to communicate with sub_control)
- `srv/` (the service request/response messages used to communicate with sub_control)

#### Editing the Interface Files

You may at some point want to edit, add or remove interface files (either the pubsub
messages, or the service client messages) from the sub control interfaces.
Here's how to do it:

1. If it's a pubsub message, go to `msg/`. If it's a service message, go to `srv/`.
2. Create a new file with the name of your message and the appropriate extension. Fill out the format of the message in the file. See existing message definitions for reference. If you are familiar with UAVCAN, the format should be very familiar (just a different
extension, and no @sealed). [Docs on the format can be found here](https://docs.ros.org/en/foxy/Concepts/About-ROS-Interfaces.html).
3. Once you have created your message, go to `CMakeLists.txt` and add your file to the
list of files to compile.
1. Recompile the project with `colcon build` inside the `BB/ros2_ws` directory.
2. It's ready for use! See [this tutorial](https://docs.ros.org/en/foxy/Tutorials/Writing-A-Simple-Cpp-Service-And-Client.html) for an example of how to use the new messages in C++, and [this tutorial](https://docs.ros.org/en/foxy/Tutorials/Writing-A-Simple-Py-Service-And-Client.html) for how to use it in Python.

### The sub_control module

The actual `sub_control` module is very simple. It consists of 3 files inside the `sub_control` Python package:
- `service.py`
- `atmega.py`
- `util.py`

There is also a separate `tuning.py`, which contains a GUI used for PID tuning.

`atmega.py` is a simple Python class which holds a connection to either a UART
handle over PySerial (in an actual sub run), or input/output file handles to
a text file (in sim mode). It commands the sub by writing command strings out to
the handle; the command strings are specified in [Nautical](https://github.com/avbotz/Nautical). The code interfaces to both the Atmega2560, which handles sub location and movement,
and the Hydrophones FPGA processor, which handles octagon location estimation.

`service.py` handles passing between ROS service requests and the Atmega interface. It should be relatively self explanatory, but it creates services (e.g. `control_alive`, `control_write`) that trigger callback functions, which in turn trigger atmega functions.

`util.py` contains a few convenience functions, e.g. bodyToInertial which transforms
sub coordinates to global coordinates, used in atmega.py to calculate angles.

`tuning.py` creates a GUI using [RQT](http://wiki.ros.org/rqt), which sends messages
to the control service to write new PID tuning parameters.


## Questions
Any questions about sub_control can be directed to [vwangsf@gmail.com](mailto:vwangsf@gmail.com).
