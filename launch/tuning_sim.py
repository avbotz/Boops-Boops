"""
This file is to run control_node and tuning_node
in the sim to remote control Nemo while 
tuning the motor gains using tuning_node's gui. 
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
            package='sub_control',
            node_executable='control',
            output='screen',
            parameters=[
                {"SIM": True}
            ]
        ),
        Node(
            package='sub_control',
            node_executable='tuning',
            output='screen'
        )
    ])