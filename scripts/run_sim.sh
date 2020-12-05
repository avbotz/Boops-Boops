#!/bin/bash
# Script to launch the ROS1 simulator, with a bridge to ROS2.

# Start tmux session
echo "starting tmux..."
tmux new-session -d


# Setup panes
tmux selectp -t 0
tmux splitw -h -p 50

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
tmux send-keys "colcon build" C-m
tmux send-keys "source devel/setup.bash" C-m
tmux send-keys "ros2 run ros1_bridge dynamic_bridge" C-m

# From here, your ROS2 stuff should work!
tmux a
