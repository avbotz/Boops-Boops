"""
This file is to run mission_node and control node
for the sub to execute basic movements to check sub movement.
"""
import os
from ament_index_python import get_package_share_directory
from launch import LaunchDescription
from launch.actions import IncludeLaunchDescription
from launch_xml.launch_description_sources import XMLLaunchDescriptionSource
from launch_ros.actions import Node

def generate_launch_description():
    sim_include = IncludeLaunchDescription(
            XMLLaunchDescriptionSource(
                os.path.join(
                    get_package_share_directory('simulator'),
                    'launch/simulator.launch'))
    )
    return LaunchDescription([
        sim_include,
        Node(
            package='sub_mission',
            node_executable='mission',
            output='screen',
            parameters=[
                {"PRELIM": True},
                {"POOL_A": True}
            ]
        )
    ])
