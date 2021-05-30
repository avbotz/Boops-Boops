"""
This file is to run mission_node, control_node, and tuning_node
for the sub to repeat a predefined movement sequence while tuning the motor
gains using tuning_node's gui. 
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
            package='sub_control',
            node_executable='tuning',
            node_name='tuning',
            output='screen',
        ),
        Node(
            package='sub_mission',
            node_executable='mission_node',
            node_name='mission',
            output='screen',
            parameters=[
                {"PID_TUNING_SEQUENCE": True},
                {"POOL_A": True}
            ]
        )
    ])