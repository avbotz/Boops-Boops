This is like mission.cpp as it sets up a high-level node to run all of the competition movement instructions, but this is mainly used for legit competition runs. The reason why this node is needed because in competition, sometimes runs may not turn out as successful as we would have liked, so we tell the diver to retrieve the sub and bring it back to the beginning for a second run. This code helps the process because if it detects that the diver has flipped the kill switch to turn off the sub, it will stop the execution of the code. When the sub is turned on again, it will restart all of the mission functions from the very beginning, which makes it convenient to use, as it automatically restarts the mission navigation.

## Function Breakdown

#### int main(int argc, char** argv)

This is the function that will get called when ROS2 runs the `restart_node`. This code is slightly more complicated than that of `mission_node`, as it needs to run a child process that executes the competition functions, while it sets up a parent process to monitor the status of the submarine and tell the child to halt and restart if necessary. 

First it registers itself as a node using `rclcpp::init()`. Second, it creates a node object that is convenient for running mission functions with using the node template that was created in `node.cpp`. Third, it waits for the sub to turn on before continuing. Fourth, it sets up the parent and child processes. 

Using C's `fork()` function, this allows us to split the node into two processes. One process is the child, which runs `mission_node` to have the sub navigate through the course. The other process is the parent, which monitors if the sub is alive or not. If the sub is dead, the parent will stop the child from continuing to run the mission functions by killing itself and the child (dam). Finally, the cycle restarts to rerun the mission functions when the sub is at the beginning of the course and turned on again. 

