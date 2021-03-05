#!/bin/bash

# Compile ROS2 workspace
source setup.sh

mkdir -p ros2_ws/src
cd ros2_ws

colcon build
cd ..