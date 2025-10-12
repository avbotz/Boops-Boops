ROS2_REPOS=("https://github.com/avbotz/sub_control" "https://github.com/avbotz/sub_vision" "https://github.com/avbotz/sub_mission" "https://github.com/avbotz/sub_interface" "https://github.com/avbotz/sub_sim" "https://www.github.com/Liquid-ai/Plankton")
mkdir -p src
cd src

for repo in ${ROS2_REPOS[@]} 
do
    if [ ! -d "$repo | grep -oE '[^/]+$'" ];
    then 
        git clone --recursive $repo
    fi
done
