`sub_mission` is the package that orchestrates the entire submarine; this package sends the commands to move the submarine, dive, submerge, or use the vision system to orient itself to a competition object.

## Explanation of Each File
* [node.cpp](./node.cpp.md)
* [mission.cpp](./mission.cpp.md)
* [restart.cpp](./restart.cpp.md)
* [tasks.cpp](./tasks.cpp.md)
* [commands.cpp](./commands.cpp.md)
* [client.cpp](./client.cpp.md)
* [util.cpp](./util.cpp.md)

## Structure

The main C++ files are located in the `sub_mission/src` folder, where the package operates by running a central node, usually `mission_node` or `restart_node`, which executes functions (defined in tasks.cpp) that comprise a linear set of instructions for the submarine to follow as it navigates through the course. A node, as used in Robot Operating System 2 (ROS2), is an independent process that allows the developer to run several processes at the same time with different jobs, which allows Nemo to operate efficiently. 

```
src
├── nodes
│   ├── mission.cpp
│   ├── node.cpp
│   └── restart.cpp
├── client.cpp
├── commands.cpp
├── tasks.cpp
└── util.cpp
```
The code that constructs the node in the ROS framework is located inside of the `nodes/` folder, with `node.cpp` defining the node structure, `mission.cpp` utilizing the structure to create a `mission_node` executable, and `restart.cpp` also utilizing the structure to create a `restart_node` executable. 

Below the nodes folder is the code that is used to write the movement instructions for the AUV during competition. The main file is `tasks.cpp`, which tells the AUV how to move through the course, and the other files just contain helper functions. If you are looking to edit the sub's navigation through the course, `tasks.cpp` is the place to do so.

Finally, besides the `.cpp` files, there are also `.hpp` files in the `sub_mission/include` folder, which exist to tell the compiler what libraries that we want to use in the main `.cpp` files. Of particular interest is `config.hpp`, which contains some configuration parameters for the submarine. If Nemo is ever updated in the future, please update the correct values into this file so that Nemo can be a beast.
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