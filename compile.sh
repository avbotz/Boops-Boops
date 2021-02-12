#!/bin/bash

mkdir -p ros2_ws/src
cd ros2_ws

colcon build
cd ..