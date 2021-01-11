#!/bin/bash
# Script to launch the ROS1 simulator, with a bridge to ROS2.

# Start tmux session
echo "Starting tmux..."
tmux new-session -d

# Setup 4 panes
tmux new-session -d
tmux selectp -t 0    # select the first (0) pane
tmux splitw -h -p 50 # split it into two halves

# Source setup scripts
tmux selectp -t 0
tmux send-keys "source /opt/ros/melodic/setup.sh" C-m
tmux selectp -t 1
tmux send-keys "source /opt/ros/eloquent/setup.sh" C-m

# Start ROS1 simulator.
tmux selectp -t 0
tmux send-keys "cd ros1_ws" C-m
tmux send-keys "catkin_make" C-m # If not built, build
tmux send-keys "source devel/setup.bash" C-m # Source local setup so it finds sim
tmux send-keys "roslaunch launch/simulator.launch" C-m
sleep 2

# Select another pane, start ros1_bridge so ROS2 can connect
tmux selectp -t 1
tmux send-keys "cd ros2_ws" C-m
tmux send-keys "source install/setup.sh" C-m
tmux send-keys "ros2 run ros1_bridge dynamic_bridge" C-m

# Run sub control node
# tmux selectp -t 2
# tmux send-keys "cd ros2_ws" C-m
# tmux send-keys "source install/setup.sh" C-m
# tmux send-keys "ros2 run sub_control service --ros-args -p SIM:=true" C-m
#
# # Prepare 4th pane to run ros2 stuff
# tmux selectp -t 3
# tmux send-keys "cd ros2_ws" C-m
# tmux send-keys "source install/setup.sh" C-m
# echo "Waiting 15 seconds for sim to start..."
# sleep 15
# tmux send-keys 'ros2 service call /control_write sub_control_interfaces/srv/ControlWrite "{data: p 0.15\n}"' C-m

# From here, your ROS2 stuff should work!
tmux a
