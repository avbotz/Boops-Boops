# setup script
# Updates packages, builds workspace, runs setup scripts
# Run this every time you open a new terminal to work with BB
echo "Update package config..."
git submodule update --init --recursive --remote --rebase

. /opt/ros/melodic/setup.sh
. ros1_ws/devel/setup.sh
