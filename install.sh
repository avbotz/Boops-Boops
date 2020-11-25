#!/bin/sh
# Bash script for installing and setting up a ROS2 workspace.
set -e

# INSTALL="melodic"
#
# Scan for flags
# for arg in "$@" ; do
#     case "$arg" in
#         -h )
#             echo "Usage: ./install.sh [--noetic]"
#             echo "  --noetic    Installs ROS Noetic (latest) instead of ROS Melodic"
#             exit 1
#         ;;
#         --help )
#             echo "Usage: ./install.sh [--noetic]"
#             echo "  --noetic    Installs ROS Noetic (latest) instead of ROS Melodic"
#             exit 1
#         ;;
#         --noetic )
#             INSTALL="noetic"
#         ;;
#         *)
#             break
#         ;;
#     esac
# done;

# Simple apt-get/pip packages.
sudo apt-get install libopencv-dev python3-pip
sudo pip3 install -r requirements.txt

# Install ROS2
sudo apt-get update && sudo apt-get install curl gnupg2 lsb-release
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
sudo sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'
sudo apt-get update
sudo apt-get install ros-eloquent-desktop
sudo apt-get install python3-colcon-common-extensions
sudo apt-get install python-rosdep

# Install ROS1
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt-get update
sudo apt install ros-melodic-desktop-full ros-melodic-uuv-simulator

. /opt/ros/eloquent/setup.sh
. /opt/ros/melodic/setup.sh

sudo rosdep init
rosdep update
rosdep install -i --from-path src --rosdistro eloquent -y

colcon build

echo "-----------------------     "
echo "Porpoise workpace installed!"
echo ""
echo "Run source setup.sh to enter the ROS overlay"
echo "(you need to do this every time).     "
echo "-----------------------     "
