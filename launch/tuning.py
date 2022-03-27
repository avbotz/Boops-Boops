"""
This file is to run control_node and 
tuning_node to remote control Nemo while 
tuning the motor gains using tuning_node's gui. 
"""

from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    return LaunchDescription([
        Node(
            package='sub_control',
            node_executable='service',
            output='screen',
        ),
        Node(
            package='sub_control',
            node_executable='tuning',
            output='screen'
        )
    ])