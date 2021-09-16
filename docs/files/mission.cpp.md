For a standard mission run, this is the highest-level code that sets the node up and runs all of the functions.

## Function Breakdown

#### int main(int argc, char** argv)

This is the function that will get called when ROS2 runs the `mission_node`. First, it registers itself as a node using `rclcpp::init()`. Second, it creates a node object that is convenient for running mission functions with using the node template that was created in `node.cpp`. Third, it calls `node.cpp`'s `run()` function which turns on the sub and executes the competition functions for each task to navigate through the course.