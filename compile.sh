#!/bin/bash

# Compile ROS2 workspace
source setup.sh
colcon build

# Compile the interface
./src/sub_interface/scripts/build_css.py