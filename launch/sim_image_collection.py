"""
This file is to run control, vision nodes, and interface to remote control the sub
through the simulator as it logs images from both the front and down cameras
(maybe for ML training or remote control practice).
"""

import os

from ament_index_python import get_package_share_directory

from launch import LaunchDescription
from launch.actions import IncludeLaunchDescription
from launch_xml.launch_description_sources import XMLLaunchDescriptionSource
from launch_ros.actions import Node

def generate_launch_description():
    return LaunchDescription([
        IncludeLaunchDescription(
            XMLLaunchDescriptionSource(
                os.path.join(
                    get_package_share_directory("sub_sim"),
                    "launch/simulator.xml")
            )
        ),
        Node(
            package="sub_sim",
            executable="simulator",
            output="screen",
        ),
        Node(
            package="sub_control",
            executable="control",
            output="screen",
            parameters=[
                {"SIM": True}
            ]
        ),
        Node(
            package="sub_acquisition",
            executable="acquisition",
            output="screen",
            parameters=[
                {"SIM": True}
            ]
        ),
        Node(
            package="sub_vision_yolov8",
            executable="vision",
            output="screen",
            parameters=[
                {"SIM": True},
                {"LOG_FRONT": True},
                {"LOG_DOWN": True}
            ]
        ),

        # Launch image display, to access enter:
        # (ip address of computer running BB):5000 in a web browser

        # Use the interface"s manual control mode to control the sub
        # while the code automatically logs images.
        Node(
            package="sub_interface",
            executable="interface",
            output="screen",
        )
    ])