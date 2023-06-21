#!/bin/bash
# Bash script for installing and setting up a ROS2 workspace.
# This only needs to be run once.
set -e

ROS_WS_DIR=$(pwd)

# Simple apt-get/pip packages.
sudo apt-get install libopencv-dev python3-opencv python3-pip git tmux npm nodejs 
sudo pip3 install -r requirements.txt

# # YOLOv8 requirements
sudo pip3 install -r https://raw.githubusercontent.com/ultralytics/ultralytics/master/requirements.txt

# Install stuff for webserver
sudo chown -R $(whoami) /usr/local/bin /usr/local/lib /usr/local/include /usr/local/share
npm install -g npx

# jetson pytortch install
pip install torchvision
sudo apt-get -y update;
sudo apt-get -y install autoconf bc build-essential g++-8 gcc-8 clang-8 lld-8 gettext-base gfortran-8 iputils-ping libbz2-dev libc++-dev libcgal-dev libffi-dev libfreetype6-dev libhdf5-dev libjpeg-dev liblzma-dev libncurses5-dev libncursesw5-dev libpng-dev libreadline-dev libssl-dev libsqlite3-dev libxml2-dev libxslt-dev locales moreutils openssl python-openssl rsync scons python3-pip libopenblas-dev;
export TORCH_INSTALL=https://developer.download.nvidia.cn/compute/redist/jp/v511/pytorch/torch-2.0.0+nv23.05-cp38-cp38-linux_aarch64.whl
export TORCH_INSTALL=path/to/torch-2.0.0+nv23.05-cp38-cp38-linux_aarch64.whl
python3 -m pip install --upgrade pip; python3 -m pip install aiohttp numpy=='1.19.4' scipy=='1.5.3' export "LD_LIBRARY_PATH=/usr/lib/llvm-8/lib:$LD_LIBRARY_PATH"; python3 -m pip install --upgrade protobuf; python3 -m pip install --no-cache $TORCH_INSTALL


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
		
	cd ~/Downloads
	#non-greedy grep finding file id from html in reverse (doesn't work as download link changes per request)
	#wget -O spinnaker.tar.gz https://flir.app.boxcn.net/v/SpinnakerSDK/file/$(curl -s https://flir.app.boxcn.net/v/SpinnakerSDK/folder/133154514756 | rev | grep -Po 'zg.rat.gkp-46mra-40.02utnubU-.*?-rekannips.*?:"di"' | rev | grep -Po '(?<=:).*?(?=,)' | head -1)
	# Ryan's google drive
	wget --load-cookies /tmp/cookies.txt "https://docs.google.com/uc?export=download&confirm=$(wget --quiet --save-cookies /tmp/cookies.txt --keep-session-cookies --no-check-certificate 'https://docs.google.com/uc?export=download&id=1OSc0goplIs2CQj7MVlYHpLIfvbIhuMcN' -O- | sed -rn 's/.*confirm=([0-9A-Za-z_]+).*/\1\n/p')&id=1OSc0goplIs2CQj7MVlYHpLIfvbIhuMcN" -O spinnaker.tar.gz && rm -rf /tmp/cookies.txt
	tar xvfz spinnaker.tar.gz
	cd $(ls -t -d ~/Downloads/spinnaker-*-arm64/ | head -1)
	sudo apt-get install libavcodec58 libavformat58 libswscale5 libswresample3 libavutil56 libusb-1.0-0 libpcre2-16-0 libdouble-conversion3 libxcb-xinput0 libxcb-xinerama0 qt5-default	
	sudo sh install_spinnaker_arm.sh
	cd $ROS_WS_DIR

	# Install local YOLOv5 repo so we can load models without wifi
	#cd $ROS_WS_DIR/weights
	#if [ ! -d "yolov5" ] ; then
	#    git clone "https://github.com/ultralytics/yolov5.git"
	#fi
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

./compile.sh

echo "-----------------------     "
echo "Boops-Boops workpace installed!"
echo ""
echo "Run source setup.sh to enter the ROS overlay"
echo "(you need to do this every time).     "
echo "-----------------------     "
