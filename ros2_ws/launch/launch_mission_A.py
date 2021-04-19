"""
This file is to run mission_node, control_node, vision_node, and acquisition_node 
for the sub to complete the mission  in POOL A (either competition or at a pool test)
"""

from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    return LaunchDescription([
        Node(
            package='sub_vision',
            node_executable='acquisition_node',
            node_name='acquisition',
            output='screen'
        ),
        Node(
            package='sub_vision',
            node_executable='vision_node',
            node_name='vision',
            output='screen'
        ),
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
                {"GATE": True},
                {"BINS": True},
                {"TARGET": True},
                {"OCTAGON": True},
                {"POOL_A": True}
            ]
        )
    ])