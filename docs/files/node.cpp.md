`node.cpp` creates a `MissionNode` struct, which basically creates a node object which can execute competition functions. The reason why this code is in a separate file is because it simplifies the code in the other `mission.cpp` and `restart.cpp` files significantly.

# Function Breakdown

## MissionNode::MissionNode()
This function is the struct constructor, which means that whenever a `MissionNode` object is created, this function will be called. With that said, this function is used for taking in parameters from the launch file of which mission functions we would like to run, as well as if we are in a simulator or not. 

The first chunk of this code declares that we are interested in seeing if a specific set of parameters are passed, but we set the default as false for each (don't want the sub to go ham on something we didn't tell it to do). The second chunk reads the inputted parameters passed from the launch file, and the third portion updates global parameters to share important information that the other files inside of `sub_mission` can access.

## void MissionNode::activate()
This function has the capability to essentially power on/prepare the sub for action. When called, it calls the `init_clients()` functions to establish connections to sub_control's `service` node and sub_vision's `vision_node`. Then, it stalls the code until the physical kill switch on the submarine is flipped, which turns on the physical submarine. Once we get the go-ahead signal basically, we continue with the rest of the code to set the power level of the thrusters. The power level is from a range of 0-1, with 0 telling the thrusters to use 0% of their power and 1 telling them to use 100% of their power. We usually set it to 0.2, because the thrusters are extremely powerful and giving too much power might yeet the sub, as 20% is all we need to function normally.

## void MissionNode::execute()
This function checks which tasks the user specified us to do, and it executes the functions commanding those tasks appropriately. If a full mission is requested, it will always go gate -> bins -> target -> octagon because those are the order of events in the competition. 

## void MissionNode::run()
This is a convenience function so that in other files, instead of calling `activate()` and `execute()` which would take up two lines, they can just use `run()` which takes up one line. Essentially, this function will turn on the sub, give the thrusters power, and execute the competition functions all in one neat little spot.
