#!/bin/bash
# Bash script for installing and setting up a ROS2 workspace.
# This only needs to be run once.
set -e

ROS_WS_DIR=$(pwd)

# Simple apt-get packages.
sudo apt-get install libopencv-dev python3-opencv python3-pip git tmux

# Install pip packages
sudo pip3 install -r requirements.txt

if [ "${1}" != "skip-install" ]; then
    # Install ROS2
    sudo apt-get update && sudo apt-get install curl gnupg2 lsb-release git wget
    sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg   
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null
    sudo apt update
    sudo apt install ros-foxy-desktop
    sudo apt install ros-foxy-gazebo-*
    sudo apt-get install python3-colcon-common-extensions
    sudo apt-get install python3-rosdep
        
    # Download and install Spinnaker SDK from Craig's google drive
    cd ~/Downloads
    gdown "https://drive.google.com/uc?id=1ovvyZivlXCknb2bTlY62_qDiSiv1Sn2_" -O spinnaker.tar.gz
    tar -xzf spinnaker.tar.gz -C .
    cd $(ls -t -d ~/Downloads/spinnaker-*/ | head -1)
    sudo apt-get install libavcodec58 libavformat58 libswscale5 libswresample3 libavutil56 libusb-1.0-0 libpcre2-16-0 libdouble-conversion3 libxcb-xinput0 libxcb-xinerama0
    sudo sh install_spinnaker.sh
    cd $ROS_WS_DIR 
else
    echo "Skipping installation of packages."
fi

# Download ML models from AVBotz's Google Drive
cd $ROS_WS_DIR
./models.sh

# Install each subrepo
source /opt/ros/foxy/setup.sh
source /usr/share/gazebo-11/setup.sh

if ! [ -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then
    sudo rosdep init
fi

./clone_repos.sh

rosdep update --include-eol-distros
rosdep install -i --from-path src --rosdistro foxy

colcon build --packages-up-to plankton

colcon build

./compile.sh

echo "-----------------------     "
echo "Boops-Boops workpace installed!"
echo ""
echo "Run source setup.sh to enter the ROS overlay"
echo "(you need to do this every time).     "
echo "-----------------------     "
