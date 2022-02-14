"""
For now, it's necessary to launch the Gazebo simulator through the ros1 workspace.
This file is to run mission, control, vision nodes to work with the simulator.
"""

from launch import LaunchDescription
from launch_ros.actions import Node

def generate_launch_description():
    return LaunchDescription([
        Node(
            package='sub_vision_yolov5',
            node_executable='vision',
            output='screen',
            parameters=[
                {"SIM": True}
            ]
        ),
        Node(
            package='sub_control',
            node_executable='service',
            output='screen',
            parameters=[
                {"SIM": True}
            ]
        ),
        Node(
            package='sub_mission',
            node_executable='mission',
            output='screen',
            parameters=[
                {"COIN_FLIP": True},
                {"GATE": True},
                {"TARGET": True},
                {"BINS": True},
                {"OCTAGON": True},
                {"POOL_B": True},
                {"TAILS": True},
                {"SIM": True}
            ]
        ),

        # Launch image display
        Node(
            package='rqt_image_view',
            node_executable='rqt_image_view',
            output='screen'
        )
    ])