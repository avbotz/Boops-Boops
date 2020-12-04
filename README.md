# Boops-Boops: A ROS2 system

    This central Boops-Boops ROS2 repository is the top-level
    repo for AVBotz's high level mission control system, built primarily
    for the Robosub AUV competition. It handles
    sending control commands to the microcontroller, running computer
    vision models, running competition tasks and more.

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

## Repo Structure

- README: this readme file
- clean.sh: Used to clean all build artifacts in both repos
- install.sh: Used to install dependencies and set up initial repo workspaces
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

## Setting up a Development Environment

    Setting up a Boops-Boops development environment is pretty simple.

    PREREQS:
    - Ubuntu 18.04 Bionic (yes, bionic! BB requires ros1 melodic as a result of
      sim dependency, so we need to use 18.04)

    1. Clone the repo *recursively* (this pulls in needed sub-packages):

        git clone --recursive https://github.com/avbotz/Boops-Boops

        a.  If you forget to clone recursively, you can pull the sub-packages with
            `git submodule update --init --recursive`. This is the same command used
            to update subpackages.
        b.  Alternatively, if you know what you are doing, you can manually
            pull just the subpackages you want, in order to avoid pulling
            unnecessary code.
    2. Run the `./install.sh` script. This will install necessary dependencies,
       including both ROS1 Melodic and ROS2 Eloquent. It will also update the submodules
       to the necessary configuration (checkout master instead of detached) and
       build the ROS workspaces.
    3. Source the ROS2 setup script with `source setup.sh`. This is necessary every
       time you open a new terminal to work with ROS2.
    4. You're done! `install.sh` should have already built the workspaces.

    NOTES:
    - You shouldn't have to work with ROS1 in daily life, as the only thing
      running in ROS1 is the simulator. If you need to work on the simulator
      or another ROS1 package, `source setup_ros1.sh` instead of `setup.sh`.
    - For further info on ROS1, refer to official documentation.

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

        `ros2 service call /control_state_write sub_control_interfaces/srv/ControlStateWrite "{ x: 0, y: 0, z: 0, yaw: 0, pitch: 0, roll: 0}"`

    Note that "arguments" is in JSON. Service descriptions are in src/sub_control/sub_control_interfaces/srv.
