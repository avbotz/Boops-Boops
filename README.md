# Boops-Boops: A ROS2 system

![alt text](https://upload.wikimedia.org/wikipedia/commons/9/98/Boga_Galiza.jpg)

    This central Boops-Boops ROS2 repository is the top-level
    repo for AVBotz's high level mission control system, built primarily
    for the Robosub AUV competition. It handles
    sending control commands to the microcontroller, running computer
    vision models, running competition tasks and more.

## Setting up a Development Environment

    Setting up a Boops-Boops development environment is pretty simple.

    PREREQS:
    - Ubuntu 18.04 Bionic (yes, bionic! BB requires ros1 melodic as a result of
      sim dependency, so we need to use 18.04)

    1. Open a terminal. 
    2. Run `git clone https://github.com/avbotz/Boops-Boops.git`. 
       This will download BB.
    3. Run `./install.sh`. 
       This will install necessary dependencies, including 
       both ROS1 Melodic and ROS2 Eloquent, also building the ROS workspaces.
       This will also download the current machine learning (ML)
       models that are being used for the sub's vision to detect objects.
       Only do this once.
    4. Source the ROS2 setup script with `source setup.sh`. 
       This is necessary every time you open a new terminal to work with ROS2.
    
    You're done! Your BB is now ready to be run ;)

    NOTES:
    - You shouldn't have to work with ROS1 in daily life, as the only thing
      running in ROS1 is the simulator. If you need to work on the simulator
      or another ROS1 package, `source setup_ros1.sh` instead of `setup.sh`.
    - For further info on ROS1, refer to official documentation.

## Making Changes

    If you make changes to the code base and wish to run the code, you need to 
    compile the code first so that it is ready to be run.

    1. Open a text editor, make your desired changes to the code. Make sure to save
       once you make the changes.
    2. Run `./compile.sh` to compile all of the code in the ros2 workspace.
    
    You're done! Follow the next section to see how to run the code base.
    Repeat this process for every set of changes that you make before you 
    run the code.

## Running the Code

    If you wish to run the code, follow these directions:

    1. Make sure you have followed the directions in the "Making changes" sections,
       so you have made your edits and compiled them.
    2. Run one of the following launch commands:

    Competition Run:
    `ros2 launch ros2_ws/launch/launch_restarting_mission_A.py` or
    `ros2 launch ros2_ws/launch/launch_restarting_mission_B.py` or
    `ros2 launch ros2_ws/launch/launch_restarting_mission_C.py` or
    `ros2 launch ros2_ws/launch/launch_restarting_mission_D.py` 
       First choose the command with the correct pool that the sub will run in.
       This will launch the image acquisition, vision, control, and mission nodes 
       in a competition run. The difference between restarting_mission and the 
       normal mission is that if the kill switch kills the sub, restart_node
       will stop the mission code from running. When the kill switch turns on the
       sub again, restart_node will restart the mission code from the beginning.
       This is useful for when a competition run is botched, and the diver kills the 
       sub and pushes it back to the start, where restart_node will automatically
       restart the mission. 

    Standard Mission Run:
    `ros2 launch ros2_ws/launch/launch_mission_A.py` or
    `ros2 launch ros2_ws/launch/launch_mission_B.py` or
    `ros2 launch ros2_ws/launch/launch_mission_C.py` or
    `ros2 launch ros2_ws/launch/launch_mission_D.py` 
       First choose the command with the correct competition pool that the sub 
       will run in. This will launch the image acquisition, vision, control, and 
       mission nodes in a standard mission or pool test to pilot the sub.

    Prelim:
    `ros2 launch ros2_ws/launch/launch_prelim.py`
       This will launch the control and mission nodes to have the sub move a set
       of movements to check if the sub is running smoothly.

    Pool Test:
    `ros2 launch ros2_ws/launch/launch_pool_test.py`
       This will launch the acquisition, vision, control, and mission nodes
       to execute whatever commands are located in the pool_test() function 
       in sub_mission's function.cpp.

    Vision Test:
    `ros2 launch ros2_ws/launch/launch_pool_test.py`
       This will launch the acquisition, vision, control, and mission nodes
       to execute whatever commands are located in the vision_test() function 
       in sub_mission's function.cpp, which might be testing down camera 
       object detection for example.

    PID Tuning Session:
    `ros2 launch ros2_ws/launch/launch_tuning.py`
       This will launch the control and motor gains tuning GUI nodes to 
       remote control the sub, while the software member adjusts
       the aggressiveness of the motors using the GUI, in order to tune for gains 
       that allow the sub to move accurately and smoothly.

    Simulator:
    `./scripts/run_sim.sh`
       This will start a tmux session that will run the ros1 simulator as well as 
       launch the vision, control, and mission nodes in simulation mode to simulate
       what a competition run might look like. The simulation is useful for testing 
       new mission movements and catching possible bugs or seeing if current approaches 
       for completing the competition mission are performed accurately by the sub.

## Running Nodes

    Running ROS2 nodes in the environment is also quite easy.

    PREREQS:
    - Set up the development environment
    - tmux installed

    1. `source setup.sh` if not already sourced.
    2. Startup the simulator with `./scripts/run_sim.sh`. This requires tmux.
    3. If any changes have been made, rebuild the workspace. `cd ros2_ws` (in another terminal) and run `colcon build` to build. (Python packages must be built too.)

    Currently, the only way to test ROS2 nodes is via manual run commands.
    Launch configuration support is planned.

    *Aside: for more information on nodes, see the official docs.*

    To launch a ros2 node, the general syntax is:

        `ros2 run package_name executable_name --ros-args -p param_name:=param_value`

    Launching sub_control with SIM=true (simulator on):

        `ros2 run sub_control service --ros-args -p SIM:=true`

    Other nodes will be added as needed.

    For further info, refer to official ROS2 documentation on services.

## Testing Nodes

    We can test the sub_control node manually by calling it via CLI.

    You can call a ROS2 service (like sub_control) with `ros2 service call`:

        `ros2 service call <service_name> <service_type> <arguments>`

    Testing sub_control (control_state):

        `ros2 service call /control_state sub_control_interfaces/srv/ControlState`

    Testing sub_control (control_state_write):

        `ros2 service call /control_write_state sub_control_interfaces/srv/ControlWriteState "{ x: 0, y: 0, z: 0, yaw: 0, pitch: 0, roll: 0}"`

    Note that "arguments" is in JSON. Service descriptions are in src/sub_control/sub_control_interfaces/srv.

## Committing Changes

    If you wish to change BB's official code on the github, 
    these instructions will tell you how:

    1. Create a separate branch of the subrepo you wish to commit to by changing
       into that directory and running the git commands to create your own branch.
       For example:
       - cd ros2_ws/src/sub_mission
       - git checkout -b thisIsMyOwnBranchName
    2. Inside your target subrepo, run the following commands to add, commit, and 
       push your changes to your branch on the github repo.
       For example:
       - git add .
       - git commit -m "THIS IS MY COMMIT MESSAGE"
       - git push
    3. Navigate to the github website and submit a pull request using your branch.
       If it is suitable, it will be approved and merged into the main BB branch!

## Pool Test Procedure

    1. Setup sub, turn on, and connect sub to router. Ensure kill is OFF.
    2. Connect own computer to AVBotz network.
    3. SSH into sub, "ssh user@192.168.2.50".
    4. Put sub into water without breaking a motor.
    5. Follow Nautical README instructions. Pray that the DVL doesn't hang.
    6. Follow Boops-Boops "Running the Code" instructions with one of the common node combinations.
    7. Unplug tether if this is an autonomous run.
    8. Turn kill switch ON to begin mission if that is running.

## Repo Structure

    - README: this readme file
    - clean.sh: Used to clean all build artifacts in both repos
    - install.sh: Used to install dependencies and set up initial repo workspaces
    - compile.sh: Used to compile ROS2 workspace (run after changes are made)
    - models.sh: Used to download ML models
    - requirements.txt: Used for Python dependencies (TODO: Replace with rosdep?)
    - **ros1_ws: ROS1 workspace (important) - contains simulator**
      - launch: Contains roslaunch files (ros1) used to launch simulator
      - startup/randomize_props.py: Script used to randomize props within simulator on startup
      - sub_sim subrepo: Contains simulator
    - **ros2_ws: ROS2 workspace (important) - contains main BB code**
      - sub_control subrepo: Contains packages for control (python) and service interfaces
      - sub_mission subrepo: Contains packages for running actual mission tasks
      - sub_vision subrepo: Contains packages for vision
    - scripts: various convenience scripts (including to run simulator)
    - setup.sh: Sets up ROS2 environment variables etc. (run every time)
    - setup_ros1.sh: Sets up ROS1 environment variables etc. (run every time) (do not mix with ROS2 setup.sh)

    ROS1 workspace packages are standard roscpp packages. ROS2 workspace packages are
    standard rclcpp packages unless otherwise stated (sub_control is an rclpy/python package).

## Rationale

    This repository is somewhat of a non-conventional layout for ROS projects.
    Experienced ROS developers might be surprised to see both a ros1_ws and
    ros2_ws embedded inside this repository. The reason we chose to use this
    repository layout is because it actually keeps tracking packages simple.

    The central repo essentially acts as a collection of bootstrapping scripts
    for the ROS1 and ROS2 workspaces. The reason these folders are embedded in
    the repository is because we track our packages as subrepos within this central
    repository; this makes it easy for team members to pull all resources needed
    to get up and running in one go.

    Of particular interest are the separate ros1 and ros2 workspaces; the reason
    we have these two separate workspaces is due to a need to support our simulator,
    which currently runs on ROS1. Plans are in the works to port the sim to ROS2
    and eliminate this dependency. However, having the flexibility to use ROS1
    packages when needed is extremely useful.

## Some Quick Clarifications

    - ROS1 uses the `catkin` build system (e.g. `catkin_make`). ROS2 uses the `colcon` build utility (`colcon build`). Use the respective command for the respective workspaces.
    - ROS1 bridge is provided by `ros-${DISTRO}-ros1-bridge`. (DISTRO = eloquent for us.)
    - `dataclasses` may not be available in stdlib if Python is an older version (like the version currently in bionic). Install from requirements.txt to fix this.

## Questions?

    Contact Vincent Wang, Craig Wang, or Phoebe Tang through Slack or email.

## Final Words

    With everything in mind, let's grab this W at competition!
