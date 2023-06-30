"""
For now, it's necessary to launch the Gazebo simulator through the ros1 workspace.
This file is to run mission, control, vision nodes to work with the simulator.
This launch file uses restart_node if the user wishes to gain a more realistic
sense of what a competition run will feel like (since we will use restart_node
instead of mission_node at competition).
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
            output='screen',
            parameters=[
                {"SIM": True}
            ]
        ),
        Node(
            package='sub_vision_yolov8',
            executable='vision',
            output='screen',
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
            executable='restart',
            output='screen',
            parameters=[
                {"GATE": True},
                {"BUOY": True},
                {"BINS": True},
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