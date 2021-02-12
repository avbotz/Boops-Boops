# setup script
# Updates packages, builds workspace, runs setup scripts
# Run this every time you open a new terminal to work with BB

# Build workspace if necessary
# if ! [ -f install/ ]; then
#     echo "Build initial workspace..."
#     colcon build
# fi

echo "Source setup scripts..."
. /opt/ros/eloquent/setup.sh
. ros2_ws/install/setup.sh