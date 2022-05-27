# Copyright (c) 2020, NVIDIA CORPORATION. All rights reserved.
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restriction, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
# THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.
#
# Build this Dockerfile by running the following commands:
#
#     $ cd /path/to/Boops-Boops/docker
#     $ sudo docker build -t jetson_image .
#
# Also you should set your docker default-runtime to nvidia:
#     https://github.com/dusty-nv/jetson-containers#docker-default-runtime
#

# This docker file is used to generate a docker image, which will be used
# to create a docker container to be able to run ROS2, Gazebo, and Pytorch 
# on the Jetson TX2.

# You will have to install Spinnaker SDK manually by downloading the Spinnaker SDK
# file, copying it inside of a docker container, following the instructions
# inside of the container to install the sdk, and then saving changes to the container.
# (TODO: automate spinnaker sdk setup)

ARG BASE_IMAGE=dustynv/ros:foxy-pytorch-l4t-r32.5.0
FROM ${BASE_IMAGE}

SHELL ["/bin/bash", "-c"] 
ENV SHELL /bin/bash

ENV DEBIAN_FRONTEND=noninteractive
ARG MAKEFLAGS=-j$(nproc)
ENV LANG=en_US.UTF-8 
ENV PYTHONIOENCODING=utf-8
RUN locale-gen en_US en_US.UTF-8 && update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8

WORKDIR /tmp


# Install Gazebo and utilities
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
		  nano \
		  xterm \
		  lxterminal \
		  blender \
		  libgazebo9-dev \
		  gazebo9 \
		  gazebo9-common \
		  gazebo9-plugin-base \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get clean

RUN git clone https://github.com/dusty-nv/py3gazebo /opt/py3gazebo && \
    pip3 install protobuf==3.19.4 --verbose && \
    pip3 install trollius --verbose && \
    pip3 install pynput --verbose

ENV PYTHONPATH=/opt/py3gazebo
   
   
# Install Gazebo plugins for ROS
RUN source ${ROS_ROOT}/install/setup.bash && \
    export ROS_PACKAGE_PATH=${AMENT_PREFIX_PATH} && \
    cd ${ROS_ROOT} && \
    mkdir -p src/gazebo && \
    rosinstall_generator --deps --exclude RPP --rosdistro ${ROS_DISTRO} \
          gazebo_ros_pkgs \
	> ros2.${ROS_DISTRO}.gazebo.rosinstall && \
    cat ros2.${ROS_DISTRO}.gazebo.rosinstall && \
    vcs import src/gazebo < ros2.${ROS_DISTRO}.gazebo.rosinstall && \
    apt-get update && \
    rosdep install -y \
       --ignore-src \
       --from-paths src/gazebo \
	  --rosdistro ${ROS_DISTRO} \
	  --skip-keys "gazebo11 libgazebo11-dev libopencv-dev libopencv-contrib-dev libopencv-imgproc-dev python-opencv python3-opencv" && \
    rm -rf /var/lib/apt/lists/* && \
    apt-get clean && \
    colcon build --merge-install --base-paths src/gazebo \
    && rm -rf ${ROS_ROOT}/src \
    && rm -rf ${ROS_ROOT}/logs \
    && rm -rf ${ROS_ROOT}/build 
    

# Install BB and YOLOv5 dependencies
RUN pip3 install --verbose flask argcomplete pyserial dataclasses 
RUN pip3 install --verbose matplotlib>=3.2.2 \
    PyYAML>=5.3.1 \
    requests>=2.23.0 \
    tensorboard>=0.8.1 \
    pandas>=1.1.4 \
    seaborn>=0.11.0 \
    thop


# Set up environment
RUN mkdir -p /Boops-Boops
ENV WORKSPACE_ROOT=/Boops-Boops

ENV GAZEBO_MODEL_PATH=/usr/share/gazebo-9/models:/root/.gazebo/models
ENV GAZEBO_PLUGIN_PATH=${GAZEBO_PLUGIN_PATH}:/usr/local/lib/
ENV GAZEBO_MASTER_URI=http://localhost:11346

# Set up workspace
WORKDIR ${WORKSPACE_ROOT}

ENV PYTHONPATH="${PYTHONPATH}"


# Set up entrypoint
COPY ./ros_entrypoint.sh /ros_entrypoint.sh

RUN sed -i \
    's/ros_env_setup="\/opt\/ros\/$ROS_DISTRO\/setup.bash"/ros_env_setup="${ROS_ROOT}\/install\/setup.bash"/g' \
    /ros_entrypoint.sh && \
    cat /ros_entrypoint.sh

RUN echo 'source ${ROS_ROOT}/install/setup.bash' >> /root/.bashrc && \
    echo 'source /usr/share/gazebo-9/setup.sh' >> /root/.bashrc

ENTRYPOINT ["/ros_entrypoint.sh"]
CMD ["bash"]
