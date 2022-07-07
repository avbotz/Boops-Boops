Launch files are what we use to launch the separate nodes inside of BB. By now, you may have read up on the documentation for each of the code packages, but you may be confused on how it all comes together. This is where launch files come in.

## Launch Files

Inside of launch files, we follow the ROS2 standard of using a Python launch file that will launch the specified node from the specified package, and the node essentially just runs the code that was defined in that node's code file. 

For example, you could create a mission node file, that will run the `service` node from sub_control, the `acquisition` node from sub_acquisition, the `vision` node from sub_vision, and the `mission` node from sub_mission. This info on how to make one, is just copy pasted from official ROS2 documentation. To launch the launch file, you would run `ros2 launch path/to/launch_file.py`, which would launch all the nodes specified. Basically, the purpose of BB is to send commands to Nautical-Private on the Arduino and process vision requests.