"""
This file is to run mission_node, vision_node, and control_node
for the sub to test its down camera and object detection.
"""

from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    return LaunchDescription([
        Node(
            package='sub_control',
            node_executable='service',
            node_name='control',
            output='screen'
        ),
        Node(
            package='sub_mission',
            node_executable='mission_node',
            node_name='mission',
            output='screen',
            parameters=[
                {"VISION_TEST": True}
            ]
        ),
        Node(
            package='sub_mission',
            node_executable='mission_runner',
            node_name='mission_runner',
            output='screen',
        )
    ])