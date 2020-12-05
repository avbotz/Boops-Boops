#!/bin/sh
# Bash script for installing and setting up a ROS2 workspace.
# This only needs to be run once.
set -e

# Simple apt-get/pip packages.
sudo apt-get install libopencv-dev python3-pip
sudo pip3 install -r requirements.txt

# Install ROS2
sudo apt-get update && sudo apt-get install curl gnupg2 lsb-release
curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | sudo apt-key add -
sudo sh -c 'echo "deb [arch=$(dpkg --print-architecture)] http://packages.ros.org/ros2/ubuntu $(lsb_release -cs) main" > /etc/apt/sources.list.d/ros2-latest.list'
sudo apt-get update
sudo apt-get install ros-eloquent-desktop ros-eloquent-ros1-bridge
sudo apt-get install python3-colcon-common-extensions
sudo apt-get install python-rosdep

# TODO: Move away from ROS1
# Install ROS1
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt-get update
sudo apt install ros-melodic-desktop-full ros-melodic-uuv-simulator

# Install Tensorflow for C.
cd ~/Downloads && wget https://storage.googleapis.com/tensorflow/libtensorflow/libtensorflow-gpu-linux-x86_64-1.15.0.tar.gz
cd ~/Downloads && sudo tar -C /usr/local -xzf libtensorflow-gpu-linux-x86_64-1.15.0.tar.gz
sudo ldconfig

# Download  and install Spinnaker SDK from Craig's google drive
cd ~/Downloads
wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=13OGq0S_xd1bglssQZf8ecPB7ilrTvg93' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=13OGq0S_xd1bglssQZf8ecPB7ilrTvg93" -O ./spinnaker.tar.gz && rm -rf /tmp/cookies.txt
tar -xzf spinnaker.tar.gz -C .
cd ~/Downloads/spinnaker-2.0.0.147-amd64
sudo apt-get install libavcodec57 libavformat57 libswscale4 libswresample2 libavutil55 libusb-1.0-0 libgtkmm-2.4-dev
sudo sh install_spinnaker.sh

. /opt/ros/eloquent/setup.sh

mkdir -p ros2_ws/src
cd ros2_ws
if ! [ -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then
	sudo rosdep init
fi
rosdep update
rosdep install -i --from-path src --rosdistro eloquent -y

colcon build
cd ..

. /opt/ros/melodic/setup.sh
mkdir -p ros1_ws/src
cd ros1_ws
catkin_make
cd ..

echo "-----------------------     "
echo "Porpoise workpace installed!"
echo ""
echo "Run source setup.sh to enter the ROS overlay"
echo "(you need to do this every time).     "
echo "-----------------------     "
