# Boops-Boops: A ROS2 system

![alt text](https://upload.wikimedia.org/wikipedia/commons/9/98/Boga_Galiza.jpg)

    This central Boops-Boops ROS2 repository is the top-level
    repo for AVBotz's high level mission control system, built primarily
    for the Robosub AUV competition. It handles
    sending control commands to the microcontroller, running computer
    vision models, running competition tasks and more.

## Documentation

[Documentation](./docs) is right here. Feel free to contribute; contributions are much appreciated and will help transfer knowledge to the next generation of Botz members. (This is where we put detailed explanations of individual files. For instructions on installation and usage, follow the text below instead.)

## Setting up a Development Environment

    Setting up a Boops-Boops development environment is pretty simple.

    PREREQS:
    - Ubuntu 20.04

    1. Open a terminal. 
    2. Run `git clone https://github.com/avbotz/Boops-Boops.git`. 
       This will download BB.
    3. Run `cd Boops-Boops`
       This will change directory into the BB folder.
    4. Run `./install.sh`. 
       This will install necessary dependencies, such as 
       ROS2 Foxy and build the ROS workspaces.
       This will also download the current machine learning (ML)
       models that are being used for the sub's vision to detect objects.
       Only do this once.
    5. Source the ROS2 setup script with `source setup.sh`. 
       This is necessary every time you open a new terminal to work with ROS2.
    
    You're done! Your BB is now ready to be run ;)

    NOTES:
    - If you have **already installed** the dependencies for BB, and you are only
      re-cloning the repository for some reason, you can skip installing ROS and
      other dependencies by running `./install.sh skip-install` instead of `./install.sh`.

## Making Changes

    If you make changes to the code base and wish to run the code, you need to 
    compile the code first so that it is ready to be run.

    1. Open a text editor, make your desired changes to the code. Make sure to save
       once you make the changes.
    2. Run `./compile.sh` to compile all of the code in the ros2 workspace
       (necessary for every time you edit the code, or if it hasn't been compiled yet).
    
    You're done! Follow the next section to see how to run the code base.
    Repeat this process for every set of changes that you make before you 
    run the code.

## Running the Code

    If you wish to run the code, follow these directions:

    1. Make sure you have followed the directions in the "Making changes" sections,
       so you have made your edits and compiled them.
    2. Run one of the following launch commands:

    Competition Run:
    `ros2 launch launch/restarting_mission_A_heads.py` or
    `ros2 launch launch/restarting_mission_A_tails.py` or
    `ros2 launch launch/restarting_mission_B_heads.py` or
    `ros2 launch launch/restarting_mission_B_tails.py` or
    `ros2 launch launch/restarting_mission_C_heads.py` or
    `ros2 launch launch/restarting_mission_C_tails.py` or
    `ros2 launch launch/restarting_mission_D_heads.py` or
    `ros2 launch launch/restarting_mission_D_tails.py` 
       First choose the command with the correct coin flip result and pool that 
       the sub will run in. This will launch the image acquisition, vision, control, 
       and mission nodes in a competition run. The difference between restarting_mission 
       and the normal mission is that if the kill switch kills the sub, restart_node
       will stop the mission code from running. When the kill switch turns on the
       sub again, restart_node will restart the mission code from the beginning.
       This is useful for when a competition run is botched, and the diver kills the 
       sub and pushes it back to the start, where restart_node will automatically
       restart the mission. 

    Standard Mission Run:
    `ros2 launch launch/mission_A_heads.py` or
    `ros2 launch launch/mission_A_tails.py` or
    `ros2 launch launch/mission_B_heads.py` or
    `ros2 launch launch/mission_B_tails.py` or
    `ros2 launch launch/mission_C_heads.py` or
    `ros2 launch launch/mission_C_tails.py` or
    `ros2 launch launch/mission_D_heads.py` or
    `ros2 launch launch/mission_D_tails.py` 
       First choose the command with the correct coin flip result and competition 
       pool that the sub will run in. This will launch the image acquisition, 
       vision, control, and mission nodes in a standard mission or pool test to 
       pilot the sub.

    Image Collection Run:
    `ros2 launch launch/remote_control_image_collection.py`       or 
    `ros2 launch launch/remote_control_image_collection_front.py` or 
    `ros2 launch launch/remote_control_image_collection_down.py`
       First choose the command with the correct camera that you want to collect
       images for; the first command will log images for both cameras, the second 
       for the front camera, and the third for the down camera. This will launch
       the image acquisition, vision, control, and tuning nodes to remote control
       Nemo as images are automatically being logged. (Can be used in competition pool
       or pool tests to collect images to train ML models with)

    Prelim:
    `ros2 launch launch/prelim.py`
       This will launch the control and mission nodes to have the sub move a set
       of movements to check if the sub is running smoothly.

    Pool Test:
    `ros2 launch launch/pool_test.py`
       This will launch the acquisition, vision, control, and mission nodes
       to execute whatever commands are located in the pool_test() function 
       in sub_mission's tasks.cpp.

    Vision Test:
    `ros2 launch launch/vision_test.py`
       This will launch the acquisition, vision, control, and mission nodes
       to execute whatever commands are located in the vision_test() function 
       in sub_mission's tasks.cpp, which might be testing down camera 
       object detection for example.

    PID Tuning Session:
    `ros2 launch launch/tuning.py`
       This will launch the control and motor gains tuning GUI nodes to 
       remote control the sub, while the software member adjusts
       the aggressiveness of the motors using the GUI, in order to tune for gains 
       that allow the sub to move accurately and smoothly.

    Simulated Mission Run:
    `ros2 launch launch/sim.py`       or
    `ros2 launch launch/sim_heads.py` or
    `ros2 launch launch/sim_tails.py` 
       This will launch Gazebo with Nemo floating in the water, a simulator node
       to act as the microcontroller that communicates with sub_control and sends
       thrust values to the motors, the vision node, the control node, and the mission 
       node to simulate what a competition run might look like. The simulation is 
       useful for testing new mission movements and catching possible bugs or seeing if 
       current approaches  for completing the competition mission are performed 
       accurately by the sub.

       When you are finished, kill the simulator by clicking on the terminal, 
       pressing "Ctrl-C", waiting for everything to close, and entering `./kill_sim.sh`.

    Simulated Image Collection Run
    `ros2 launch launch/sim_remote_control_image_collection.py`         or
    `ros2 launch launch/sim_remote_control_image_collection_front.py`   or
    `ros2 launch launch/sim_remote_control_image_collection_down.py` 
       First choose the command with the correct camera that you want to collect
       images for; the first command will log images for both cameras, the second 
       for the front camera, and the third for the down camera. This will launch 
       the control, tuning, and vision nodes in the simulator to remote control
       Nemo as images are automatically being logged. (Can be used for collecting
       sim images to train ML models with)

## Running Nodes

    Running ROS2 nodes in the environment is also quite easy.

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
       - cd src/sub_mission
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

    1. Setup sub, turn on, and connect sub to router (ethernet cable 
       goes through subconn (the red plug on the lid), connects to wifi
       access point device (looks like a box) that generates wifi for the sub). 
       Ensure kill is OFF.
    2. Connect own computer to AVBotz wifi network.
    3. VNC into sub, to be able to access the sub's desktop screen.
       - Open Remote Desktop Viewer app.
       - Click "Connect" button.
       - Select "VNC" in the protocol drop down menu at the top.
       - Enter "192.168.1.101" in the host field.
       - Click the connect button at the bottom.
       - Enter the VNC password: nemo1234
    4. Put sub into water without breaking a motor.
    5. Inside the VNC, Follow Nautical README instructions. Pray that the DVL doesn't hang.
    6. Inside the VNC,Follow Boops-Boops "Running the Code" instructions with one of the 
       common node combinations.
    7. Unplug tether if this is an autonomous run.
    8. Turn kill switch ON to begin mission if that is running.

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
    the repository is because we track our packages as subrepos within this central
    repository; this makes it easy for team members to pull all resources needed
    to get up and running in one go.

## Questions?

    Contact Vincent Wang, Craig Wang, or Phoebe Tang through Slack or email.

## Final Words

    With everything in mind, let's grab this W at competition!
