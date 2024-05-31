"""
This file is to run mission, control, vision nodes to work with the simulator.
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
                    get_package_share_directory('sub_sim'),
                    'launch/simulator.xml')
            )
        ),
        Node(
            package='sub_sim',
            executable='simulator',
            output='screen',
        ),
        Node(
            package='sub_acquisition',
            executable='acquisition',
            # output='log',
            parameters=[
                {"SIM": True}
            ]
        ),
        Node(
            package='sub_vision_yolov8',
            executable='vision',
            # output='log',
            parameters=[
                {"LOG_FRONT": True},
                {"LOG_DOWN": True},
                {"SIM": True}
            ]
        ),
        
        Node(
            package='sub_control',
            node_executable='control',
            output='screen',
            parameters=[
                {"SIM": True}
            ]
        ),
        
        Node(
            package='sub_mission',
            executable='mission',
            # output='log',
            parameters=[
                {"GATE": False},
                {"BUOY": False},
                {"BINS": True},
                {"TORP": True},
                {"OCTAGON": True},
                {"POOL_B": True},
                {"SIM": True}
            ]
        ),
        
        # Launch image display, to access enter:
        # (ip address of computer running BB):5000 in a web browser
        Node(
            package='sub_interface',
            node_executable='interface',
            output='screen',
        )
    ])
