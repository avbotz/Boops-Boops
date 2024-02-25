#!/bin/bash

# Compile ROS2 workspace
source setup.sh
export MAKEFLAGS=" -j 5"
colcon build --parallel-workers 1

# Compile the interface
./src/sub_interface/scripts/build_css.py
