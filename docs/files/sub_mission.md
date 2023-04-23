`sub_mission` is the package that orchestrates the entire submarine; this package sends the commands to move the submarine, dive, submerge, or use the vision system to orient itself to a competition object.

Conventions:
* Units are in meters and degrees, in the North-East-Down coordinate system. Angles are within -180 to 180 degrees.
* absolute angle: the angle in the coordinate system automatically created when the sub was unkilled. The origin of this system is the point where the sub was unkilled.
* relative angle: the angle relative to the corrent orientation of the sub.
* depth: distance from the surface
* altitude: distance from the floor
* State: an object type containing x, y, z, yaw, pitch, roll values
* Coordinate: an object type containing x, y, values

## Explanation of Each File
* [node.cpp](./node.cpp.md)
* [mission.cpp](./mission.cpp.md)
* [restart.cpp](./restart.cpp.md)
* [tasks.cpp](./tasks.cpp.md)
* [alignments.cpp](./alignments.cpp.md)
* [client.cpp](./client.cpp.md)
* [movements.cpp](./movements.cpp.md)
* [util.cpp](./util.cpp.md)

## Structure

The main C++ files are located in the `sub_mission/src` folder, where the package operates by running a central node, usually `mission_node` or `restart_node`, which executes functions (defined in tasks.cpp) that comprise a linear set of instructions for the submarine to follow as it navigates through the course. A node, as used in Robot Operating System 2 (ROS2), is an independent process that allows the developer to run several processes at the same time with different jobs, which allows Nemo to operate efficiently. 

```
src
├── nodes
│   ├── mission.cpp
│   ├── node.cpp
│   └── restart.cpp
├── alignments.cpp
├── clients.cpp
├── movements.cpp
├── scans.cpp
├── tasks.cpp
└── util.cpp
```
The code that constructs the node in the ROS framework is located inside of the `nodes/` folder, with `node.cpp` defining the node structure, `mission.cpp` utilizing the structure to create a `mission_node` executable, and `restart.cpp` also utilizing the structure to create a `restart_node` executable. 

* tasks.cpp - the main file that instructs the sub how to move through the course. The other .cpp files are just a bunch of helper functions.

There are also `.hpp` files in the `sub_mission/include` folder, which tell the compiler what libraries that we want to use in the `.cpp` files. If Nemo is ever updated in the future, please update the correct parameters into `config.hpp` so that Nemo can be a beast.
```
include
└── sub_mission
    ├── nodes
    │   ├── mission.hpp
    │   ├── node.hpp
    │   └── restart.hpp
    ├── client.hpp
    ├── commands.hpp
    ├── config.hpp
    ├── tasks.hpp
    └── util.hpp
```