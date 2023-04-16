"""
This file is to run mission_node (controlled by restart_runner node), 
control_node, vision_node, and acquisition_node for the sub to complete 
the mission in POOL A (either competition or at a pool test).

This is recommended for competition because if we decide to restart our run, 
the kill switch will kill the mission, and when the kill switch is turned on again,
the mission will restart (which won't happen with the normal launch_mission.py)
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
            package='sub_vision_yolov8',
            node_executable='vision',
            output='screen',
            parameters=[
                {"LOG_FRONT": True},
                {"LOG_DOWN": True},
            ]
        ),
        Node(
            package='sub_control',
            node_executable='control',
            output='screen'
        ),
        Node(
            package='sub_mission',
            node_executable='restart',
            output='screen',
            parameters=[
                {"COIN_FLIP": True},
                {"GATE": True},
                {"BUOY": True},
                {"BINS": True},
                {"OCTAGON": True},
                {"HEADS": True}
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
