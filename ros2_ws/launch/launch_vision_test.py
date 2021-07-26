"""
This file is to run mission_node, vision_node, and control_node
for the sub to test its down camera and object detection.
"""

from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    return LaunchDescription([
        Node(
            package='sub_vision',
            node_executable='acquisition',
            output='screen'
        ),
        Node(
            package='sub_vision',
            node_executable='vision',
            output='screen'
        ),
        Node(
            package='sub_control',
            node_executable='service',
            output='screen'
        ),
        Node(
            package='sub_mission',
            node_executable='mission',
            output='screen',
            parameters=[
                {"VISION_TEST": True},
                {"POOL_A": True}
            ]
        ),

        # Launch image display
        Node(
            package='rqt_image_view',
            node_executable='rqt_image_view',
            output='screen'
        )
    ])