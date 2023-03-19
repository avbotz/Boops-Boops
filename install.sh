#!/bin/bash
# Bash script for installing and setting up a ROS2 workspace.
# This only needs to be run once.
set -e

ROS_WS_DIR=$(pwd)

# Simple apt-get/pip packages.
sudo apt-get install libopencv-dev python3-opencv python3-pip git tmux npm
sudo pip3 install -r requirements.txt

# # YOLOv5 requirements
sudo pip3 install -r https://raw.githubusercontent.com/ultralytics/yolov5/master/requirements.txt

# For host pc that already installed pytorch with specific cuda version:
# sudo pip3 install matplotlib>=3.2.2 numpy>=1.18.5 opencv-python>=4.1.1 Pillow>=7.1.2 PyYAML>=5.3.1 requests>=2.23.0 scipy>=1.4.1 tqdm>=4.41.0
# sudo pip3 install protobuf==3.20.1 
# sudo pip3 install tensorboard>=2.4.1 pandas>=1.1.4 seaborn>=0.11.0 ipython psutil thop

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
	wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1GEQnZosEHUewi1AdhNMk5z_9XJpvWMJa' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1GEQnZosEHUewi1AdhNMk5z_9XJpvWMJa" -O ./spinnaker.tar.gz && rm -rf /tmp/cookies.txt
	tar -xzf spinnaker.tar.gz -C .
	cd $(ls -t -d ~/Downloads/spinnaker-*/ | head -1)
	sudo apt-get install libavcodec58 libavformat58 libswscale5 libswresample3 libavutil56 libusb-1.0-0 libpcre2-16-0 libdouble-conversion3 libxcb-xinput0 libxcb-xinerama0
	sudo sh install_spinnaker.sh
	cd $ROS_WS_DIR

	# Install local YOLOv5 repo so we can load models without wifi
	cd $ROS_WS_DIR/weights
	if [ ! -d "yolov5" ] ; then
	    git clone "https://github.com/ultralytics/yolov5.git"
	fi
else
	echo "Skipping installation of packages."
fi

# Download ML models from Craig's Google Drive
cd $ROS_WS_DIR
./models.sh

# Install each subrepo
source /opt/ros/foxy/setup.sh
source /usr/share/gazebo-11/setup.sh

ROS2_REPOS=("https://github.com/avbotz/sub_control" "https://github.com/avbotz/sub_vision" "https://github.com/avbotz/sub_mission" "https://github.com/avbotz/sub_interface" "https://github.com/avbotz/sub_sim" "https://www.github.com/Liquid-ai/Plankton")

mkdir -p src
if ! [ -f /etc/ros/rosdep/sources.list.d/20-default.list ]; then
	sudo rosdep init
fi

cd src
for repo in ${ROS2_REPOS[@]} 
do
	if [ ! -d "$repo | grep -oE '[^/]+$'" ];
	then 
		git clone --recursive $repo
	fi
done
cd ..

rosdep update
rosdep install -i --from-path src --rosdistro foxy

colcon build --packages-up-to plankton

colcon build

echo "-----------------------     "
echo "Boops-Boops workpace installed!"
echo ""
echo "Run source setup.sh to enter the ROS overlay"
echo "(you need to do this every time).     "
echo "-----------------------     "
