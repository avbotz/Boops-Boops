"""
This file is to run mission_node (controlled by restart_runner node), 
control_node, vision_node, and acquisition_node for the sub to complete 
the mission in POOL C (either competition or at a pool test).

This is recommended for competition because if we decide to restart our run, 
the kill switch will kill the mission, and when the kill switch is turned on again,
the mission will restart (which won't happen with the normal launch_mission.py)
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
            node_executable='restart',
            output='screen',
            parameters=[
                {"COIN_FLIP": True}
                {"GATE": True},
                {"BINS": True},
                {"TARGET": True},
                {"OCTAGON": True},
                {"POOL_C": True},
                {"TAILS": True}
            ]
        ),

        # Launch image display
        Node(
            package='rqt_image_view',
            node_executable='rqt_image_view',
            output='screen'
        )
    ])