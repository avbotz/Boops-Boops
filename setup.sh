# setup script
# Updates packages, builds workspace, runs setup scripts
# Run this every time you open a new terminal to work with BB
echo "Update package config..."
git submodule update --init --recursive --remote --rebase

# Build workspace if necessary
if ! [ -f install/ ]; then
    echo "Build initial workspace..."
    colcon build
fi

echo "Source setup scripts..."
. /opt/ros/foxy/setup.sh
. install/setup.sh
