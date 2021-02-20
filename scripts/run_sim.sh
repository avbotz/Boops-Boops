#!/bin/bash
# Script to launch the ROS1 simulator, with a bridge to ROS2.

# Start tmux session
echo "Starting tmux..."
tmux new-session -d

# Setup 3 panes
tmux new-session -d
tmux selectp -t 0    # select the first (0) pane
tmux splitw -h -p 50 # split it into two halves
tmux selectp -t 1    # select the second (1) pane
tmux splitw -p 50    # split it into two halves

# Start ROS1 simulator.
tmux selectp -t 0
tmux send-keys "source /opt/ros/melodic/setup.sh" C-m
tmux send-keys "cd ros1_ws" C-m
tmux send-keys "catkin_make" C-m # If not built, build
tmux send-keys "source devel/setup.bash" C-m # Source local setup so it finds sim
tmux send-keys "roslaunch launch/simulator.launch" C-m
sleep 2

# Select another pane, start ros1_bridge so ROS2 can connect
tmux selectp -t 1
tmux send-keys "source setup_ros1.sh" C-m
tmux send-keys "source setup.sh" C-m
tmux send-keys "ros2 run ros1_bridge dynamic_bridge" C-m

# # Run ros2 nodes (vision, control, mission)
sleep 8
tmux selectp -t 2
tmux send-keys "source setup.sh" C-m
tmux send-keys "ros2 launch ros2_ws/launch/launch_sim.py" C-m

# From here, your ROS2 stuff should work!
tmux a
