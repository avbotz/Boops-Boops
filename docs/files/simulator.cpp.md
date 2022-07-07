`simulator.cpp` is the file that contains the code that is run every time you start up a `simulator` node executable from the `sub_sim` package. 

### int main()

This is the function that runs every time you run a `simulator` node executable from the `sub_sim` package. This essentially just runs the functions defined in `PIDController.cpp` to receive commands from BB, calculate the error between the sub's current state and desired state, and publish updated thruster values to the 3rd party simulator package (Plankton) that takes these values and makes the sub's motors spin that way inside the sim to push the sub in that direction.