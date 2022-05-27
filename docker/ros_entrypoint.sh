#!/bin/bash
set -e

ros_env_setup="/opt/ros/$ROS_DISTRO/setup.bash"
echo "sourcing   $ros_env_setup"
source "$ros_env_setup"

gazebo_env_setup="/usr/share/gazebo-9/setup.sh"
echo "sourcing   $gazebo_env_setup"
source "$gazebo_env_setup"

workspace_env_setup="/Boops-Boops/install/setup.sh"
if [ -f "$workspace_env_setup" ]; then
	echo "sourcing   $workspace_env_setup"
	source "$workspace_env_setup"
fi

echo "ROS_ROOT   $ROS_ROOT"
echo "ROS_DISTRO $ROS_DISTRO"

exec "$@"