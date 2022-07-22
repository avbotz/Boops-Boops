"""
This file is to run mission_node, control_node, vision_node, and acquisition_node 
for the sub to complete the mission in POOL D (either competition or at a pool test)
"""

from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    return LaunchDescription([
        Node(
            package='sub_acquisition',
            node_executable='acquisition',
            output='screen'
        ),
        Node(
            package='sub_vision_yolov5',
            node_executable='vision',
            output='screen',
            parameters=[
                {"LOG_FRONT": False},
                {"LOG_DOWN": False},
            ]
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
                {"COIN_FLIP": True},
                {"GATE": True},
                {"BUOY": True},
                {"BINS": True},
                {"OCTAGON": True},
                {"POOL_D": True},
                {"TAILS": True}
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