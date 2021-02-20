"""
For now, it's necessary to launch the Gazebo simulator through the ros1 workspace.
This file is to run mission, control, vision nodes to work with the simulator
"""

from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    return LaunchDescription([
        Node(
            package='sub_vision',
            node_executable='vision_node',
            node_name='vision',
            output='screen',
            parameters=[
                {"SIM": True}
            ]
        ),
        Node(
            package='sub_control',
            node_executable='service',
            node_name='control',
            output='screen',
            parameters=[
                {"SIM": True}
            ]
        ),
        Node(
            package='sub_mission',
            node_executable='mission_node',
            node_name='mission',
            output='screen',
            parameters=[
                {"SIM": True}
            ],
        )
    ])