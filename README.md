# Boops-Boops: A ROS2 system

![alt text](https://upload.wikimedia.org/wikipedia/commons/9/98/Boga_Galiza.jpg)

    Boops-Boops is AVBotz's high level mission control 
    system. It handles sending movements commands to the 
    microcontroller, running computer vision models, running 
    competition tasks and more.

## Documentation

[Documentation](./docs) is right here. Pls contribute to transfer knowledge to the next gen of Botz ppl.

## Installation

    PREREQS:
    - Ubuntu 20.04

    1. Open a terminal. 
    2. `git clone https://github.com/avbotz/Boops-Boops.git`
    3. `cd Boops-Boops`
    4. `./install.sh`. 
       This will install necessary dependencies, such as 
       ROS2 Foxy and build the ROS workspaces.
       This will also download the current machine learning (ML)
       models that are being used for the sub's vision to detect objects.
       Only do this once.
    5. Source the ROS2 setup script with `source setup.sh`. 
       This is necessary every time you open a new terminal to work with ROS2.
    

    NOTES:
    - If you have **already installed** the dependencies for BB, and you are 
    only re-cloning the repository for some reason, you can skip installing 
    dependencies by running `./install.sh skip-install`.

## Compiling

    Run `./compile.sh` every time you make a change to a file, to compile.

## Running the Code

    Run one of the following launch commands:

    Competition Run: `ros2 launch launch/restart_A.py` 
       If you're running in pool B instead, replace 'A' with 'B'. Same for the 
       other pools. This will launch the image acquisition, vision, control, 
       and mission nodes in a competition run. Uses a restarting mission setup 
       so that if the kill switch kills the sub, restart_node will stop the 
       mission code from running. When the kill switch turns on the sub again, 
       restart_node will restart the mission code from the beginning. This is 
       useful for when a competition run is botched, and the diver kills the 
       sub and pushes it back to the start, where restart_node will 
       automatically restart the mission. 

    Mission Run: `ros2 launch launch/mission_A.py` 
       Does same thing as the restart_A.py launch file, except it uses a
       standard mission node instead of a restarting node. This node will not
       restart if the diver kills and then unkills the sub.

    Image Collection Run: `ros2 launch launch/image_collection.py`                 
       Logs images from down cam and front cam. If you want to log only one of the cameras do, `image_collection_front.py` or `image_collection_down.py` for example.
       Launches the image acquisition, vision, control, and interface nodes to remote control the sub as images are automatically being logged. 
       Use the interface's manual control mode to move the sub while it automatically logs images.

    Prelim: `ros2 launch launch/prelim.py`
       Launches control and mission nodes to have the sub move a set
       of movements to check if the sub is running smoothly.

    Pool Test: `ros2 launch launch/pool_test.py`
       Launches acquisition, vision, control, and mission nodes
       to execute whatever commands are located in the pool_test() function 
       in sub_mission's tasks.cpp.

    Vision Test: `ros2 launch launch/vision_test.py`
       Launches the acquisition, vision, control, and mission nodes
       to execute whatever commands are located in the vision_test() function 
       in sub_mission's tasks.cpp, which might be testing down camera 
       object detection for example.

    Simulator: `ros2 launch launch/sim.py`
       Launches Gazebo simulator, a simulator node to act as the 
       microcontroller that communicates with sub_control and sends thrust 
       values to the motors, the vision node, the control node, and the mission
       node to simulate what a competition run might look like. Useful for 
       testing mission and vision code and catching bugs.

       If you want to test coin flip mission, do `sim_heads.py` or 
       `sim_tails.py`.

       When you are finished, press "Ctrl-C" in the terminal, wait for 
       everything to close, and enter `./kill_sim.sh`.

    Simulated Image Collection Run `ros2 launch launch/sim_image_collection.py`      
       Same as `image_collection.py`, but logs images from front and down cams 
       in the sim. If you only want to log images from one of the cameras, do 
       `sim_image_collection_front.py` or `sim_image_collection_down.py`. 
       Launches the control, interface, and vision nodes in the simulator to 
       remote control the sub as images are automatically being logged. Use the 
       interface's manual control mode to control the sub. (Can be used for 
       collecting sim images to train ML models with).

## Accessing the GUI Interface

    After running a launch file, enter `[SUB'S IP ADDRESS]:5000` 
    (no brackets or dashes) into a web browser to see the camera feeds, read 
    data, and remote control the sub. If running the sim, enter 
    `localhost:5000` instead.

## Pool Test Procedure

    1. Setup sub, turn on, and connect it to tether to generate wifi.
       Ensure kill is OFF.
    2. Connect your computer to AVBotz wifi network. Password: avbsashimi
    3. SSH into sub: `ssh avbotz@[SUB'S IP ADDRESS]`. Ask electrical if unsure.
       You can open multiple terminals and ssh again to get multiple panes.
    3. OR VNC into sub, to be able to access the sub's desktop screen. (Not recommended because it's slow.)
       - Open Remote Desktop Viewer app.
       - Click "Connect" button.
       - Select "VNC" in the protocol drop down menu at the top.
       - Enter "[SUB'S IP ADDRESS]" (no brackets) in the host field.
       - Click the connect button at the bottom.
       - Enter the VNC password: nemo1234
    4. Put sub into water without breaking a motor.
    5. Inside the SSH/VNC, follow maritime's README instructions.
    6. Inside the SSH/VNC, follow Boops-Boops "Running the Code" instructions with one of the 
       common launch files.
    7. Unplug tether if this is an autonomous run.
    8. Turn kill switch ON to begin mission if that is running.

## Running Nodes (for Debugging Only)

    Running ROS2 nodes in the environment is also quite easy/

    PREREQS:
    - Set up the development environment
    - tmux installed

    1. `source setup.sh` if not already sourced.
    2. If any changes have been made, rebuild the workspace. `./compile.sh` 
    3. Startup the simulator (instructions in `Running the Code` section)

    Currently, the only way to test ROS2 nodes is via manual run commands.
    Launch configuration support is planned.

    *Aside: for more information on nodes, see the official docs.*

    To launch a ros2 node, the general syntax is:

        `ros2 run package_name executable_name --ros-args -p param_name:=param_value`

    Launching sub_control with SIM=true (simulator on):

        `ros2 run sub_control service --ros-args -p SIM:=true`

    Other nodes will be added as needed.

    For further info, refer to official ROS2 documentation on services.

## Testing Nodes (for Debugging Only)

    We can test the sub_control node manually by calling it via CLI.

    Note: Some of this is outdated and may not work because of changes we made 
    to how we configured services.

    You can call a ROS2 service (like sub_control) with `ros2 service call`:

        `ros2 service call <service_name> <service_type> <arguments>`

    Testing sub_control (control_state):

        `ros2 service call /control_state sub_control_interfaces/srv/ControlState`

    Testing sub_control (control_state_write):

        `ros2 service call /control_write_state sub_control_interfaces/srv/ControlWriteState "{ x: 0, y: 0, z: 0, yaw: 0, pitch: 0, roll: 0}"`

    Note that "arguments" is in JSON. Service descriptions are in src/sub_control/sub_control_interfaces/srv.

## Committing Changes

    If you want to change BB's official code on the github:

    1. Create a separate branch of the subrepo you wish to commit to.
       Eg:
       - cd src/sub_mission
       - git checkout -b thisIsMyOwnBranchName
    2. Run the following commands to add, commit, and 
       push your changes to your branch on the github subrepo.
       For example:
       - git add .
       - git commit -m "THIS IS MY COMMIT MESSAGE"
       - git push
    3. Navigate to the github website and submit a pull request using your branch.
       If it is suitable, it will be approved and merged into the main subrepo!

## Repo Structure

    - README: this readme file
    - **src: ROS2 workspace (important) - contains main BB code**
      - sub_control subrepo: Contains packages for control (python) and service interfaces
      - sub_mission subrepo: Contains packages for running actual mission tasks
      - sub_vision subrepo: Contains packages for vision
      - sub_sim subrepo: Contains packages for simulating navigation and vision tasks
    - **launch: Contains launch scripts that can launch multiple nodes at a time
    - **images: Contains logged images from irl or sim runs
    - **gains: Contains saved PID tuning gains from PID tuning sessions
    - **docs: Documentation of BB
    - **install, **build, **log: Some random stuff that appears after you build BB
    - clean.sh: Used to clean all build artifacts in both repos
    - compile.sh: Used to compile ROS2 workspace (run after changes are made)
    - install.sh: Used to install dependencies and set up initial repo workspaces
    - kill_sim.sh: Used to kill all simulation processes (run after first pressing Ctrl-C)
    - models.sh: Used to download ML models
    - requirements.txt: Used for Python dependencies (TODO: Replace with rosdep?)
    - setup.sh: Sets up ROS2 environment variables etc. (run every time)

    ROS2 workspace packages are standard rclcpp (c++) packages or rclpy (python) packages.

## Rationale

    The central repo essentially acts as a collection of bootstrapping scripts
    for the ROS2 workspaces. The reason these folders are embedded in
    the repository is because we track our packages as subrepos within this 
    central repository; this makes it easy for team members to pull all 
    resources needed to get up and running in one go.

## Questions?

    Contact Vincent Wang, Craig Wang, or Phoebe Tang through Discord or email.

## Final Words

    With everything in mind, let's grab this W at competition!